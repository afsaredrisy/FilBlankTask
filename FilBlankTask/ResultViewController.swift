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
    
    var score: Int?
    
    
    
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
    }

}
