//
//  MaxScoreManager.swift
//  FilBlankTask
//
//  Created by Afsar Sir on 19/09/19.
//  Copyright © 2019 Afsar Sir. All rights reserved.
//

import Foundation


class MaxScoreManager{
    
    
    fileprivate let MAX_KEY = "MAX_KEY"
    
    private let preferences = UserDefaults.standard
    
    
    func saveMaxScore(score: Int){
        preferences.set(score, forKey: MAX_KEY)
    }
    
    func getMax()->Int{
        
        if preferences.object(forKey: MAX_KEY) == nil{
            return 0
        }
        return preferences.integer(forKey: MAX_KEY)
        
    }
    
    
}
