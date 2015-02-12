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
    var calculatorStack = [Double]()

    @IBOutlet weak var display: UILabel!

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
        userIsTypingInitialValue = true
        println("calculatorStack: \(calculatorStack)")
    }
    
    @IBAction func clear() {
        calculatorStack = []
        displayValue = 0
    }
    
    @IBAction func operand(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if !userIsTypingInitialValue {
            enter()
        }
        
        switch operation {
        case "✕": performCalculation({ (opt1, opt2) -> Double in
            return opt1*opt2
        })
        case "÷": performCalculation() { $1 / $0 }
        case "+": performCalculation({ (opt1, opt2) in opt1 + opt2})
        case "﹣": performCalculation({ (opt1, opt2) in return opt2 - opt1 })
        case "√": performCalculation() { sqrt($0) }
        case "sin": performCalculation() { sin($0) }
        case "cos": performCalculation() { cos($0) }
        default:
            break
        }
    }
    
    func performCalculation(calc: (opt1:Double, opt2: Double) -> Double) {
        if calculatorStack.count >= 2 {
            let digit1 = calculatorStack.removeLast()
            let digit2 = calculatorStack.removeLast()
            let result = calc(opt1: digit1, opt2: digit2)
            displayValue = result
            enter()
        }
    }
    
    func performCalculation(calc: (opt: Double) -> Double) {
        if calculatorStack.count >= 1 {
            displayValue = calc(opt: calculatorStack.removeLast())
            enter()
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

