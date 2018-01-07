//
// Created by Robert Redmond on 07/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var commentLabel: UILabel!
    @IBOutlet fileprivate weak var ratingLabel : UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?

    var movieDetailViewModel: MovieDetailViewModel?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let viewModel = self.movieDetailViewModel else {
            return
        }
        self.activityIndicator?.startAnimating()
        viewModel.fetchMovieDetail() { (updated) in

            DispatchQueue.main.async { [unowned self] in
                if updated {
                    if let imageurl = self.movieDetailViewModel!.urlForImage {
                        self.imageView.downloadedFrom(url: imageurl)
                    }
                    self.titleLabel.text = self.movieDetailViewModel?.title
                    self.commentLabel.text = self.movieDetailViewModel?.overview
                    self.ratingLabel.text = self.movieDetailViewModel?.rating
                }
                self.activityIndicator?.stopAnimating()
            }
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        self.activityIndicator?.stopAnimating()
        super.viewDidDisappear(animated)
    }

}
