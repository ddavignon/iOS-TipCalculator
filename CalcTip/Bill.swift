//
//  Bill.swift
//  CalcTip
//
//  Created by Dustin D'Avignon on 2/21/18.
//  Copyright © 2018 Dustin D'Avignon. All rights reserved.
//

import Foundation


struct Bill {
    
    var billAmount = 0.0
    var tipPercentage = 0.0
    var splitAmount = 1.0
    
    var getSplitAmountTotal: Double {
        get {
            return billAmountWithTip() / splitAmount
        }
    }
    
    var getBillTotal: Double {
        get {
            return billAmountWithTip()
        }
    }
    
    var getTipAmount: Double {
        get {
           return billAmount * (tipPercentage/100)
        }
    }
    
    private func billAmountWithTip() -> Double {
        return billAmount * (1 + (tipPercentage/100))
    }
    
}
