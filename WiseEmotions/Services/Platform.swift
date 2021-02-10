//
//  Platform.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

final class Platform: UseCasesProvider {
    
    // MARK: - UseCases
    
    var pokemon: PokemonUseCase
    var information: InformationUseCase
    var download: DownloadUseCase
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Private Properties
    
    private var network: Network
    private let database: CoreDataDatabase
    
    // MARK: - Lifecycle
    
    init() {
        let plugins: [NetworkPlugin] = [APIErrorPlugin()]
        
        network = Network(baseURL: baseURL,
                          plugins: plugins)
        database = CoreDataDatabase()
        pokemon = PokemonService(network: network, database: database)
        information = InformationService(network: network)
        download = DownloadService(imageCache: imageCache)
    }
}
