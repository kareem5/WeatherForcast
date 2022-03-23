//
//  APIClient.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import Combine
import Foundation

protocol APIClient {
    func fetch<T>(endpoint: Endpoint, params: [String: Any]?) -> AnyPublisher<T, Error> where T: Decodable
}

extension APIClient {
    func fetch<T>(endpoint: Endpoint, params: [String: Any]? = nil) -> AnyPublisher<T, Error> where T: Decodable {
        var urlRequest = URLRequest(url: endpoint.finalURL)//URLRequest(url: endpoint.baseURL.appendingPathComponent(endpoint.path))
        urlRequest.httpMethod = endpoint.method.rawValue
        endpoint.headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        if let params = params {
            let body = try? JSONSerialization.data(withJSONObject: params, options: [])
            print("body: \(String(describing: body))")
            urlRequest.httpBody = body
        }
        
        
        print("urlRequest: \(urlRequest.description)")
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
                    .tryMap({ element -> Data in
                        print("Recieved urlRequest: \(urlRequest.url) on thread \(Thread.current)")

                        guard let httpResponse = element.response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 else {
                                throw URLError(.badServerResponse)
                            }
                        let str = String(decoding: element.data, as: UTF8.self)
//                        print("response: \(str)")
                        return element.data
                        })
//            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
