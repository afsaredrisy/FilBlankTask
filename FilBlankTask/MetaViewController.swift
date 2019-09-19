//
//  MetaViewController.swift
//  STLabelTest
//
//  Created by Introtuce on 17/09/19.
//  Copyright © 2019 Introtuce. All rights reserved.
//

import UIKit
import WikipediaKit

class MetaViewController: UIViewController {
  
    
    var attributedText: NSAttributedString?
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        
        guard let text = attributedText else {
            fatalError("Some Error attributed text not found")
            
        }
        textView.attributedText = text
        
        
        
        
    }
    
    
}
