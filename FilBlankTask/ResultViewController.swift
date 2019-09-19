//
//  ResultViewController.swift
//  FilBlankTask
//
//  Created by Afsar Sir on 18/09/19.
//  Copyright © 2019 Afsar Sir. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var replay: UIButton!
    @IBOutlet weak var result: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    var score: Int?
    var attributedText: NSAttributedString?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setScore()
        //score = 1
        //scoreLabel.text = "S" + String(score!)
        // Do any additional setup after loading the view.
    }
    

    func setScore(){
        print(score)
        guard let s = self.score else {
            scoreLabel.text = "0"
            print("No Value found")
            return
        }
        scoreLabel.text = "" + String(s)
        
        let manager = MaxScoreManager()
        let maxScore = manager.getMax()
        if maxScore < s{
            textLabel.text = "Congratulation MAX Score"
            manager.saveMaxScore(score: s)
        }
        
    }
    
    
    
    //MARK: Action
    
    @IBAction func seeResult(_ sender: Any) {
        
        let storyBord = UIStoryboard(name: "Main",bundle: nil)
        let metaViewController = storyBord.instantiateViewController(withIdentifier: "MetaViewController") as? MetaViewController
        
        guard let metaView = metaViewController else {
            fatalError(" MetaViewController Identifier not found")
        }
        metaView.attributedText = self.attributedText!
        self.navigationController?.pushViewController(metaView, animated: true)
        
    }
    

}
