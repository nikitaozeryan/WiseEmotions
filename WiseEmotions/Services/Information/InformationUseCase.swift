//  
//  InformationUseCase.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 08.02.2021.
//

import ReactiveSwift

protocol InformationUseCase {
    func fetchTypeList(with limitOffset: LimitOffset) -> AsyncTask<BaseModelsPage>
    func fetchStatList(with limitOffset: LimitOffset) -> AsyncTask<BaseModelsPage>
}
