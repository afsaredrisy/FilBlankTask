//
//  String+NSLinguisticTagger.swift
//  FilBlankTask
//
//  Created by Afsar Sir on 18/09/19.
//  Copyright © 2019 Afsar Sir. All rights reserved.
//

import Foundation


extension String{
    
    //Divide the whole paragraph or whole article into sentances
    func splitIntoSentances()-> [String]{
        let s = self
        var r = [Range<String.Index>]()
        let t = s.linguisticTags(
            in: s.startIndex..<s.endIndex, scheme: NSLinguisticTagScheme.lexicalClass.rawValue,
            options: [], tokenRanges: &r)
        var result = [String]()
        
        let ixs = t.enumerated().filter{
            $0.1 == "SentenceTerminator"
            }.map {r[$0.0].lowerBound}
        var prev = s.startIndex
        for ix in ixs {
            let r = prev...ix
            result.append(
                s[r].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            prev = ix
            
        }
        return result
    }
    
    
    func tag(){
        let text = self
        let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
            if let tag = tag {
                let word = (text as NSString).substring(with: tokenRange)
                print("\(word): \(tag)")
                
            }
        }
        
        
        
    }
    
    
    
    // Divide the whole sentance into words.
    func tokenizeWords() -> [String]{
        
        let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        var result = [String]()
        tagger.string = self
        let range = NSRange(location: 0, length: utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
            let word = (self as NSString).substring(with: tokenRange)
            result.append(word)
            
        }
        
        return result
        
    }
    
    
    
}
