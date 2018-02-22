//
//  ViewController.swift
//  CalcTip
//
//  Created by Dustin D'Avignon on 2/21/18.
//  Copyright © 2018 Dustin D'Avignon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var billTextField: UITextField! {
        didSet {
            setDoneOnKeyboard()
        }
    }
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var splitTipAmountLabel: UILabel!
    @IBOutlet weak var splitTipTotalAmount: UILabel!
    
    var currentSliderValue = 15
    var currentSplitSliderValue = 1

    var myBill = Bill()
    
    override func viewDidLoad() {
        billTextField.delegate = self
        billTextField.clearsOnBeginEditing = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
    
    
    func updateCurrentLabels() {
        let tipValue = currentSliderValue
        guard var amount = billTextField.text else { return }
        
        tipLabel.text = "Tip (\(tipValue)%)"
        
        if amount == "" { return }
        
        if (amount[amount.startIndex] == "$") {
            amount.remove(at: amount.startIndex)
        }
        
        myBill.billAmount = (amount as NSString).doubleValue
        
        myBill.tipPercentage = Double(tipValue)
        
        billTextField.text = "$\(String(format:"%.2f", myBill.billAmount))"
        tipAmountLabel.text = "$\(String(format:"%.2f", myBill.getTipAmount))"
        totalAmountLabel.text = "$\(String(format:"%.2f", myBill.getBillTotal))"
        updateSplitLabels()
    }
    
    func updateSplitLabels() {
        let splitValue = currentSplitSliderValue
        
        splitTipAmountLabel.text = "Split (\(splitValue))"
        splitTipTotalAmount.text = "$\(String(format:"%.2f", myBill.getSplitAmountTotal))"
    }
    
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        currentSliderValue = lroundf(sender.value)
        updateCurrentLabels()
    }
    
    @IBAction func splitTipSliderMoved(_ sender: UISlider) {
        currentSplitSliderValue = lroundf(sender.value)
        myBill.splitAmount = Double(currentSplitSliderValue)
        updateSplitLabels()
    }
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.billTextField.inputAccessoryView = keyboardToolbar
    }
    
    @objc func dismissKeyboard() {
        updateCurrentLabels()
        view.endEditing(true)
    }
    
}

extension String {
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        let decimalSeperator = formatter.decimalSeparator ?? "."
        
        if formatter.number(from: self) != nil {
            let split = self.components(separatedBy: decimalSeperator)
            
            let digits = split.count == 2 ? split.last ?? "" : ""
            
            return digits.count <= maxDecimalPlaces
        }
        return false
    }
}
