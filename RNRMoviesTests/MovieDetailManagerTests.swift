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

    func testFetchMovieDetailWithNilData() {
        let dataProvider = MockMutableDataProvider()

        let dataManager = MovieDetailDataManager(dataProvider: dataProvider)
        dataManager.fetchMovieDetail() {
            (updated, movie) in
            XCTAssertFalse(updated)
            XCTAssertNil(movie, "Data")
        }
    }

    func testFetchMovieDetailWithBadData() {
        let dataProvider = MockMutableDataProvider()
        dataProvider.dict = ["test": "test", "number": 123]
        let dataManager = MovieDetailDataManager(dataProvider: dataProvider)
        dataManager.fetchMovieDetail() {
            (updated, movie) in
            XCTAssertFalse(updated)
            XCTAssertNil(movie, "Data")
        }
    }

    func testFetchMovieDetailWithCorrectDataWithoutCollectionIDOrCollectionTitle() {
        let dataProvider = MockMutableDataProvider()
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
                XCTAssertNil(movie.collectionId)
                XCTAssertNil(movie.collectionTitle)
                XCTAssertNil(movie.collection)
            }
        }
    }
    
    func testFetchMovieDetailWithCorrectDataWitCollectionIDAndCollectionTitleButWithoutCollectionData() {
        let dataProvider = MockMutableDataProvider()
        dataProvider.dict = ["id": Int(181808), "vote_average": Float(7.3), "title": "Star Wars: The Last Jedi", "overview": "Rey develops her newly discovered abilities with the guidance of Luke Skywalker, who is unsettled by the strength of her powers. Meanwhile, the Resistance prepares to do battle with the First Order.", "poster_path": "/xGWVjewoXnJhvxKW619cMzppJDQ.jpg", "belongs_to_collection" : ["name" : "Star Wars", "id" : 10]]
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
                XCTAssertEqual(movie.collectionId, Int(10))
                XCTAssertEqual(movie.collectionTitle, "Star Wars")
                XCTAssertNil(movie.collection)
            }
        }
    }
    
    func testFetchMovieDetailWithCorrectDataWitCollectionIDAndCollectionTitleWithCollectionData() {
        let dataProvider = MockMutableDataProvider()
        let dict = ["id": Int(181808), "vote_average": Float(7.3), "title": "Star Wars: The Last Jedi", "overview": "Rey develops her newly discovered abilities with the guidance of Luke Skywalker, who is unsettled by the strength of her powers. Meanwhile, the Resistance prepares to do battle with the First Order.", "poster_path": "/xGWVjewoXnJhvxKW619cMzppJDQ.jpg", "belongs_to_collection" : ["name" : "Star Wars", "id" : 10]] as [String : Any]
        dataProvider.dict = dict
        dataProvider.urlDict = ["parts" : [dict]]
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
                XCTAssertEqual(movie.collectionId, Int(10))
                XCTAssertEqual(movie.collectionTitle, "Star Wars")
                XCTAssertNotNil(movie.collection)
                XCTAssertEqual(movie.collection?.count, 1)
            }
        }
    }
    
    func testFetchMovieDetailWithCorrectDataWitCollectionIDAndCollectionTitleWithBadCollectionData() {
        let dataProvider = MockMutableDataProvider()
        let dict = ["id": Int(181808), "vote_average": Float(7.3), "title": "Star Wars: The Last Jedi", "overview": "Rey develops her newly discovered abilities with the guidance of Luke Skywalker, who is unsettled by the strength of her powers. Meanwhile, the Resistance prepares to do battle with the First Order.", "poster_path": "/xGWVjewoXnJhvxKW619cMzppJDQ.jpg", "belongs_to_collection" : ["name" : "Star Wars", "id" : 10]] as [String : Any]
        dataProvider.dict = dict
        dataProvider.urlDict = dict
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
                XCTAssertEqual(movie.collectionId, Int(10))
                XCTAssertEqual(movie.collectionTitle, "Star Wars")
                XCTAssertNil(movie.collection)
            }
        }
    }


    
    


    
}
