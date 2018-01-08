//
// Created by Robert Redmond on 07/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation

protocol DetailDataManager {
    func fetchMovieDetail(completionHandler: @escaping (Bool, Movie?) -> ())
}


class MovieDetailDataManager: DetailDataManager {
    init(dataProvider: MutableDataProvider) {
        self.dataProvider = dataProvider
    }

    func fetchMovieDetail(completionHandler: @escaping (Bool, Movie?) -> ()) {
        self.dataProvider.fetchData() {
            [weak self] success, data in
            guard let strongSelf = self else {
                return
            }
            if success {
                if let jsonData = data as? [String: Any], let parsedData = strongSelf.parse(jsonData: jsonData) {
                    if let collectionId = parsedData.collectionId {
                        strongSelf.movie = parsedData
                        strongSelf.dataProvider.fetchData(urlString: "https://api.themoviedb.org/3/collection/\(collectionId)?") {
                            [weak self] success, data in
                            guard let strongSelf = self else {
                                return
                            }
                            if let jsonData = data as? [String: Any], let parsedData = strongSelf.parseCollection(jsonData: jsonData) {
                                strongSelf.movie?.collection = parsedData
                            }
                            completionHandler(true, strongSelf.movie)

                        }

                    } else {
                        completionHandler(true, parsedData)
                    }
                } else {
                    completionHandler(false, nil)
                }

            } else {
                completionHandler(false, nil)
            }
        }
    }

    fileprivate func parse(jsonData: [String: Any]) -> Movie? {
        guard let ID = jsonData["id"] as? Int, let title = jsonData["title"] as? String, let overview = jsonData["overview"] as? String, let posterPath = jsonData["poster_path"] as? String, let averageVote = jsonData["vote_average"] as? Float else {
            return nil
        }
        var movie = Movie(ID: ID, title: title, overview: overview, posterPath: posterPath, averageVote: averageVote)
        if let collection = jsonData["belongs_to_collection"] as? [String: Any] {
            movie.collectionTitle = collection["name"] as? String
            movie.collectionId = collection["id"] as? Int
        }
        return movie

    }

    fileprivate func parseCollection(jsonData: [String: Any]) -> [Movie]? {
        guard let results = jsonData["parts"] as? [[String: Any]] else {
            return nil
        }
        var parsedResults = [Movie]()
        for dict in results {
            if let ID = dict["id"] as? Int, let title = dict["title"] as? String, let overview = dict["overview"] as? String, let posterPath = dict["poster_path"] as? String, let averageVote = dict["vote_average"] as? Float {
                let movie = Movie(ID: ID, title: title, overview: overview, posterPath: posterPath, averageVote: averageVote)
                parsedResults.append(movie)
            }

        }
        return parsedResults.count > 0 ? parsedResults : nil
    }


    fileprivate let dataProvider: MutableDataProvider
    fileprivate var movie: Movie?
}
