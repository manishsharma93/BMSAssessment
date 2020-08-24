//
//  MovieCreditsTableViewCell.swift
//  BMSAssessment
//
//  Created by Manish Kumar on 23/08/20.
//  Copyright © 2020 Manish Kumar. All rights reserved.
//

import UIKit

class MovieCreditsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var creditsCollectionView: UICollectionView!
    
    var data : MovieCreditResponse?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        creditsCollectionView.register(UINib.init(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistCollectionViewCell")
        creditsCollectionView.delegate = self
        creditsCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MovieCreditsTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.cast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionViewCell", for: indexPath) as? ArtistCollectionViewCell
        
        let castData = data?.cast?[indexPath.row]
        
        cell?.artistImageView.loadImage(castData?.profile_path ?? "", type: .portrait)
        
        cell?.artistNameLabel.text = castData?.name ?? ""
        cell?.artistCharacterNameLabel.text = castData?.character ?? ""
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width / 3 , height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
