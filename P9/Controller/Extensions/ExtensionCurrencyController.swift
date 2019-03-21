//
//  ExtensionCurrencyController.swift
//  P9
//
//  Created by Mac Book Pro on 14/02/2019.
//  Copyright © 2019 dylan. All rights reserved.
//

import Foundation
import UIKit
//====================================
// MARK: Text View Setting
//====================================
extension CurrencyViewController: UITextFieldDelegate {
    
    // called when the user has started editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        textField.text = ""
    }
    
    // called when the user has finished editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // if the textfield.text is different to nil, we create a constant that contains the value of the textfield
        guard let textFieldText = textField.text else { return }
        
        // we check that the text is empty
        guard textFieldText.isEmpty else { return }
        
        textField.attributedPlaceholder = NSAttributedString(string: "Entrez une valeur", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldtext = textField.text else { return false }
        guard string == "." else { return true }
        guard !textFieldtext.contains(".") else { return false }
        guard textFieldtext.count != 0 else { return false }
        return true
    }
}
//====================================
// Picker View Setting
//====================================
extension CurrencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        pickerView.selectRow(Currencies.allCases.count / 2, inComponent: 0, animated: false)
    }
    
    // number of pickerView components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // number of rows in the component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Data.shared.arrayCurrencies.count
    }
    
    // title of the selected row
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        // we change the color of the pickerView text and assign it a text
        let attribute = NSAttributedString(string: Data.shared.arrayCurrencies[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return attribute
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentCurrency = Data.shared.arrayCurrencies[row]
        currencyLabelDestination.text = currentCurrency
    }
    
}

//====================================
// MARK: - General Setting Method
//====================================
extension CurrencyViewController {
    
    func setup() {
        // initialization of the gesture
        view.addGestureToHideKeyboard()
        // we fill the array with the different cases of enumeration
        Data.shared.enumCaseToArrayOrDictionnary(enumeration: .Currencies)
        Data.shared.enumCaseToArrayOrDictionnary(enumeration: .CurrenciesNames)
        // we add the text that corresponding to position of pickerView
        currencyLabelDestination.text = Data.shared.arrayCurrencies[Data.shared.arrayCurrencies.count/2]
    }
    
    // add a value rate and names currency in rateValueDestination property
    func affectValueRateAndNameCurrency(currentCurrencyName: String, reflect: Rates) {
        
        // we create a mirror that reflects all the properties of the Rates structure
        // (allows to make comparisons with the name of a variable for example: if mirror.label == currentNameCurrency)
        let mirrorRates = Mirror(reflecting: reflect)
        
        // contains a array with the names of all currencies (in file Data.swift)
        let currenciesName = Data.shared.currenciesName
        
        // we scan the values in the array to find a match with the selected currency
        for rate in mirrorRates.children {
            
            // rate.label contains the short name of the currency
            if currentCurrencyName == rate.label {
                
                for currencyName in currenciesName {
                    // currencyName.key contains the short name of the currency. example: "AUD"
                    if currentCurrencyName == currencyName.key {
                        
                        // currencyName.value contains the full name of the currency. example: "Australian dollard"
                        let currentRateName = currencyName.value
                        // rate.value contains the value of the rate and the name. example: ("dollars" : "0.95903")
                        guard let rateDouble = rate.value as? Double else { return }
                        ConverterCurrency.shared.changeValueOfRateValueDestination(name: currentRateName, rates: rateDouble)
                    }
                }
            }
        }
    }
}
