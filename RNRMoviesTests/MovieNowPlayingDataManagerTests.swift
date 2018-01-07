//
//  MovieNowPlayingTest.swift
//  RNRMovies
//
//  Created by Robert Redmond on 06/01/2018.
//  Copyright © 2018 Robert Redmond. All rights reserved.
//

import XCTest
@testable import RNRMovies




class MovieNowPlayingDataManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFetchMovieDetailWithNilData() {
        let dataProvider = MockDataProvider()

        let dataManager = MovieDetailDataManager(dataProvider: dataProvider)
        dataManager.fetchMovieDetail() {
            (updated, movie) in
            XCTAssertFalse(updated)
            XCTAssertNil(movie, "Data")
        }
    }

    func testFetchMovieDetailWithBadData() {
        let dataProvider = MockDataProvider()
        dataProvider.dict = ["test": "test", "number": 123]
        let dataManager = MovieDetailDataManager(dataProvider: dataProvider)
        dataManager.fetchMovieDetail() {
            (updated, movie) in
            XCTAssertFalse(updated)
            XCTAssertNil(movie, "Data")
        }
    }

    func testFetchMovieDetailWithCorrectData() {
        let dataProvider = MockDataProvider()
        dataProvider.dict = ["id": Int(181808), "vote_average": Float(7.3), "title": "Star Wars: The Last Jedi", "overview": "Rey develops her newly discovered abilities with the guidance of Luke Skywalker, who is unsettled by the strength of her powers. Meanwhile, the Resistance prepares to do battle with the First Order.", "poster_path": "/xGWVjewoXnJhvxKW619cMzppJDQ.jpg"]
        let dataManager = MovieDetailDataManager(dataProvider: dataProvider)
        dataManager.fetchMovieDetail() {
            (updated, movie) in
            XCTAssertTrue(updated)
            XCTAssertNotNil(movie, "No Data")
            if let movie = movie {
                XCTAssertEqual(movie.averageVote, Float(7.3))
                XCTAssertEqual(movie.ID, Int(181808))
                XCTAssertEqual(movie.overview, "Rey develops her newly discovered abilities with the guidance of Luke Skywalker, who is unsettled by the strength of her powers. Meanwhile, the Resistance prepares to do battle with the First Order.")
                XCTAssertEqual(movie.posterPath, "/xGWVjewoXnJhvxKW619cMzppJDQ.jpg")
                XCTAssertEqual(movie.title, "Star Wars: The Last Jedi" )
            }
        }
    }



}
