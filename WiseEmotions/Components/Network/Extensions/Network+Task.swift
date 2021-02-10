//
//  Network+Task.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import Alamofire

extension Network {
    enum Task {
        /// A request with no additional data.
        case requestPlain

        /// A requests body set with data.
        case requestData(Data)

        /// A request body set with `Encodable` type
        case requestJSONEncodable(Encodable)

        /// A request body set with `Encodable` type and custom encoder
        case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)

        /// A requests body set with encoded parameters.
        case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
        
        /// A requests body set with encoded parameters.
        case requestWithParameters(parameters: Parameters, encoding: ParameterEncoding)

        /// A requests body set with data, combined with url parameters.
        case requestCompositeData(bodyData: Data, urlParameters: [String: Any])

        /// A requests body set with encoded parameters combined with url parameters.
        case requestCompositeParameters(bodyParameters: [String: Any], bodyEncoding: ParameterEncoding, urlParameters: [String: Any])

        /// A file upload task.
        case uploadFile(URL)

        /// A "multipart/form-data" upload task.
        case uploadMultipart(MultipartFormDataBuilder)

        /// A "multipart/form-data" upload task  combined with url parameters.
        case uploadCompositeMultipart(urlParameters: [String: Any], MultipartFormDataBuilder)

        /// A file download task to a destination.
        case downloadDestination(DownloadDestination)

        /// A file download task to a destination with extra parameters using the given encoding.
        case downloadParameters(parameters: [String: Any], encoding: ParameterEncoding, destination: DownloadDestination)
    }
}
