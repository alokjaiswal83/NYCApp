//
//  NYCAPIManager.swift
//  NYCApp
//
//  Created by Alok Jaiswal on 04/01/23.
//

import Foundation

/// Enum for possible error cases
enum NYCAPIError: Error {
    case invalidURL
    case responseError
    case somethingWentWrong
    case decodeError
    case unreachable
}

extension NYCAPIError {
    /// Error message
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NYCErrorConstants.invalidURL
        case .responseError:
            return NYCErrorConstants.responseError
        case .somethingWentWrong:
            return NYCErrorConstants.somethingWentWrong
        case .decodeError:
            return NYCErrorConstants.decodeError
        case .unreachable:
            return NYCErrorConstants.unreachable
        }
    }
}

/// Singleton class for API
class NetworkManager {
    //private let imageCache = NSCache<NSString, NSData>()

    static let shared = NetworkManager()
    private init() {
    }
    
    /// function used to call the api
    /// - Parameters:
    ///   - _urlRequest: Url request(headers, http method)
    ///   - type: Place holder for model type
    ///   - completionHandler: result types which includes success and failure data
     func excute<T : Decodable>(with endpoint: HTTPRequest, type: T.Type, completionHandler: @escaping ((Result<T, NYCAPIError>) -> Void)) {
         
         if serviceType == .OFFLLINE {
             let apiName = (endpoint as! ServiceEndpoints == NYCApp.ServiceEndpoints.schoolList) ? "school" : "schooldetails"
             guard
                 let url = Bundle.main.url(forResource: apiName, withExtension: "json"),
                  let data = try? Data(contentsOf: url)
             else {
                  completionHandler(.failure(.somethingWentWrong))
                  return
             }
             NetworkManager.shared.decode(data, completionHandler: completionHandler)
             return
         }
         
         guard NetworkStateCheck.isConnectedToNetwork() else {
             completionHandler(.failure(.unreachable))
             return
         }

         var components = URLComponents()
         components.scheme = endpoint.scheme
         components.host = endpoint.baseURL
         components.path = endpoint.path
        // components.queryItems = endpoint.parameters

         guard let url = components.url else {
             completionHandler(.failure(NYCAPIError.invalidURL))
             return
         }

         var urlRequest = URLRequest(url: url)
         urlRequest.httpMethod = endpoint.method
         urlRequest.httpBody = endpoint.data

         endpoint.headers?.forEach { urlRequest.addValue($0.header.value, forHTTPHeaderField: $0.header.field) }
         dataTaskHandler(urlRequest: urlRequest) { data, error in
             if let error = error {
                 completionHandler(.failure(error))
             } else if let data = data {
                 self.decode(data, completionHandler: completionHandler)
             }
         }
    }
    
    /// Download image with image url
    /// - Parameters:
    ///   - urlString: image url
    ///   - completionHandler: return type with image data and error
    func downloadImage(withUrl urlString: String, completionHandler: @escaping ((Result<Data, NYCAPIError>) -> Void)) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        let urlRequest = URLRequest(url: url)
        dataTaskHandler(urlRequest: urlRequest) { data, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                completionHandler(.success(data))
            }
        }
    }
    
    private func dataTaskHandler(urlRequest: URLRequest, completionHandler: @escaping ((Data?, NYCAPIError?) -> Void)) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let responseStatus = response as? HTTPURLResponse, responseStatus.statusCode == 200 else {
                completionHandler(nil, NYCAPIError.somethingWentWrong)
                return
            }
//            if let cachedImage = imageCache.object(forKey: urlString as NSString) {
//                completionHandler(.success(cachedImage as Data))
//                return
//            }
            guard let data = data, error == nil else {
                completionHandler(nil, NYCAPIError.responseError)
                return
            }
            //self.imageCache.setObject(data as NSData, forKey: urlString as NSString)

            completionHandler(data, nil)
        }
        dataTask.resume()
    }
}

extension NetworkManager {
    /// Generic func to parse the response data into model
    /// - Parameters:
    ///   - data: response data from api
    ///   - completionHandler: result types which includes success and failure data
    func decode<T: Decodable>(_ data: Data, completionHandler: @escaping ((Result<T, NYCAPIError>) -> Void)) {
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            completionHandler(.success(model))
        } catch _ {
            completionHandler(.failure(NYCAPIError.decodeError))
            
        }
    }
}

