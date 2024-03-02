//
//  NetworkManager.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Codable>(type: T.Type, endpoint: Endpoint, httpMethod: HTTPMethods, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let urlSession = URLSession.shared
        if let url = URL(string: endpoint.url) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod.rawValue
            
            let task = urlSession.dataTask(with: urlRequest) { data, response, error in
                if error != nil {
                    completion(.failure(.requestFailed))
                } else if let httpResponse = response as? HTTPURLResponse {
                    if 200..<300 ~= httpResponse.statusCode {
                        if let data {
                            do {
                                let result = try JSONDecoder().decode(T.self, from: data)
                                completion(.success(result))
                            } catch {
                                completion(.failure(.decodingError))
                            }
                        } else {
                            completion(.failure(.invalidData))
                        }
                    } else {
                        completion(.failure(.invalidResponse(httpResponse.statusCode)))
                    }
                } else {
                    completion(.failure(.requestFailed))
                }
            }
            
            task.resume()
        } else {
            completion(.failure(.invalidURL))
        }
    }
}
