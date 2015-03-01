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
        println("Digit entered: \(digit)")
        
        if digit == "." && displayValue % 1 != 0 {
            return
        }
        
        println(digit)
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
        calculatorStack.append(displayValue)
        
        if historyStack.text! == "History" {
            historyStack.text = ""
        }
        
        historyStack.text = historyStack.text! + " \(displayValue)"
        userIsTypingInitialValue = true
        println("calculatorStack: \(calculatorStack)")
    }
    
    @IBAction func clear() {
        calculatorStack = []
        displayValue = 0
        historyStack.text = "History"
    }
    
    @IBAction func operand(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if !userIsTypingInitialValue {
            enter()
        }
        
        historyStack.text = historyStack.text! + " \(operation)"
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

