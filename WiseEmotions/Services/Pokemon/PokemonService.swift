//  
//  PokemonService.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import ReactiveSwift
import CoreData

final class PokemonService: PokemonUseCase {
    private enum C {
        static let limitOfConcurrentRequests: UInt = 5
        static let limitOfConcurrentListRequests: UInt = 1
    }
    
    // MARK: - Private Properties
    
    private let network: Network
    private let database: CoreDataDatabase
    
    // MARK: - Properties
    
    var setupProducer: SignalProducer<CoreDataStack, AppError> {
        database.setupProducer
    }
    
    // MARK: - Lifecycle
    
    init(network: Network, database: CoreDataDatabase) {
        self.network = network
        self.database = database
    }
    
    // MARK: - PokemonUseCase
    
    func fetchPokemonList(with limitOffset: LimitOffset) -> AsyncTask<PokemonsPage> {
        network
            .reactive
            .request(API.Pokemons.fetch(limitOffset: limitOffset))
            .decode(APIPageResponse<[BaseModel.Response]>.self)
            .map { ($0.results.compactMap(BaseModel.init), LimitOffset(offset: limitOffset.offset + limitOffset.limit,
                                                                       limit: limitOffset.limit,
                                                                       total: ($0.count ?? 1) - 1)) }
            .flatMap(.latest) { [unowned self] page -> AsyncTask<PokemonsPage> in
                let models = page.0.chunked(into: LimitOffset.defaultLimit)
                return SignalProducer(models)
                    .flatMap(.concurrent(limit: C.limitOfConcurrentListRequests), self.fetchPokemons)
                    .collect()
                    .flatten()
                    .map { ($0, page.1) }
            }
    }
    
