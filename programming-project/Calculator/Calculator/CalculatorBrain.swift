//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by  jasonliao on 22/03/2017.
//  Copyright © 2017  jasonliao. All rights reserved.
//

import Foundation

struct CalendarBrain {
    
    private var accumulator: Double?
    
    var retult: Double? {
        get {
            return accumulator
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        // required tasks 3.
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "ln": Operation.unaryOperation({ log($0) / log(M_E) }),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "±": Operation.unaryOperation({ -$0 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "=": Operation.equals
    ]
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
    
        func perform(with secondOperator: Double) -> Double {
            return function(firstOperand, secondOperator)
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    // required tasks 5.
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
        set {
            if newValue == false {
                pendingBinaryOperation = nil
            }
        }
    }
    // required tasks 6.
    var description = ""
    // required tasks 7 
    var equalsAddAccumulator = true
    
    mutating func performOperation(_ symobl: String) {
        if let operation = operations[symobl] {
            switch operation {
            case .constant(let value):
                accumulator = value
                description = description + " " + symobl + " "
                equalsAddAccumulator = false
            case .unaryOperation(let function):
                if accumulator != nil {
                    if resultIsPending {
                        description = description + symobl + "(" + String(accumulator!) + ")"
                    } else {
                        description = symobl + "(" + description + ")"
                    }
                    accumulator = function(accumulator!)
                    equalsAddAccumulator = false
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    if description == "" {
                        description = String(accumulator!) + " " + symobl + " "
                    } else {
                        description = description + " " + symobl + " "
                    }
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                if equalsAddAccumulator {
                    description = description + String(accumulator!)
                }
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if accumulator != nil && pendingBinaryOperation != nil {
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        equalsAddAccumulator = true
        if !resultIsPending {
            description = ""
        }
    }
    
}
