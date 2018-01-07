//
// Created by Robert Redmond on 06/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var commentLabel: UILabel!
    @IBOutlet fileprivate weak var ratingLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //containerView.layer.cornerRadius = 6
        //containerView.layer.masksToBounds = true
    }

    var movie: Movie? {
        didSet {
            if let movie = movie {
                self.imageView.downloadedFrom(url:movie.URLForImage())
                self.titleLabel.text = movie.title
                self.commentLabel.text = movie.overview
                self.ratingLabel.text = String(movie.averageVote)
            }
        }
    }

}
