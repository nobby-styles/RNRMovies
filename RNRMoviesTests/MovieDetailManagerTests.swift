//
//  Test.swift
//  RNRMovies
//
//  Created by Robert Redmond on 07/01/2018.
//  Copyright © 2018 Robert Redmond. All rights reserved.
//

import XCTest
@testable import RNRMovies

class MovieDetailManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFetchLatestMoviesNowPlayingWithNilData() {
        let dataProvider = MockDataProvider()

        let dataManager = MoviesNowPlayingDataManager(dataProvider: dataProvider)
        dataManager.fetchLatestMoviesNowPlaying() {
            (updated, array) in
            XCTAssertFalse(updated)
            XCTAssertNil(array, "Data")
        }
    }

    func testFetchLatestMoviesNowPlayingWithBadData() {
        let dataProvider = MockDataProvider()
        dataProvider.dict = ["test": "test", "id": 123]
        let dataManager = MoviesNowPlayingDataManager(dataProvider: dataProvider)
        dataManager.fetchLatestMoviesNowPlaying() {
            (updated, array) in
            XCTAssertFalse(updated)
            XCTAssertNil(array, "Data")
        }
    }

    func testFetchLatestMoviesNowPlayingWithCorrectData() {
        let dataProvider = MockDataProvider()
        dataProvider.dict = ["results": [["id": Int(181808), "vote_average": Float(7.3), "title": "Star Wars: The Last Jedi", "overview": "Rey develops her newly discovered abilities with the guidance of Luke Skywalker, who is unsettled by the strength of her powers. Meanwhile, the Resistance prepares to do battle with the First Order.", "poster_path": "/xGWVjewoXnJhvxKW619cMzppJDQ.jpg"]]]
        let dataManager = MoviesNowPlayingDataManager(dataProvider: dataProvider)
        dataManager.fetchLatestMoviesNowPlaying() {
            (updated, array) in
            XCTAssertTrue(updated)
            XCTAssertNotNil(array, "No Data")
            if let array = array {
                XCTAssertEqual(array.count, 1)
                let movie = array[0]
                XCTAssertEqual(movie.averageVote, Float(7.3))
                XCTAssertEqual(movie.ID, Int(181808))
                XCTAssertEqual(movie.overview, "Rey develops her newly discovered abilities with the guidance of Luke Skywalker, who is unsettled by the strength of her powers. Meanwhile, the Resistance prepares to do battle with the First Order.")
                XCTAssertEqual(movie.posterPath, "/xGWVjewoXnJhvxKW619cMzppJDQ.jpg")
                XCTAssertEqual(movie.title, "Star Wars: The Last Jedi" )
            }
        }
    }
    
}
