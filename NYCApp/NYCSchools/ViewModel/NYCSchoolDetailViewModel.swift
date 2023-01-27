//
//  NYCSchoolDetailViewModel.swift
//  NYCApp
//
//  Created by Alok Jaiswal on 05/01/23.
//

import Foundation

/// used this delegate to pass the data from dataviewmodel to view
protocol SchoolImageDataDelegate: AnyObject {
    func didImageDownload(data: Data?, error: String?)
}

class NYCSchoolsDetailViewModel: NSObject {
    
    private let serviceManager: SchoolsServiceProtocol?
    var error: Observable<String?> = Observable(nil)
    var selectedSchoolModel: Observable<[NYCSchoolDetailModel]> = Observable([])
    weak var delegate: SchoolImageDataDelegate?
    var dbn: String?

    // initializer
    init(dbn: String, serviceManager: SchoolsServiceProtocol = APIService()) {
        self.serviceManager = serviceManager
        self.dbn = dbn
    }
    
    func getSchoolDetails() {
        serviceManager?.schoolsDetailService(completionHandler: { result in
            switch result {
            case .success(let school):
                self.selectedSchoolModel.value = school.filter({ $0.dbn == self.dbn})
                self.getImage(url: self.getRandomImageUrl())
            case .failure(let error):
                self.error.value = error.errorDescription
            }
        })
    }
    ///Get
    func getImage(url: String) {
        serviceManager?.downloadImageService(withUrl: url, completionHandler: { result in
            switch result {
            case .success(let data):
                self.delegate?.didImageDownload(data: data, error: nil)
            case .failure(let error):
                self.delegate?.didImageDownload(data: nil, error: error.errorDescription)
            }
        })
    }
    
    /// Some Random Image url seletion logic
    func getRandomImageUrl() -> String {
        if selectedSchoolModel.value.count != 0 {
            return booksImagesUrl[((Int(selectedSchoolModel.value[0].numOfSatTestTakers) ?? 0) % 5)]
        }
        return booksImagesUrl[0]
    }
}
