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
    
    var brain = CalculatorBrain()

    @IBOutlet weak var display: UILabel!

    @IBOutlet weak var historyStack: UILabel!

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." && displayValue % 1 != 0 {
            return
        }
        
        if digit == "π" {
            display.text = "\(M_PI)"
            return enter()
        }
        
        if userIsTypingInitialValue {
            display.text = digit
            userIsTypingInitialValue = false
        } else {
            display.text = display.text! + digit
        }
    }

    @IBAction func enter() {
        userIsTypingInitialValue = true
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            // displayValue should be an optional with a default return value
            displayValue = 0
        }
    }
    
    @IBAction func clear() {
        displayValue = 0
    }
    
    @IBAction func operand(sender: UIButton) {
        if !userIsTypingInitialValue {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    // Everytime displayValue is called it gets the display value, unwraps the optional and set it to a Double type.
    // When set, displayValue stores its set value as a string in display.
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsTypingInitialValue = true
        }
    }
}

