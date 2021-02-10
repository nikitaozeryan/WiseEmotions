//
//  DomainTask.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import ReactiveSwift

typealias AsyncTask<Value> = SignalProducer<Value, AppError>
