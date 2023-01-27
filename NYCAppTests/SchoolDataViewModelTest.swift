//
//  SchoolDataViewModelTest.swift
//  NYCAppTests
//
//  Created by Alok Jaiswal on 05/01/23.
//

import XCTest
@testable import NYCApp

final class SchoolDataViewModelTest: XCTestCase {

    var schoolDataViewModel: SchoolsDataViewModel?
    var schoolServiceManager: NYCAPIMockService!
    
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        schoolDataViewModel = nil
        schoolServiceManager = nil
    }

    func testSchoolViewModelWithData() {
        schoolServiceManager = NYCAPIMockService(responseFileName: .success)
        let school = NYCSchoolModel(dbn: "01M292", schoolName: "Henry Street School for International Studies", boro: "Manhattan", buildingCode: "M056", sharedSpace: "Yes", phoneNumber: "212-406-9411", primaryAddressLine1: "220 HENRY STREET", city: "MANHATTAN", stateCode: "NY", zip: "100002", website: "http://schools.nyc.gov/SchoolPortals/01/M292", totalStudents: "255", overviewParagraph: "Henry Street School for International Studies is a unique small school founded by the Asia Society. While in pursuit of knowledge about other world regions, including their histories, economies and world languages, students acquire the knowledge and skills needed to prepare for college and/or careers.")
        
        schoolDataViewModel = SchoolsDataViewModel(with: school, serviceManager: schoolServiceManager)
        
        XCTAssertEqual(schoolDataViewModel?.title, "Henry Street School for International Studies")
        XCTAssertEqual(schoolDataViewModel?.subtitle, "220 HENRY STREET\nMANHATTAN 100002")
        XCTAssertEqual(schoolDataViewModel?.address, "220 HENRY STREET")
        XCTAssertEqual(schoolDataViewModel?.city, "MANHATTAN")
        XCTAssertEqual(schoolDataViewModel?.zip, "100002")
        XCTAssertEqual(schoolDataViewModel?.overView, "Henry Street School for International Studies is a unique small school founded by the Asia Society. While in pursuit of knowledge about other world regions, including their histories, economies and world languages, students acquire the knowledge and skills needed to prepare for college and/or careers.")
        XCTAssertEqual(schoolDataViewModel?.dbn, "01M292")
    }
}
