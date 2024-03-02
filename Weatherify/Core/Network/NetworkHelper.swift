//
//  NetworkHelper.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse(Int)
    case invalidData
    case decodingError

    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Url is invalid"
        case .requestFailed:
            return "Request failed"
        case .invalidResponse(let statusCode):
            return "Response is invalid. Status Code: \(statusCode)"
        case .invalidData:
            return "Data is invalid"
        case .decodingError:
            return "Data is not decoded"
        }
    }
}

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
    private init() {}
    
    let baseUrl = "https://freetestapi.com/api/v1/"
}
