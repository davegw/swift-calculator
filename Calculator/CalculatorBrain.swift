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
        case constant(String)
        
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
                case .constant(let const):
                    return const
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    private var knownConstants: [String: Double] = [
        "π": M_PI
    ]
    
    var variableValues = [String: Double]()
    
    var description: String {
        get {
            if let opDescription = description(opStack).result {
                return opDescription
            }
            return "Error"
        }
    }
    
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var currentOpStack = ops
            let op = currentOpStack.removeLast()
            switch op {
            case .operand(let operand):
                return ("\(operand)", currentOpStack)
            case .variable(let symbol):
                return (symbol, currentOpStack)
            case .constant(let constant):
                return (constant, currentOpStack)
            case .unaryOperator(let symbol, _):
                let opEvaluate = description(currentOpStack)
                if let operandDescription = opEvaluate.result {
                    return ("\(symbol)(\(operandDescription))", opEvaluate.remainingOps)
                }
            case .binaryOperator(let symbol, _):
                let op1Evaluate = description(currentOpStack)
                if let op1Description = op1Evaluate.result {
                    let op2Evaluate = description(op1Evaluate.remainingOps)
                    if let op2Description = op2Evaluate.result {
                        return ("\(op2Description)\(symbol)\(op1Description)", op2Evaluate.remainingOps)
                    }
                }
            }
        }
        return ("?", ops)
    }
    
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
                if let symbolValue = variableValues[symbol] {
                    return (symbolValue, remainingOps)
                }
            case .constant(let constant):
                if let constantValue = knownConstants[constant] {
                    return (constantValue, remainingOps)
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        println(description)
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
        if knownConstants[symbol] != nil {
            opStack.append(Op.constant(symbol))
        } else {
            opStack.append(Op.variable(symbol))
        }
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
        variableValues.removeAll()
    }
    
}
