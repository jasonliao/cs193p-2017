//
//  ViewController.swift
//  Calculator
//
//  Created by  jasonliao on 21/03/2017.
//  Copyright © 2017  jasonliao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var userIsInTheMiddleOfTyping = false

    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    private var brain = CalendarBrain()
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            // required tasks 2.
            let hasFloatingPoint = display.text!.contains(".")
            
            if digit == "." && hasFloatingPoint {
                return
            }
            
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
            
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.retult {
            displayValue = result
        }
        if brain.resultIsPending {
            descriptionLabel.text = brain.description + "..."
        } else {
            descriptionLabel.text = brain.description + " = "
        }
    }
    
    // required tasks 8
    @IBAction func clear(_ sender: UIButton) {
        descriptionLabel.text = ""
        display.text = "0"
        userIsInTheMiddleOfTyping = false
        
        brain.description = ""
        brain.equalsAddAccumulator = true
        brain.resultIsPending = false
    }
    

}

