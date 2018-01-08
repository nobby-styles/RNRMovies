//
// Created by Robert Redmond on 07/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController , UICollectionViewDataSource{
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var commentLabel: UILabel!
    @IBOutlet fileprivate weak var ratingLabel: UILabel!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!


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
                    if self.movieDetailViewModel?.collection != nil {
                        self.collectionView.reloadData()
                    }
                }
                self.activityIndicator?.stopAnimating()
            }
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        self.activityIndicator?.stopAnimating()
        super.viewDidDisappear(animated)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let indexPath = self.collectionView?.indexPathsForSelectedItems, let viewModel = self.movieDetailViewModel?.createMovieDetailViewModel(index: (indexPath.first?.item)!) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            vc.movieDetailViewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "anotherMovieDetail" {

        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieDetailViewModel?.collection?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath as IndexPath) as! MovieCollectionViewCell
        cell.movie = self.movieDetailViewModel?.collection?[indexPath.item]
        return cell
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }


}
