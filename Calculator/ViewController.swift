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
        if let digit = sender.currentTitle {
            if digit == "." && displayValue != nil && displayValue! % 1 != 0 {
                return
            }
            
            if userIsTypingInitialValue {
                display.text = digit
                userIsTypingInitialValue = false
            } else {
                display.text = display.text! + digit
            }
        }
    }

    @IBAction func enter() {
        userIsTypingInitialValue = true
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            // displayValue should be an optional with a default return value
            displayValue = nil
        }
    }
    
    @IBAction func clear() {
        brain.clearStack()
        displayValue = 0
    }
    
    @IBAction func backspace() {
        if let currentDisplay = display.text {
            let newDisplay = dropLast(currentDisplay)
            display.text = countElements(newDisplay) > 0 ? newDisplay : "0"
        }
    }
    
    @IBAction func plusMinus() {
        if displayValue != nil {
            displayValue! *= -1
        }
        userIsTypingInitialValue = false
    }

    @IBAction func operand(sender: UIButton) {
        if !userIsTypingInitialValue {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func variable(sender: UIButton) {
        if let symbol = sender.currentTitle {
            if let variableDisplay = brain.pushOperand(symbol) {
                displayValue = variableDisplay
            }
        }
    }
    
    // Everytime displayValue is called it gets the display value, unwraps the optional and set it to a Double type.
    // When set, displayValue stores its set value as a string in display.
    var displayValue: Double? {
        get {
            if let validDouble = NSNumberFormatter().numberFromString(display.text!)?.doubleValue {
                return validDouble
            }
            return nil
        }
        set {
            if let displayOptional = newValue {
                display.text = "\(displayOptional)"
                historyStack.text = "\(brain.description) ="
            } else {
                display.text = "err"
            }
            userIsTypingInitialValue = true
        }
    }
}

