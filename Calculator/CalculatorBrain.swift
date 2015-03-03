//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by David Gertmenian-Wong on 3/1/15.
//  Copyright (c) 2015 Dave Gertmenian-Wong. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op: Printable {
        case operand(Double)
        case unaryOperator(String, Double -> Double)
        case binaryOperator(String, (Double, Double)-> Double)
        case variable(String)
        
        var description: String {
            get {
                switch self {
                case .operand(let operand):
                    return "\(operand)"
                case .unaryOperator(let symbol, _):
                    return symbol
                case .binaryOperator(let symbol, _):
                    return symbol
                case .variable(let symbol):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    private var variableValues: [String: Double] = [
        "x": 30
    ]
    
    init() {
        knownOps["✕"] = Op.binaryOperator("✕") { $0 * $1 }
        knownOps["÷"] = Op.binaryOperator("÷") { $1 / $0 }
        knownOps["+"] = Op.binaryOperator("+") { $0 + $1 }
        knownOps["﹣"] = Op.binaryOperator("﹣") { $1 - $0 }
        knownOps["√"] = Op.unaryOperator("√") { sqrt($0) }
        knownOps["sin"] = Op.unaryOperator("sin") { sin($0) }
        knownOps["cos"] = Op.unaryOperator("cos") { cos($0) }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
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
            case .variable(let symbol):
                if let symbolVariable = variableValues[symbol] {
                    return (symbolVariable, remainingOps)
                }
            }
        
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double?) -> Double? {
        if let operandOptional = operand {
            opStack.append(Op.operand(operandOptional))
            return evaluate()
        }
        return nil
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
            return evaluate()
        }
        return nil
    }
    
    func clearStack() {
        opStack = []
    }
    
}