    func pokemonsFetchRequest() -> NSFetchRequest<PokemonEntity> {
        let fetchRequest = NSFetchRequest<PokemonEntity>(entityName: String(describing: PokemonEntity.self))
        let sortDescriptor = NSSortDescriptor(keyPath: \PokemonEntity.id, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func fetchInfo(from pokemon: Pokemon) -> AsyncTask<Pokemon> {
        typealias Info = (stats: [Stat], types: [Type])
        return database.performToChildViewContext { context -> PokemonEntity? in
            let pokemonEntity = try context.fetchOrCreate(entity: PokemonEntity.self,
                                                          with: PokemonEntity
                                                            .findPredicate(id: pokemon.id))
            if pokemonEntity.typesArray.count != 0 || pokemonEntity.statsArray.count != 0 {
                return pokemonEntity
            } else {
                return nil
            }
        }.flatMap(.latest) { [unowned self] pokemonEntity -> AsyncTask<Pokemon> in
            if let entity = pokemonEntity {
                return AsyncTask(value: Pokemon(from: entity))
            } else {
                return fetchStats(by: pokemon.shortStats, pokemonID: pokemon.id)
                    .flatMap(.latest) { [unowned self] stats -> AsyncTask<Info> in
                        fetchTypes(by: pokemon.shortTypes, pokemonID: pokemon.id)
                            .map { types -> Info in
                                (stats, types)
                            }
                    }.flatMap(.latest) { [unowned self] info -> AsyncTask<Pokemon> in
                        self.database.performToChildViewContext { [unowned self] context -> Pokemon in
                                let pokemonEntity = try context.fetchOrCreate(entity: PokemonEntity.self,
                                                                              with: PokemonEntity
                                                                                .findPredicate(id: pokemon.id))
                                try pokemon.update(pokemonEntity)
                                
                            try info.stats.forEach {
                                try handle($0, in: context, to: pokemonEntity)
                            }
                            try info.types.forEach {
                                try handle($0, in: context, to: pokemonEntity)
                            }
                            
                            self.save(context)
                            return Pokemon(from: pokemonEntity)
                        }
                    }
            }
        }
    }
    
    // MARK: - Helper methods
    
    private func fetchPokemons(by baseModels: [BaseModel]) -> AsyncTask<[Pokemon]> {
        SignalProducer(baseModels)
            .flatMap(.concurrent(limit: C.limitOfConcurrentRequests), fetchPokemon)
            .collect()
            .flatMap(.latest) { [unowned self] pokemons -> AsyncTask<[Pokemon]> in
                self.savePokemons(pokemons).map(value: pokemons)
            }
    }
    
    private func fetchStats(by shortStats: [ShortStat], pokemonID: Int64) -> AsyncTask<[Stat]> {
        SignalProducer(shortStats.compactMap { ShortStatWithLink(shortStat: $0, pokemonID: pokemonID) })
            .flatMap(.concurrent(limit: C.limitOfConcurrentRequests), fetchStat)
            .collect()
    }
    
    private func fetchTypes(by shortTypes: [ShortType], pokemonID: Int64) -> AsyncTask<[Type]> {
        SignalProducer(shortTypes.compactMap { ShortTypeWithLink(shortType: $0, pokemonID: pokemonID) })
            .flatMap(.concurrent(limit: C.limitOfConcurrentRequests), fetchType)
            .collect()
    }
    
    private func fetchPokemon(by baseModel: BaseModel) -> AsyncTask<Pokemon> {
        network
            .reactive
            .request(API.Pokemons.fetchPokemon(url: baseModel.url))
            .decode(Pokemon.Response.self)
            .map(Pokemon.init)
    }
    
    private func fetchStat(by model: ShortStatWithLink) -> AsyncTask<Stat> {
        network
            .reactive
            .request(API.Information.fetchStat(url: model.link))
            .decode(Stat.Response.self)
            .map { Stat(from: $0, shortStat: model.shortStat, pokemonID: model.pokemonID) }
    }
    
    private func fetchType(by model: ShortTypeWithLink) -> AsyncTask<Type> {
        network
            .reactive
            .request(API.Information.fetchType(url: model.link))
            .decode(Type.Response.self)
            .map { Type(from: $0, shortType: model.shortType, pokemonID: model.pokemonID) }
    }
    
    private func savePokemons(_ pokemons: [Pokemon]) -> AsyncTask<Void> {
        guard !pokemons.isEmpty else { return .empty }
        return database.performToChildViewContext { [unowned self] context -> Void in
            try pokemons.forEach { pokemon in
                let pokemonEntity = try context.fetchOrCreate(for: pokemon, with: PokemonEntity.findPredicate(id: PokemonEntity.ID(pokemon.id)))
                try pokemon.update(pokemonEntity)
                
                try pokemon.shortStats.forEach {
                    try handle($0, in: context, to: pokemonEntity)
                }
                try pokemon.shortTypes.forEach {
                    try handle($0, in: context, to: pokemonEntity)
                }
            }
            self.save(context)
        }.flatMapError { _ -> AsyncTask<Void> in .init(value: ()) }
    }
    
    private func save(_ context: NSManagedObjectContext) {
        context.performAndWait {
            guard context.hasChanges else { return }
            do {
                try context.save()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
        context.parent?.performAndWait {
            guard context.parent?.hasChanges ?? false else { return }
            do {
                try context.parent?.save()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
    }
    
    private func handle(_ shortStat: ShortStat,
                        in context: NSManagedObjectContext,
                        to pokemonEntity: PokemonEntity) throws {
        let shortStatEntity = try context.fetchOrCreate(entity: ShortStatEntity.self,
                                                        with: ShortStatEntity.findPredicate(id: shortStat.id))
        try shortStat.update(shortStatEntity)
        pokemonEntity.addToShortStats(shortStatEntity)
        shortStatEntity.pokemon = pokemonEntity
    }
    
    private func handle(_ shortType: ShortType,
                        in context: NSManagedObjectContext,
                        to pokemonEntity: PokemonEntity) throws {
        let shortTypeEntity = try context.fetchOrCreate(entity: ShortTypeEntity.self,
                                                        with: ShortStatEntity
                                                            .findPredicate(id: shortType.id))
        try shortType.update(shortTypeEntity)
        pokemonEntity.addToShortTypes(shortTypeEntity)
        shortTypeEntity.pokemon = pokemonEntity
    }
    
    private func handle(_ stat: Stat,
                        in context: NSManagedObjectContext,
                        to pokemonEntity: PokemonEntity) throws {
        let statEntity = try context.fetchOrCreate(entity: StatEntity.self,
                                                   with: StatEntity.findPredicate(id: stat.id))
        try stat.update(statEntity)
        pokemonEntity.addToStats(statEntity)
        statEntity.pokemon = pokemonEntity
    }
    
    private func handle(_ type: Type,
                        in context: NSManagedObjectContext,
                        to pokemonEntity: PokemonEntity) throws {
        let typeEntity = try context.fetchOrCreate(entity: TypeEntity.self,
                                                   with: TypeEntity.findPredicate(id: type.id))
        try type.update(typeEntity)
        pokemonEntity.addToTypes(typeEntity)
        typeEntity.pokemon = pokemonEntity
    }
}
