//
//  MetaViewController.swift
//  STLabelTest
//
//  Created by Introtuce on 17/09/19.
//  Copyright © 2019 Introtuce. All rights reserved.
//

import UIKit
import WikipediaKit

class MetaViewController: UIViewController, UIGestureRecognizerDelegate {
    let language = WikipediaLanguage("en")
    let wikipedia = Wikipedia.shared
    var result: String?
    let article = "While solutions vary, components that provide the following functionality are typically found in API management products:Gateway: a server that acts as an API front-end, receives API requests, enforces throttling and security policies, passes requests to the back-end service and then passes the response back to the requester.[2] A gateway often includes a transformation engine to orchestrate and modify the requests and responses on the fly. A gateway can also provide functionality such as collecting analytics data and providing caching. The gateway can provide functionality to support authentication, authorization, security, audit and regulatory compliance.[3]Publishing tools: a collection of tools that API providers use to define APIs, for instance using the OpenAPI or RAML specifications, generate API documentation, manage access and usage policies for APIs, test and debug the execution of API, including security testing and automated generation of tests and test suites, deploy APIs into production, staging, and quality assurance environments, and coordinate the overall API lifecycle.Developer portal/API store: community site, typically branded by an API provider, that can encapsulate for API users in a single convenient source information and functionality including documentation, tutorials, sample code, software development kits, an interactive API console and sandbox to trial APIs, the ability to subscribe to the APIs and manage subscription keys such as OAuth2 Client ID and Client Secret, and obtain support from the API provider and user and community.Reporting and analytics: functionality to monitor API usage and load (overall hits, completed transactions, number of data objects returned, amount of compute time and other internal resources consumed, volume of data transferred). This can include real-time monitoring of the API with alerts being raised directly or via a higher-level network management system, for instance, if the load on an API has become too great, as well as functionality to analyze historical data, such as transaction logs, to detect usage trends. Functionality can also be provided to create synthetic transactions that can be used to test the performance and behavior of API endpoints. The information gathered by the reporting and analytics functionality can be used by the API provider to optimize the API offering within an organization's overall continuous improvement process and for defining software Service-Level Agreements for APIs.Monetization: functionality to support charging for access to commercial APIs. This functionality can include support for setting up pricing rules, based on usage, load and functionality, issuing invoices and collecting payments including multiple types of credit card payments."
    
    
  
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let color = UIColor.red
        
        // Create an attributed string
        textView.font = UIFont(name: textView.font!.fontName, size: 28)
        let myString = NSMutableAttributedString(string: article + " \n\n " + article)
    
        let fullRange = NSRange(location: 0, length: myString.length)
        myString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Times New Roman", size: 18.0), range: fullRange)
        // Set an attribute on part of the string
        let myRange = NSRange(location: 0, length: 5) // range of "Swift"
        let myCustomAttribute = [ NSAttributedString.Key.myAttributeName: "ChangeValue"]
        myString.addAttributes(myCustomAttribute, range: myRange)
        
        textView.attributedText = myString
        
        // Add tap gesture recognizer to Text View
        let tap = UITapGestureRecognizer(target: self, action: #selector(myMethodToHandleTap(_:)))
        tap.delegate = self
        textView.addGestureRecognizer(tap)
        fetchRendom()
        
        
    }
    
    
    @objc func myMethodToHandleTap(_ sender: UITapGestureRecognizer) {
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            
            // print the character index
            print("character index: \(characterIndex)")
            
            // print the character at the index
            let myRange = NSRange(location: characterIndex, length: 1)
            let substring = (myTextView.attributedText.string as NSString).substring(with: myRange)
            print("character at index: \(substring)")
            
            // check if the tap location has a certain attribute
            let attributeName = NSAttributedString.Key.myAttributeName
            let attributeValue = myTextView.attributedText?.attribute(attributeName, at: characterIndex, effectiveRange: nil)
            if let value = attributeValue {
                print("You tapped on \(attributeName.rawValue) and the value is: \(value)")
                let index = myTextView.text.index(myTextView.text.startIndex, offsetBy: 5)
                //let index = String.Index(encodedOffset: 5)
                let subString = myTextView.text[..<index]
                let end = myTextView.text.index(myTextView.text.startIndex, offsetBy: 0)
                guard let str = value as? String else{
                    return
                }
                let mstr = (value as? String)!
                let range = NSMakeRange(0, 5)
                let newString = myTextView.attributedText.stringReplaceByRange(range: range, str: mstr)
               // var string:NSMutableAttributedString = NSMutableAttributedString(string: mstr )
               // var range = mstr.range(of: mstr.startIndex)
                //string.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: range)
                myTextView.attributedText = newString
                
               // myTextView.text.replaceSubrange(end...index, with: (value as? String)!)
                print(subString)
            }
            
        }
    }
    
 
    
    



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
extension MetaViewController{
    
