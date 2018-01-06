//
//  RNRMoviesTests.swift
//  RNRMoviesTests
//
//  Created by Robert Redmond on 05/01/2018.
//  Copyright © 2018 Robert Redmond. All rights reserved.
//

import XCTest
@testable import RNRMovies


class HttpDataProviderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHttpDataProviderWithCorrectUrl() {
        let expectation = XCTestExpectation(description: "fetch")
        let dataProvider = HttpDataProvider(baseUrl: "https://api.themoviedb.org/3/movie/now_playing?region=gb&")
        dataProvider.fetchData(){
            (updated, array) in
            DispatchQueue.main.async {
                XCTAssertTrue(updated)
                XCTAssertNotNil(array, "No data was downloaded.")
                expectation.fulfill()
            }


        }
        wait(for: [expectation], timeout: 20)
    }

    
    func testHttpDataProviderWithWrongUrl() {
        let expectation = XCTestExpectation(description: "fetch")
        let dataProvider = HttpDataProvider(baseUrl: "https://api.madeup.com")
        dataProvider.fetchData(){
            (updated, array) in
            DispatchQueue.main.async {
                XCTAssertFalse(updated)
                XCTAssertNil(array, "Data was downloaded.")
                expectation.fulfill()
            }
            
            
        }
        wait(for: [expectation], timeout: 20)
    }
    
    
    
    
}
