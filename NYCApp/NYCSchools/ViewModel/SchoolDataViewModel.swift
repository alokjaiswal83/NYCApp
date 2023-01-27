//
//  SchoolDataViewModel.swift
//  NYCApp
//
//  Created by Alok Jaiswal on 03/01/23.
//

import UIKit

/// used this delegate to pass the data from dataviewmodel to view
protocol SchoolsDataViewModelDelegate: AnyObject {
    func didImageDownload(data: Data?, error: String?)
}

class SchoolsDataViewModel {
    private let serviceManager: SchoolsServiceProtocol?
    //weak var delegate: SchoolsDataViewModelDelegate?
    let school: NYCSchoolModel?

    init(with school: NYCSchoolModel, serviceManager: SchoolsServiceProtocol = APIService()) {
        self.school = school
        self.serviceManager = serviceManager
    }

    var title: String {
        return self.school?.schoolName ?? ""
    }

    var subtitle: String {
        return address + "\n" + city + " " + zip
    }

    var city: String {
        return self.school?.city.trimmingCharacters(in: .whitespaces) ?? ""
    }
    
    var zip: String {
        return self.school?.zip ?? ""
    }

    var overView: String {
        return self.school?.overviewParagraph ?? ""
    }
    
    var address: String {
        return self.school?.primaryAddressLine1 ?? ""
    }
    
    var dbn: String {
        self.school?.dbn ?? ""
    }

    func getImage() -> UIImage {
        return  UIImage(named: schoolImage[title.count % 5] ) ?? UIImage()
    }
}
