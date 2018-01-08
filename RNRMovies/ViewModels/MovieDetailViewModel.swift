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

    var collectionTitle: String? {
        get {
            return self.movie?.collectionTitle
        }
    }

    var collection: [Movie]? {
        get {
            return self.movie?.collection
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

    func createMovieDetailViewModel(index:Int) -> MovieDetailViewModel?{
        guard let movies = self.collection, movies.count > index else{
            return nil
        }
        let urlString = "https://api.themoviedb.org/3/movie/\(movies[index].ID)?"
        let httpDataProvider = HttpDataProvider(baseUrl: urlString)
        let movieDetailDataManager = MovieDetailDataManager(dataProvider: httpDataProvider)
        let movieDetailViewModel = MovieDetailViewModel(movieDetailDataManager: movieDetailDataManager)
        return movieDetailViewModel
    }



    fileprivate let movieDetailDataManager: DetailDataManager
    fileprivate var movie : Movie?
}
