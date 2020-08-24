//
//  BMSPreferences.swift
//  BMSAssessment
//
//  Created by Manish Kumar on 24/08/20.
//  Copyright © 2020 Manish Kumar. All rights reserved.
//

import UIKit

class BMSPreferences: NSObject {

    static func addMovieToPreference(data: MovieResults!) {
        var dataArray : [MovieResults] = (UserDefaults.standard.array(forKey: "BMS_PREFERENCE") as? [MovieResults]) ?? []
        
        if dataArray.count == 0 {
            dataArray.append(data)
        } else {
            
            if !dataArray.contains(where: { $0.id == data.id }) {
                if dataArray.count == 5 {
                    dataArray.remove(at: 0)
                }
                 dataArray.append(data)
            }
        }
        
        UserDefaults.standard.set(dataArray, forKey: "BMS_PREFERENCE")
        UserDefaults.standard.synchronize()
        
    }
    
    static func fetchMoviesFromPreference() -> [MovieResults]? {
        let dataArray : [MovieResults] = (UserDefaults.standard.array(forKey: "BMS_PREFERENCE") as? [MovieResults]) ?? []
        
        if dataArray.count > 0 {
            return dataArray
        }

        return []
    }
}
