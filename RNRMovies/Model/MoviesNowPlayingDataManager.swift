//
// Created by Robert Redmond on 06/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation

class MoviesNowPlayingDataManager {
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    func fetchLatestMoviesNowPlaying(completionHandler: @escaping (Bool, [Movie]?) -> ()) {
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

    fileprivate func parse(jsonData: [String: Any]) -> [Movie]? {
        guard let results = jsonData["results"] as? [[String: Any]] else {
            return nil
        }
        var parsedResults = [Movie]()
        for dict in results {
            if let ID = dict["id"] as? Int, let title = dict["title"] as? String, let overview = dict["overview"] as? String, let posterPath = dict["poster_path"] as? String, let averageVote = dict["vote_average"] as? Float {
                let movie = Movie(ID: ID, title: title, overview: overview, posterPath: posterPath, averageVote:averageVote)
                parsedResults.append(movie)
            }

        }
        return parsedResults.count > 0 ? parsedResults : nil
    }


    fileprivate let dataProvider: DataProvider
}
