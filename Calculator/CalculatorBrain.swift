//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by David Gertmenian-Wong on 3/1/15.
//  Copyright (c) 2015 Dave Gertmenian-Wong. All rights reserved.
//

import Foundation

class CalculatorBrain {
    enum Op {
        case operand(Double), unaryOperator(String, Double -> Double), doubleOperator(String, (Double, Double)-> Double)
    }
    
    var opStack = [Op]()
    
    var knownOps = [String:Op]()
    
    func pushOperand(operand: Double) {
        opStack.append(Op.operand(operand))
    }
    
    func performOpeartion(symbol: String) {
    
    }
    
}
