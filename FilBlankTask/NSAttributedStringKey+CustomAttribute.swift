//
//  NSAttributedStringKey+CustomAttribute.swift
//  STLabelTest
//
//  Created by Introtuce on 17/09/19.
//  Copyright © 2019 Introtuce. All rights reserved.
//

import Foundation
import UIKit
extension NSAttributedString.Key {
    static let myAttributeName = NSAttributedString.Key(rawValue: "MyCustomAttribute")
}


extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        
        guard let characterSpacing = characterSpacing else {return attributedString}
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
}
extension NSAttributedString {
    func stringWithString(stringToReplace: String, replacedWithString newStringPart: String) -> NSMutableAttributedString
    {
        let mutableAttributedString = mutableCopy() as! NSMutableAttributedString
        let mutableString = mutableAttributedString.mutableString
        while mutableString.contains(stringToReplace) {
            let rangeOfStringToBeReplaced = mutableString.range(of: stringToReplace)
            
            mutableAttributedString.replaceCharacters(in: rangeOfStringToBeReplaced, with: newStringPart)
        }
        return mutableAttributedString
    }
    
    
    func stringReplaceByRange(range: NSRange, str: String) -> NSMutableAttributedString{
        
        let mutableAttributedString = mutableCopy() as! NSMutableAttributedString
        // let mutableString = mutableAttributedString.mutableString
        // let nstr: NSString = NSString(string: str)
        let ranger = NSRange(location: 0, length: str.count)
        let attribute = NSMutableAttributedString.init(string: str)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: ranger)
        
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Chalkduster", size: 18.0), range: ranger)
        //mutableAttributedString.replaceCharacters(in: range, with: str)
        mutableAttributedString.replaceCharacters(in: range, with: attribute)
        
        return mutableAttributedString
    }
}