    func requestRendomArticleWithSufficientText(){
        
        while true {
            
            var result = fetchRendom()
            print(result.count)
            tokenizeText(for: result)
            break
            
        }
        
        
        
    }
    
    func splitsentance(string: String) -> [String]{
        print("Token \(string.count)")
        let s = string
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
        
        
       /* for d in result{
            print(" Sentance : \(d)\n")
        }*/
        
        /*let ixs = Array(enumerate(t)).filter {
            $0.1 == "SentenceTerminator"
            }.map {r[$0.0].startIndex}
        var prev = s.startIndex
        for ix in ixs {
            let r = prev...ix
            result.append(
                s[r].stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceCharacterSet()))
            prev = advance(ix,1)
         
         
         guard let rranges = ranges else {
         return ranges
         }
         print("For \(stringWord)")
         for range in rranges{
         print("\(range.lowerBound) and \(range.upperBound)")
         let substring = article![range.lowerBound..<range.upperBound]
         print("By subString \(substring)")
         }
         
         
         
        }*/
        
        
    }

    func tokenizeText(for text: String) {
        let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]

        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
            let word = (text as NSString).substring(with: tokenRange)
            print(word)
        }
    }
    
    func test(string: String){
        
        let options = NSLinguisticTagger.Options.omitWhitespace.rawValue | NSLinguisticTagger.Options.joinNames.rawValue
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: Int(options))
        
        let inputString = string
        tagger.string = inputString
        
        let range = NSRange(location: 0, length: inputString.utf16.count)
        tagger.enumerateTags(in: range, scheme: .nameTypeOrLexicalClass, options: NSLinguisticTagger.Options(rawValue: options)) { tag, tokenRange, sentenceRange, stop in
            guard let range = Range(tokenRange, in: inputString) else { return }
            let token = inputString[range]
            print("\(token)")
        }
        
      /*  let s = string
        var r = [Range<String.Index>]()
        let t = s.linguisticTagsIn(
            s.startIndex..<s.endIndex, scheme: tagger,
            options: nil, tokenRanges: &r)
        var result = [String]()
        let ixs = Array(enumerate(t)).filter {
            $0.1 == "SentenceTerminator"
            }.map {r[$0.0].startIndex}
        var prev = s.startIndex
        for ix in ixs {
            let r = prev...ix
            result.append(
                s[r].stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceCharacterSet()))
            prev = advance(ix,1)
        }*/
        
    }
    
    func fetchRendom() -> String{
        var result = ""
        Wikipedia.shared.requestSingleRandomArticle(language: self.language, maxCount: 8, imageWidth: 640) {
            (article, language, error) in
            
            guard let article = article else { return }
            
            //print(article.displayText)
            print("Titile is \(article.displayTitle)")
            
            
            result = article.displayText
            let sentancces = self.splitsentance(string: result)
            
            if sentancces.count < 10 {
                self.fetchRendom()
                print("Trying again")
            }
            else {
                print("Final \(sentancces.count)")
                print(sentancces)
            }
            
        }
        return result;
        /*(let imageWidth = Int(self.view.frame.size.width * UIScreen.main.scale)
        
        let _ = Wikipedia.shared.requestArticle(language: language, title: "Soft rime", imageWidth: imageWidth) { (article, error) in
            guard error == nil else { return }
            guard let article = article else { return }
            
            print(article.displayTitle)
            print(article.displayText)
            print(error)
        }
        */
    }
    
}
