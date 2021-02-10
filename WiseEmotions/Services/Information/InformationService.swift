//  
//  InformationService.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 08.02.2021.
//

import ReactiveSwift

final class InformationService: InformationUseCase {
    
    // MARK: - Private Properties
    
    private let network: Network
    
    // MARK: - Lifecycle
    
    init(network: Network) {
        self.network = network
    }
    
    // MARK: - InformationUseCase
    
    func fetchTypeList(with limitOffset: LimitOffset) -> AsyncTask<BaseModelsPage> {
        fetchBaseModelList(with: API.Information.fetchTypes(limitOffset: limitOffset), limitOffset: limitOffset)
    }
    
    func fetchStatList(with limitOffset: LimitOffset) -> AsyncTask<BaseModelsPage> {
        fetchBaseModelList(with: API.Information.fetchStats(limitOffset: limitOffset), limitOffset: limitOffset)
    }
    
    // MARK: - Helper methods
    
    func fetchBaseModelList(with request: RequestConvertible, limitOffset: LimitOffset) -> AsyncTask<BaseModelsPage> {
        network
            .reactive
            .request(request)
            .decode(APIPageResponse<[BaseModel.Response]>.self)
            .map { ($0.results.compactMap(BaseModel.init), LimitOffset(offset: limitOffset.offset + limitOffset.limit,
                                                                           limit: limitOffset.limit,
                                                                           total: $0.count)) }
    }
}
