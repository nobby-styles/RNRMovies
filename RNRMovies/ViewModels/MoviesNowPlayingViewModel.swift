//
// Created by Robert Redmond on 06/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation

class MoviesNowPlayingViewModel {

    var movies = [Movie]()

    init(moviesNowPlayingPlayingDataManager: NowPlayingDataManager) {
        self.moviesNowPlayingPlayingDataManager = moviesNowPlayingPlayingDataManager
    }

    func fetchLatestMoviesNowPlaying(completionHandler: @escaping (Bool) -> ()) {
        self.moviesNowPlayingPlayingDataManager.fetchLatestMoviesNowPlaying() {
            [weak self] success, data in
            guard let strongSelf = self else {
                return
            }
            if let data = data{
                strongSelf.movies = data
                completionHandler(true)

            } else {
                completionHandler(false)
            }
        }
    }


    fileprivate let moviesNowPlayingPlayingDataManager: NowPlayingDataManager

}
