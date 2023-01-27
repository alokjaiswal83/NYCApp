//
//  NYCSchoolTests.swift
//  NYCAppTests
//
//  Created by Alok Jaiswal on 05/01/23.
//

import XCTest
@testable import NYCApp

final class NYCSchoolTests: XCTestCase {

    var schoolViewModel: NYCSchoolsViewModel?
    var schoolServiceManager: NYCAPIMockService!

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        schoolViewModel = nil
        schoolServiceManager = nil
    }
    
    /// Test mock Success service
    func testGetNYCSchoolsSuccess() {
        let requestExpectation = expectation(description: "Request should finish with Schools")
        schoolServiceManager = NYCAPIMockService(responseFileName: .success)
        schoolViewModel = NYCSchoolsViewModel(serviceManager: schoolServiceManager)

        schoolViewModel?.getSchools()
        XCTAssertTrue(schoolServiceManager.isSchoolServiceMethodCalled, "ServiceManager method should be called.")
        schoolViewModel?.schoolCellViewModels.bind { schoolCellViewModel in
            XCTAssertEqual(schoolCellViewModel.count, 2, "its should equal to mock data of count 2")
            XCTAssertNotNil(schoolCellViewModel[0].title)
            XCTAssertNotNil(schoolCellViewModel[0].subtitle)
            requestExpectation.fulfill()
        }
        wait(for: [requestExpectation], timeout: 3)
    }
    
    /// Test mock failure service
    func testGetNYCSchoolsFailure() {
        let requestExpectation = expectation(description: "Request should finish with error")
        schoolServiceManager = NYCAPIMockService(responseFileName: .failure)
        schoolViewModel = NYCSchoolsViewModel(serviceManager: schoolServiceManager)

        schoolViewModel?.getSchools()
        XCTAssertTrue(schoolServiceManager.isSchoolServiceMethodCalled, "ServiceManager method should be called.")
        schoolViewModel?.error.bind { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error, "Failed to parse data.")
            requestExpectation.fulfill()

        }
        wait(for: [requestExpectation], timeout: 3)
    }
    
    /// Test mock empty response
    func testGetNYCSchoolsNoData() {
        let requestExpectation = expectation(description: "Request should finish with empty response")
        schoolServiceManager = NYCAPIMockService(responseFileName: .noData)
        schoolViewModel = NYCSchoolsViewModel(serviceManager: schoolServiceManager)

        schoolViewModel?.getSchools()
        XCTAssertTrue(schoolServiceManager.isSchoolServiceMethodCalled, "ServiceManager method should be called.")
        schoolViewModel?.schoolCellViewModels.bind { result in
            XCTAssertEqual(result.count, 0, "it should be no data")
            requestExpectation.fulfill()

        }
        wait(for: [requestExpectation], timeout: 3)
    }
    
    /// Test success mock response data
    func testGetNYCSchoolsResponse() {
        let requestExpectation = expectation(description: "Request should finish with Schools")
        schoolServiceManager = NYCAPIMockService(responseFileName: .success)
        schoolViewModel = NYCSchoolsViewModel(serviceManager: schoolServiceManager)

        schoolViewModel?.getSchools()
        XCTAssertTrue(schoolServiceManager.isSchoolServiceMethodCalled, "ServiceManager method should be called.")
        schoolViewModel?.schoolCellViewModels.bind { schoolCellViewModel in
            XCTAssert(schoolCellViewModel[1].title == "University Neighborhood High School")
            XCTAssertTrue(schoolCellViewModel[1].city == "MANHATTAN")
            XCTAssert(schoolCellViewModel[1].zip == "10002")
            XCTAssert(schoolCellViewModel[1].subtitle == "200 MONROE STREET\nMANHATTAN 10002")
            XCTAssert(schoolCellViewModel[1].address == "200 MONROE STREET")
            XCTAssert(schoolCellViewModel[1].dbn == "01M448")
            XCTAssert(schoolCellViewModel[1].overView == "University Neighborhood High School (UNHS) is the first collaborative partnership school between New York University and the New York City Department of Education. We are proud to provide all kinds of learners with a challenging curriculum in a supportive environment so that they can successfully participate in higher education opportunities and the workforce.")
            requestExpectation.fulfill()

        }
        wait(for: [requestExpectation], timeout: 3)
    }
    
}
