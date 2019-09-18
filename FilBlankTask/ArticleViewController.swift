//
//  ArticleViewController.swift
//  FilBlankTask
//
//  Created by Afsar Sir on 18/09/19.
//  Copyright © 2019 Afsar Sir. All rights reserved.
//

import UIKit
import WikipediaKit

class ArticleViewController: UIViewController, UIGestureRecognizerDelegate  {
    let language = WikipediaLanguage("en")
    var article: String?
    var sentances: [String]?
    var titlem = ""
    var listItems = Set<String>()
    
    
    
    
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    var removedWords = [Range<String.Index> : String]()
    var nSremovedWords = [NSRange: String]()
    var answer = [String: String]()
    
    
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator("Please wait..")
        didFetchRandomArticle()
        
    }
    

    
    
    
    
    func didSetupTextView(ranges: Set<NSRange>){
        
        print("View Settingup")
        // Create an attributed string
        textView.font = UIFont(name: textView.font!.fontName, size: 28)
        let myString = NSMutableAttributedString(string: article!)
        
        let fullRange = NSRange(location: 0, length: myString.length)
        myString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Times New Roman", size: 18.0), range: fullRange)
        // Set an attribute on part of the string
        let myRange = NSRange(location: 0, length: 5) // range of "Swift"
        let myCustomAttribute = [ NSAttributedString.Key.myAttributeName: "ChangeValue"]
        myString.addAttributes(myCustomAttribute, range: myRange)
        
        
        for r in ranges{
            
            
            let attr = [NSAttributedString.Key.myAttributeName: nSremovedWords[r]]
            myString.addAttributes(attr, range: r)
            
            print("Attribute at \(r.lowerBound) and \(r.upperBound)")
            
        }
        
        
        
        textView.attributedText = myString
        
        // Add tap gesture recognizer to Text View
        let tap = UITapGestureRecognizer(target: self, action: #selector(myMethodToHandleTap(_:)))
        tap.delegate = self
        textView.addGestureRecognizer(tap)
        
        self.navigationItem.title = self.titlem
        stopIndicator()
    }
    

    
    func removeWordFromSentances(sentances: [String]){
        print("Removing from sentances")
        var done = 0 // Maximum done will be 10
        var set = Set<Int>()
        
        
        
        
        while done < 10{
            let sentanceRandomIndex = getRandomNumberBetweenRange(from: 0, to: sentances.count)
            print("R Number is \(sentanceRandomIndex)")
            if !set.contains(sentanceRandomIndex){
                
                set.insert(sentanceRandomIndex)
                let range = removeWordFromSentance(sentance: sentances[sentanceRandomIndex])
                guard range != nil else{
                    fatalError("Something going wrong")
                    
                }
                //print("Remved range \(range?.lowerBound) and \(range?.upperBound)")
                done = done + 1
            }
            else{
                print("Already removed")
                
            }
        }
         print("is remove \(removedWords.count)")
        
        let setKeys = removedWords.keys
       
        for key in setKeys {
            let word = removedWords[key]
            if word != nil{
                listItems.insert(word!)
            }
            
        }
        var nsSet = Set<NSRange>()
        for k in nSremovedWords.keys{
            nsSet.insert(k)
        }
        
        didSetupTextView(ranges: nsSet)
        print("Done is \(done)")
        
        
        
        
        
    }
    
    
    func removeWordFromSentance(sentance: String) -> Range<String.Index>?   {
        // Find range of sentance
        let sentanceRanges = article?.ranges(of: sentance)
        guard let sRange = sentanceRanges else {
            return nil
        }
        // If the sentance is repeated consider its first occureance in article
        let sentanceRange = sRange[0]
        
        print("Removing from \(sentance)")
        let words = sentance.tokenizeWords()
        let randomIndex = getRandomNumberBetweenRange(from: 0, to: words.count)
        let stringWord = words[randomIndex]
        let ranges = article?.ranges(of: stringWord)
        guard let rranges = ranges else {
            return nil
        }
        for range in rranges{
            
            if isWhitinSentanceRange(inr: sentanceRange, of: range){
                removedWords[range] = stringWord
                var nsrage = article?.nsRange(from: range)
                var replacedSch = ""
                for _ in 1...stringWord.count{
                    replacedSch = replacedSch + "_"
                }
                
                article?.replaceSubrange(range, with: replacedSch)
                //nsrage = NSRange(location: nsrage!.lowerBound, length: 10)
                nSremovedWords[nsrage!] = stringWord
                
                return range
            }
        }
        return nil
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
                self.titlem = article.displayTitle
                self.removeWordFromSentances(sentances: sentc)
                
            }
            
        }
    }
    
    
    
    // Get a random number in specified range
    func getRandomNumberBetweenRange(from: Int, to: Int) -> Int{
        
        let random = Int.random(in: from..<to)
        return Int(random)
        
    }
    
    
    func getNSRange(characterIndex: Int) -> NSRange?{
        
        
        for r in nSremovedWords.keys{
            
            if characterIndex >= r.lowerBound && characterIndex <= r.upperBound{
                return r
            }
            
        }
        return nil
        
        
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
            var atrRange = NSRange()
            // check if the tap location has a certain attribute
            let attributeName = NSAttributedString.Key.myAttributeName
            let attributeValue = myTextView.attributedText?.attribute(attributeName, at: characterIndex, effectiveRange: &atrRange)
            if let value = attributeValue {
                print("You tapped on \(attributeName.rawValue) and the value is: \(value)")
                
                let index = myTextView.text.index(myTextView.text.startIndex, offsetBy: 5)
                //let index = String.Index(encodedOffset: 5)
                let subString = myTextView.text[..<index]
                let end = myTextView.text.index(myTextView.text.startIndex, offsetBy: 0)
                guard let str = value as? String else{
                    return
                }
                
                print("current \(atrRange.location) and \(atrRange.lowerBound) and \(atrRange.upperBound)")
                
                 startSheetWithWords(nsrange: atrRange, myTextView: myTextView,actualWord: str)
                
               // let mstr = (value as? String)!
               /* guard let range = getNSRange(characterIndex: characterIndex) else {
                    print("Outside Attribute")
                    return
                }
                let newString = myTextView.attributedText.stringReplaceByRange(range: range, str: mstr)
                // var string:NSMutableAttributedString = NSMutableAttributedString(string: mstr )
                // var range = mstr.range(of: mstr.startIndex)
                //string.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: range)
                myTextView.attributedText = newString*/
                
                // myTextView.text.replaceSubrange(end...index, with: (value as? String)!)
                print(subString)
            }
            
        }
    }
    

    
    
    func activityIndicator(_ title: String) {
        
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    func stopIndicator(){
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        activityIndicator.stopAnimating()
        
    }

    func showAlert(msg: String){
        
        
        let alert = UIAlertController(title: "FillBlankGame Alert", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            print("Click event handle")
            //alert.dismiss(animated: true, completion: nil)
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Submission
    
    @IBAction func submit(_ sender: Any) {
        
        
        if answer.count < 10{
            
            // Not all filled
            showAlert(msg: "Fill all blanks and then submit")
            return
            
        }
        evaluateResult()
        
    }
    
    
    func evaluateResult(){
        var score = 0
        for word in answer.keys {
            
            if word == answer[word]{
                score = score + 1
                
            }
            
        }
        print("score is \(score)")
        showAlert(msg: "Your score is \(score)")
        
    }
    
    
    
    
}

extension ArticleViewController{
    
   /* func startActionSheet(){
        
        let actionSheet = Hokusai()
        actionSheet.addButton("Item1", target: self, selector: "onTappedWord")
        actionSheet.addButton("item2", action: {
            print("Action 2")
            })
        
        actionSheet.show()
    }
    @objc func onTappedWord(){
        
        print("Tapped ")
    }*/
    
    
    func updateAttributedRange(nsrange: NSRange, word: String){
        
        for key in nSremovedWords.keys {
            let value = nSremovedWords[key]
            if value == word {
                nSremovedWords.removeValue(forKey: key)
                nSremovedWords[nsrange] = word
                print("Value changed for \(word)")
                return
            }
            
        }
        
        
    }
    
    
    func placeUserSelectedWord(wordd: String, nsrange: NSRange, myTextView: UITextView){
        let newString = myTextView.attributedText.stringReplaceByRange(range: nsrange, str: wordd)
        myTextView.attributedText = newString
    }
    
    /*
     guard let nsrange = self.getNSRange(characterIndex: characterIndex) else{
     print("Some error")
     //let atrRange = self.getNSRange(characterIndex: characterIndex)
     //print("current \(atrRange!.location) and \(atrRange!.lowerBound) and \(atrRange!.upperBound)")
     return
     }
     
     */
    func updateAnswer(ans: String , actual: String){
        answer[actual] = ans
    }
    
    
    func startSheetWithWords(nsrange: NSRange, myTextView: UITextView, actualWord: String){
            startSheetWithWords(nsrange: nsrange, myTextView: myTextView,with: actualWord)
            updateAttributedRange(nsrange: nsrange, word: actualWord)
    }
    
    
    func startSheetWithWords(nsrange: NSRange, myTextView: UITextView, with: String){
        let actionSheet = Hokusai()
        for word in listItems{
            actionSheet.addButton(word, action: {
               
                //let newrange = NSMakeRange(nsrange.location, self.nSremovedWords[nsrange]!.count)
                self.placeUserSelectedWord(wordd: word, nsrange: nsrange, myTextView: myTextView)
                self.listItems.remove(word)
                self.updateAnswer(ans: word, actual: with)
                print("you pressd \(word)")
               
            })
            
        
        }
        actionSheet.show()
        
        
    }
    
    
    func startSheetWithWords(){
        let actionSheet = Hokusai()
        for word in listItems{
            actionSheet.addButton(word, action: {
                print("you pressd \(word)")
            })
        }
        actionSheet.show()
        
        
    }
    
    
}
extension NSAttributedString {
    func getAttributes() -> [(NSRange, [(String, AnyObject)])] {
        var attributesOverRanges : [(NSRange, [(String, AnyObject)])] = []
        var rng = NSRange()
        var idx = 0
        
        while idx < self.length {
            let foo = self.attributes(at: idx, effectiveRange: &rng)
            var attributes : [(String, AnyObject)] = []
            
            for (k, v) in foo { attributes.append((k.rawValue, v as AnyObject)) }
            attributesOverRanges.append((rng, attributes))
            
            idx = max(idx + 1, rng.toRange()?.endIndex ?? 0)
        }
        return attributesOverRanges
    }
}
