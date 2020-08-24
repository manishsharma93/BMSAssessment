//
//  SimilarMoviesTableViewCell.swift
//  BMSAssessment
//
//  Created by Manish Kumar on 23/08/20.
//  Copyright © 2020 Manish Kumar. All rights reserved.
//

import UIKit

class SimilarMoviesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    
    var data: MovieSimilarResponse?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        similarMoviesCollectionView.register(UINib.init(nibName: "SimilarMoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SimilarMoviesCollectionViewCell")
        similarMoviesCollectionView.delegate = self
        similarMoviesCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SimilarMoviesTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarMoviesCollectionViewCell", for: indexPath) as? SimilarMoviesCollectionViewCell
        
        let movieData = data?.results?[indexPath.row]
        
        cell?.movieImageView.loadImage(movieData?.poster_path ?? "", type: .portrait)
        
        cell?.movieNameLabel.text = movieData?.title ?? ""
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width / 3 , height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
