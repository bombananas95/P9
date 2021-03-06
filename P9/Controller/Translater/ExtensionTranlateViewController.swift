//
//  ExtensionTranlateController.swift
//  P9
//
//  Created by Mac Book Pro on 14/02/2019.
//  Copyright © 2019 dylan. All rights reserved.
//

import UIKit

//============================================
// MARK:---------Text View Settings-----------
//============================================
extension TranlateViewController: UITextViewDelegate {
    
    // this method is called every time the user starts writing 
    public func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = Constants.stringEmpty
    }
    
    // this method is called each time the user has finished writing
    public func textViewDidEndEditing(_ textView: UITextView) {
        // if the text is empty, a placeholder is assigned
        if textView.text.isEmpty {
            textView.text = Constants.placeholderTranslater
            self.view.hideKeyboard()
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard textView == textToTranslate else { return false }
        
        let allowedCharacters = Constants.allowedCharacters
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: text)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        
        if textView.text.first != "^" && textView.text.first != "`" && textView.text.first != "'" {
            //
            if textView.text.count + text.count < 100 {
                return alphabet
            } else {
                if text == Constants.stringEmpty {
                    return alphabet
                } else {
                    return false
                }
            }
        }
        return false
    }
}

//============================================
// MARK:---------Picker View Settings---------
//============================================
extension TranlateViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        pickerViewTargetLang.selectRow(Languages.allCases.count / 2, inComponent: 0, animated: false)
    }
    // number of pickerView components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // number of rows in the component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Languages.allCases.count
    }
    
    // title of the selected row
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        // we change the color of the pickerView text and assign it a text
        let attribute = NSAttributedString(string: Languages.allCases[row].rawValue, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return attribute
    }
    
    // we update the text of the label each time the selected value of the pickerView changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentLanguage = Languages.allCases[row].rawValue
        translaterService.getTargetLang(forSetup: false, row: row)
        languageDestinationLabel.text = currentLanguage
    }
}

extension TranlateViewController {
    
    func setup() {
        view.addGestureToHideKeyboard()
        translaterService.getTargetLang(forSetup: true, row: nil)
        print(translaterService.targetLang)
    }
}
