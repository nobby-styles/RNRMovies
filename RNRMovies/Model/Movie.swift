//
// Created by Robert Redmond on 06/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation

struct Movie {

    let ID: Int
    let title : String
    let overview : String
    let posterPath : String
    let averageVote: Float

    var collectionTitle: String?
    var collectionId: Int?
    var collection: [Movie]?

    init(ID: Int, title: String, overview: String, posterPath: String, averageVote: Float){
        self.ID = ID
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.averageVote = averageVote
    }

    func URLForImage() -> URL {
        let urlStr = "https://image.tmdb.org/t/p/w400_and_h600_bestv2\(self.posterPath)"
        return URL(string: urlStr)!
    }
}
