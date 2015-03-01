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
        case operand(Double), unaryOperator(String, Double -> Double), binaryOperator(String, (Double, Double)-> Double)
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["✕"] = Op.binaryOperator("✕") { $0 * $1 }
        knownOps["÷"] = Op.binaryOperator("÷") { $1 / $0 }
        knownOps["+"] = Op.binaryOperator("+") { $0 + $1 }
        knownOps["﹣"] = Op.binaryOperator("﹣") { $1 - $0 }
        knownOps["√"] = Op.unaryOperator("√") { sqrt($0) }
        knownOps["sin"] = Op.unaryOperator("sin") { sin($0) }
        knownOps["cos"] = Op.unaryOperator("cos") { cos($0) }
    }
    
    func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .operand(let operand):
                return (operand, remainingOps)
            case .unaryOperator(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .binaryOperator(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
    }
    
    func pushOperand(operand: Double) {
        opStack.append(Op.operand(operand))
    }
    
    func performOpeartion(symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
    
}
