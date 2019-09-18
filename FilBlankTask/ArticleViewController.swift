//
//  ArticleViewController.swift
//  FilBlankTask
//
//  Created by Afsar Sir on 18/09/19.
//  Copyright © 2019 Afsar Sir. All rights reserved.
//

import UIKit
import WikipediaKit

class ArticleViewController: UIViewController {
    let language = WikipediaLanguage("en")
    var article: String?
    var sentances: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()

        didFetchRandomArticle()
        
    }
    

    

    
    func removeWordFromSentances(sentances: [String]){
        print("Removing from sentances")
        var done = 0 // Maximum done will be 10
        var set = Set<Int>()
        
        while done < 10{
            let sentanceRandomIndex = getRandomNumberBetweenRange(from: 0, to: sentances.count)
            if !set.contains(sentanceRandomIndex){
                set.insert(sentanceRandomIndex)
                removeWordFromSentance(sentance: sentances[sentanceRandomIndex])
                done = done + 1
            }
        }
        
        
        
        
        
        
        
    }
    
    
    func removeWordFromSentance(sentance: String) -> [Range<String.Index>]?   {
        print("Removing from \(sentance)")
        let words = sentance.tokenizeWords()
        let randomIndex = getRandomNumberBetweenRange(from: 0, to: words.count)
        let stringWord = words[randomIndex]
        let ranges = article?.ranges(of: stringWord)
        return ranges
    }
    
    func isWhitinSentanceRange(inr: Range<String.Index>, of: Range<String.Index>) -> Bool{
        
        if of.upperBound < inr.upperBound{
            if of.lowerBound >= inr.lowerBound{
                return true
            }
        }
        return false
        
    }
    
    
    
    func didFetchRandomArticle(){
        print("Fetching")
        var result = ""
        Wikipedia.shared.requestSingleRandomArticle(language: self.language, maxCount: 8, imageWidth: 640) {
            (article, language, error) in
            
            guard let article = article else { return }
            
            //print(article.displayText)
            print("Titile is \(article.displayTitle)")
            
            
            result = article.displayText
            self.sentances = result.splitIntoSentances()
            
            guard let sentc = self.sentances else{
                fatalError("sentances found nill")
            }
            
            if sentc.count < 10 {
                // Reccurive call to find another article
                self.didFetchRandomArticle()
                print("Trying again")
            }
            else {
               
                // Found article with more than 10 sentances
                self.article = result
                self.removeWordFromSentances(sentances: sentc)
                
            }
            
        }
    }
    
    
    
    // Get a random number in specified range
    func getRandomNumberBetweenRange(from: Int, to: Int) -> Int{
        
        let random = arc4random_uniform(UInt32(from)) + UInt32(from)
        return Int(random)
        
    }
        

}
