//
//  ViewController.swift
//  Calculator
//
//  Created by Dave Gertmenian-Wong on 2/10/15.
//  Copyright (c) 2015 Dave Gertmenian-Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var userIsTypingInitialValue = true

    @IBOutlet weak var display: UILabel!

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("Digit entered: \(digit)")
        
        if userIsTypingInitialValue {
            display.text = digit
            userIsTypingInitialValue = false
        } else {
            display.text = display.text! + digit
        }
    }
    
}

