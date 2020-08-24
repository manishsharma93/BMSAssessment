//
//  MovieDetails.swift
//  BMSAssessment
//
//  Created by Manish Kumar on 23/08/20.
//  Copyright © 2020 Manish Kumar. All rights reserved.
//

import UIKit

enum MovieDetailCellType {
    case poster
    case synopsis
    case reviews
    case credits
    case similar
}

struct MovieDetailsSection {

    var type: MovieDetailCellType?
    var data: Any?
    
    init(type: MovieDetailCellType, data: Any?) {
        self.type = type
        self.data = data
    }
}

