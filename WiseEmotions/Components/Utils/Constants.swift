//
//  Constants.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit


typealias BaseModelsPage = (models: [BaseModel], pagination: LimitOffset)

public let offset: CGFloat = 16.0
public let titleFontSize: CGFloat = 14.0
public let defaultFontSize: CGFloat = 16.0
public let defaultHeaderHeight: CGFloat = 54.0
public let defaultImageSize = CGSize(width: 64.0, height: 64.0)
public let defaultLoaderSize = CGSize(width: 48.0, height: 48.0)
public let screenWidth = UIScreen.main.bounds.width
public let screenHeight = UIScreen.main.bounds.height
public let defaultLanguage = "en"

public let pokemonPlaceholder = UIImage(named: "pokeball")


public var baseURL: URL = {
    guard let url = URL(string: "https://pokeapi.co/api/v2") else {
        fatalError("Check baseURL")
    }
    return url
}()

public func localizedString(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

public func configureID(from ownerID: Int64, string: String) -> String {
    "\(ownerID) \(string)"
}

