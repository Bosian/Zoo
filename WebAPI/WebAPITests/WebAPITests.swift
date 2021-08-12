//
//  WebAPITests.swift
//  WebAPITests
//
//  Created by 劉柏賢 on 2021/8/11.
//

import XCTest
@testable import WebAPI

class WebAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testGetZooWebAPI() {

        let webAPI = GetZooWebAPI()
        let expect = expectation(description: "Get \(webAPI.urlString)")
        
        let parameter = GetZooParameter()
        
        webAPI.invokeAsync(parameter).done { model in
            
            XCTAssertTrue(model.isSuccess)
            
            expect.fulfill()
            
        }.catch { error in
            print(error)
            expect.fulfill()
            XCTFail("\(error)")
        }
        
        waitForExpectations(timeout: 60) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetZooWebAPIForPagination() {

        let webAPI = GetZooWebAPI()
        let expect = expectation(description: "Get \(webAPI.urlString)")
        
        let parameter = GetZooParameter(limit: 1, offset: 0)
        
        webAPI.invokeAsync(parameter).done { model in
            
            XCTAssertTrue(model.isSuccess)
            
            expect.fulfill()
            
        }.catch { error in
            print(error)
            expect.fulfill()
            XCTFail("\(error)")
        }
        
        waitForExpectations(timeout: 60) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
