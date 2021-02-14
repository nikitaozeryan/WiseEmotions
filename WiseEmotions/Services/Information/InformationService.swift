//  
//  InformationService.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 08.02.2021.
//

import ReactiveSwift
import Foundation

final class InformationService: InformationUseCase {
    
    // MARK: - Private Properties
    
    private let network: Network
    
    // MARK: - Lifecycle
    
    init(network: Network) {
        self.network = network
    }

    
    // MARK: - InformationUseCase
    
    func fetchTypeList(with limitOffset: LimitOffset) -> AsyncTask<BaseModelsPage> {
        return fetchBaseModelList(with: InformationAPI.fetchTypesPath, limitOffset: limitOffset)
    }
    
    func fetchStatList(with limitOffset: LimitOffset) -> AsyncTask<BaseModelsPage> {
        return fetchBaseModelList(with: InformationAPI.fetchStatsPath, limitOffset: limitOffset)
    }
    
    // MARK: - Helper methods
    
    func fetchBaseModelList(with url: String, limitOffset: LimitOffset) -> AsyncTask<BaseModelsPage> {
        switch request(by: url, parameters: limitOffset.parameters) {
        case .success(let request):
            return network.request(with: request,
                                   objectType: APIPageResponse<[BaseModel.Response]>.self)
                .map { ($0.results.compactMap(BaseModel.init), LimitOffset(offset: limitOffset.offset + limitOffset.limit,
                                                                           limit: limitOffset.limit,
                                                                           total: $0.count)) }
        case .failure(let error):
            return .init(error: error)
        }
    }
}
