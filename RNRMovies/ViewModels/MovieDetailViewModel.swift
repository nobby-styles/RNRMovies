//
// Created by Robert Redmond on 07/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation

class MovieDetailViewModel {
    var title: String? {
        get {
            return self.movie?.title
        }
    }

    var overview: String? {
        get {
            return self.movie?.overview
        }
    }

    var urlForImage: URL? {
        get {
            return self.movie?.URLForImage()
        }
    }

    var rating: String? {
        get {
            return self.movie?.averageVote != nil ? "rating: \(self.movie!.averageVote)" : nil
        }
    }


    init(movieDetailDataManager: DetailDataManager) {
        self.movieDetailDataManager = movieDetailDataManager
    }

    func fetchMovieDetail(completionHandler: @escaping (Bool) -> ()) {
        self.movieDetailDataManager.fetchMovieDetail() {
            [weak self] success, data in
            guard let strongSelf = self else {
                return
            }
            if let data = data{
                strongSelf.movie = data
                completionHandler(true)

            } else {
                completionHandler(false)
            }
        }
    }




    fileprivate let movieDetailDataManager: DetailDataManager
    fileprivate var movie : Movie?
}
