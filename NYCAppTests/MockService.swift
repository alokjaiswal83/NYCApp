//
//  MockService.swift
//  NYCAppTests
//
//  Created by Alok Jaiswal on 05/01/23.
//

import Foundation
@testable import NYCApp

enum ResponseFileName: String {
    case success = "school"
    case detailsServiceSuccess = "schooldetails"
    case failure = "school_error"
    case noData = "school_empty"
}
/// Mock service
class NYCAPIMockService: SchoolsServiceProtocol {
    /// variable for caching downlaoded images
    private let imageCache = NSCache<NSString, NSData>()
    var responseFileName: ResponseFileName?
    
    private(set) var isSchoolServiceMethodCalled = false
    private(set) var isSchoolDetailsServiceMethodCalled = false
    private(set) var isImageServiceMethodCalled = false

    init(responseFileName: ResponseFileName?) {
        self.responseFileName = responseFileName
    }
    /// Function to get list of school from  mock json
    /// - Parameters:
    ///   - endPoint:api end point url
    ///   - completionHandler: returns result types which includes success(NYCSchools) and failure data
    func schoolsService(completionHandler: @escaping ((Result<NYCSchools, NYCAPIError>) -> Void)) {
        isSchoolServiceMethodCalled = true
        guard
            let url = Bundle.main.url(forResource: responseFileName?.rawValue, withExtension: "json"),
             let data = try? Data(contentsOf: url)
        else {
             completionHandler(.failure(.somethingWentWrong))
             return
        }
        NetworkManager.shared.decode(data, completionHandler: completionHandler)
    }
    
    /// Function to get list of school from  mock json
    /// - Parameters:
    ///   - endPoint:api end point url
    ///   - completionHandler: returns result types which includes success(NYCSchoolDetails) and failure data
    func schoolsDetailService(completionHandler: @escaping ((Result<NYCSchoolDetails, NYCAPIError>) -> Void)) {
        isSchoolDetailsServiceMethodCalled = true
        guard
            let url = Bundle.main.url(forResource: responseFileName?.rawValue, withExtension: "json"),
             let data = try? Data(contentsOf: url)
        else {
             completionHandler(.failure(.somethingWentWrong))
             return
        }
        NetworkManager.shared.decode(data, completionHandler: completionHandler)
    }
    
    /// mock image service
    /// - Parameters:
    ///   - urlString: image url
    ///   - completionHandler: returns result types which includes success(image) and failure data
    func downloadImageService(withUrl urlString: String, completionHandler: @escaping ((Result<Data, NYCAPIError>) -> Void)) {
        isImageServiceMethodCalled = true
        guard URL(string: urlString) != nil else {
            completionHandler(.failure(.invalidURL))
            return
        }
        /// check image already available in cache
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completionHandler(.success(cachedImage as Data))
            return
        }
        guard let data = urlString.data(using: .utf8) else {
            completionHandler(.failure(.responseError))
            return
        }
        
        /// store image in cache
        self.imageCache.setObject(data as NSData, forKey: urlString as NSString)
        completionHandler(.success(data))
    }
}

