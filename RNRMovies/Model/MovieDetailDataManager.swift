//
// Created by Robert Redmond on 07/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation

protocol DetailDataManager{
    func fetchMovieDetail(completionHandler: @escaping (Bool, Movie?) -> ())
}


class MovieDetailDataManager{
    init(dataProvider: DataProvider) {
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
                    completionHandler(true, parsedData)
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
        let movie = Movie(ID: ID, title: title, overview: overview, posterPath: posterPath, averageVote:averageVote)
        return movie

    }


    fileprivate let dataProvider: DataProvider
}