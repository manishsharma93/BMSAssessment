//
//  SimilarMoviesCollectionViewCell.swift
//  BMSAssessment
//
//  Created by Manish Kumar on 23/08/20.
//  Copyright © 2020 Manish Kumar. All rights reserved.
//

import UIKit

class SimilarMoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        movieImageView.layer.cornerRadius = 5.0
        movieImageView.layer.masksToBounds = true
    }

}
