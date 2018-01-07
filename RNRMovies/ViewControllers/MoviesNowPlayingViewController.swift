//
//  MoviesNowShowingViewController.swift
//  RNRMovies
//
//  Created by Robert Redmond on 06/01/2018.
//  Copyright © 2018 Robert Redmond. All rights reserved.
//

import Foundation
import UIKit

class MoviesNowPlayingViewController: UICollectionViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?

    var moviesNowPlayingViewModel: MoviesNowPlayingViewModel? {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let viewModel = self.moviesNowPlayingViewModel else {
            return
        }
        self.activityIndicator?.startAnimating()
        viewModel.fetchLatestMoviesNowPlaying() { (updated) in

            DispatchQueue.main.async { [unowned self] in
                if updated {
                    self.collectionView?.reloadData()
                }
                self.activityIndicator?.stopAnimating()
            }
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        self.activityIndicator?.stopAnimating()
        super.viewDidDisappear(animated)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "movieDetailViewControllerSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailViewControllerSegue" {
            if let indexPath = self.collectionView?.indexPathsForSelectedItems, let viewModel = self.moviesNowPlayingViewModel?.createMovieDetailViewModel(index: (indexPath.first?.item)!) {
                let controller = segue.destination as! MovieDetailViewController
                controller.movieDetailViewModel = viewModel
            }
        }
    }



}


extension MoviesNowPlayingViewController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesNowPlayingViewModel?.movies.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath as IndexPath) as! MovieCollectionViewCell
        cell.movie = self.moviesNowPlayingViewModel?.movies[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }

}




    

