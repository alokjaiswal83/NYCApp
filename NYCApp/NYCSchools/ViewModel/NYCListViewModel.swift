//
//  NYCSchoolViewModel.swift
//  NYCApp
//
//  Created by Alok Jaiswal on 03/01/23.
//

import Foundation

class NYCSchoolsViewModel: NSObject {
    
    let serviceManager: SchoolsServiceProtocol?
    var error: Observable<String?> = Observable(nil)
    var schoolCellViewModels: Observable<[SchoolsDataViewModel]> = Observable([])
   
    // initializer
    init(serviceManager: SchoolsServiceProtocol = APIService()) {
        self.serviceManager = serviceManager
    }
    
    func getSchools() {
        serviceManager?.schoolsService(completionHandler: { result in
            switch result {
            case .success(let school):
                self.schoolCellViewModels.value = school.compactMap{ SchoolsDataViewModel (with: $0)}
            case .failure(let error):
                self.error.value = error.errorDescription
            }
        })
    }
    
    /// returns cellViewModel based on tableview indexpath
    /// - Parameter indexPath: Indexpath
    /// - Returns: cell ciew model
    func getCellViewModel(at indexPath: IndexPath) -> SchoolsDataViewModel {
        return schoolCellViewModels.value[indexPath.row]
    }
}
