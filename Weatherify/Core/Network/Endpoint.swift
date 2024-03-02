//
//  Endpoint.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import Foundation

enum Endpoint {
    case getAllWeathers
    case getWeathers(limit: Int)
    
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .getAllWeathers:
            return nil
        case .getWeathers(let limit):
            return [URLQueryItem(name: "limit", value: "\(limit)")]
        }
    }
    
    private var path: String {
        switch self {
        case .getAllWeathers, .getWeathers:
            return "weathers"
        }
    }
    
    var url: String {
        if let baseURL = URL(string: NetworkHelper.shared.baseUrl),
           var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true) {
            components.queryItems = queryItems
            return components.url?.absoluteString ?? ""
        }
        
        return ""
    }
}
