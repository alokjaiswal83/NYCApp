//
//  APIService.swift
//  NYCApp
//
//  Created by Alok Jaiswal on 04/01/23.
//

import Foundation

/// Protocol used for dependancy injection
protocol SchoolsServiceProtocol {
    func schoolsService(completionHandler: @escaping ((Result<NYCSchools, NYCAPIError>) -> Void))
    func schoolsDetailService(completionHandler: @escaping ((Result<NYCSchoolDetails, NYCAPIError>) -> Void))
    func downloadImageService(withUrl urlString: String, completionHandler: @escaping ((Result<Data, NYCAPIError>) -> Void))
}

/// Enum for  service endpoints
enum ServiceEndpoints: String {
    case schoolList = "school"
    case schoolDetials = "schooldetails"
}

/// Extension for service request
extension ServiceEndpoints: HTTPRequest {
    var path: String {
        switch self {
        case .schoolList:
            return "/resource/7crd-d9xh.json"
        case .schoolDetials:
            return "/resource/f9bf-2cp4.json"
        }
    }
}

/// API service layer
struct APIService: SchoolsServiceProtocol {
    
    /// variable for caching downlaoded images
    private let imageCache = NSCache<NSString, NSData>()
    
    ///  Function to get list of schools details
    /// - Parameters:
    /// - endPoint: api school details end point url
    /// - completionHandler: returns result types which includes success(NYCSchoolDetails) and failure data
    func schoolsDetailService(completionHandler: @escaping ((Result<NYCSchoolDetails, NYCAPIError>) -> Void)) {
        let urlRequest = ServiceEndpoints.schoolDetials
        NetworkManager.shared.excute(with: urlRequest, type: NYCSchoolDetails.self) { result in
            switch result {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    /// Function to get list of schools
    /// - Parameters:
    ///   - endPoint: api end point url
    ///   - completionHandler: returns result types which includes success(NYCSchools) and failure data
    func schoolsService(completionHandler: @escaping ((Result<NYCSchools, NYCAPIError>) -> Void))  {
        let urlRequest = ServiceEndpoints.schoolList
        NetworkManager.shared.excute(with: urlRequest, type: NYCSchools.self) { result in
            switch result {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    /// download image and save to cache
    /// - Parameters:
    ///   - urlString: image url sting
    ///   - completionHandler: result type which includes success(image data) and error
    func downloadImageService(withUrl urlString: String, completionHandler: @escaping ((Result<Data, NYCAPIError>) -> Void)) {
        /// check image already available in cache
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completionHandler(.success(cachedImage as Data))
            return
        }
        NetworkManager.shared.downloadImage(withUrl: urlString) { result in
            switch result {
            case .success(let data):
                /// store image in cache
                self.imageCache.setObject(data as NSData, forKey: urlString as NSString)
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
