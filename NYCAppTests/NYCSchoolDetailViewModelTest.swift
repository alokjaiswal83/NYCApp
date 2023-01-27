//
//  NYCSchoolDetailViewModelTest.swift
//  NYCAppTests
//
//  Created by Alok Jaiswal on 05/01/23.
//

import XCTest
@testable import NYCApp

final class NYCSchoolDetailViewModelTest: XCTestCase {
    
    var schoolViewModel: NYCSchoolsDetailViewModel?
    var schoolServiceManager: NYCAPIMockService!

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        schoolViewModel = nil
        schoolServiceManager = nil
    }
    
    /// Test mock Success service
    func testGetNYCSchoolsDetailSuccess() {
        let requestExpectation = expectation(description: "Request should finish with Schools Details")
        schoolServiceManager = NYCAPIMockService(responseFileName: .detailsServiceSuccess)
        schoolViewModel = NYCSchoolsDetailViewModel(dbn: "01M292", serviceManager: schoolServiceManager)

        schoolViewModel?.getSchoolDetails()
        XCTAssertTrue(schoolServiceManager.isSchoolDetailsServiceMethodCalled, "ServiceManager method should be called.")
        schoolViewModel?.selectedSchoolModel.bind { schoolViewModel in
            XCTAssertEqual(schoolViewModel.count, 1, "its should equal to mock data of count 2")
            XCTAssertNotNil(schoolViewModel[0].dbn)
            XCTAssertNotNil(schoolViewModel[0].schoolName)
            XCTAssertNotNil(schoolViewModel[0].satMathAvgScore)
            XCTAssertNotNil(schoolViewModel[0].satCriticalReadingAvgScore)
            XCTAssertNotNil(schoolViewModel[0].satWritingAvgScore)
            requestExpectation.fulfill()
        }
        wait(for: [requestExpectation], timeout: 3)
    }
    
    /// Test mock Success service
    func testGetNYCSchoolsDetailFailure() {
        let requestExpectation = expectation(description: "Request should finish with Schools Details")
        schoolServiceManager = NYCAPIMockService(responseFileName: .failure)
        schoolViewModel = NYCSchoolsDetailViewModel(dbn: "01M292", serviceManager: schoolServiceManager)

        schoolViewModel?.getSchoolDetails()
        XCTAssertTrue(schoolServiceManager.isSchoolDetailsServiceMethodCalled, "ServiceManager method should be called.")
        schoolViewModel?.error.bind { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error, "Failed to parse data.")
            requestExpectation.fulfill()

        }
        wait(for: [requestExpectation], timeout: 3)
    }
    
    /// Test mock Success service
    func testGetNYCSchoolsDetailNoData() {
        let requestExpectation = expectation(description: "Request should finish with Schools Details")
        schoolServiceManager = NYCAPIMockService(responseFileName: .noData)
        schoolViewModel = NYCSchoolsDetailViewModel(dbn: "01M292", serviceManager: schoolServiceManager)

        schoolViewModel?.getSchoolDetails()
        XCTAssertTrue(schoolServiceManager.isSchoolDetailsServiceMethodCalled, "ServiceManager method should be called.")
        schoolViewModel?.selectedSchoolModel.bind { result in
            XCTAssertEqual(result.count, 0, "it should be no data")
            requestExpectation.fulfill()

        }
        wait(for: [requestExpectation], timeout: 3)
    }
    
    /// Test cell has called image download servcei
//    func testImageDownloadService() {
//        let requestExpectation = expectation(description: "Request should call image download service")
//        schoolServiceManager = NYCAPIMockService(responseFileName: .success)
//        schoolViewModel = NYCSchoolsDetailViewModel(dbn: "01M292", serviceManager: schoolServiceManager)
//        schoolViewModel?.getImage(url: booksImagesUrl[0])
//        XCTAssertEqual(schoolServiceManager.isImageServiceMethodCalled, true)
//        requestExpectation.fulfill()
//        wait(for: [requestExpectation], timeout: 3)
//    }
}
