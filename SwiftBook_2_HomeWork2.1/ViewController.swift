//
//  ViewController.swift
//  SwiftBook_2_HomeWork2.1
//
//  Created by Damir Lutfullin on 08.09.2020.
//  Copyright © 2020 DamirLutfullin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var activeTextField: UITextField?
    
    //MARK: IBOutlets
    @IBOutlet var colorView: UIView!
    @IBOutlet var valueLabels: [UILabel]!
    @IBOutlet var sliders: [UISlider]!
    @IBOutlet var textFields: [UITextField]!
    
    //MARK: ViewController life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorViewColor()
        setupKeyBoards()
        
        textFields.forEach{$0.delegate = self}
    }
    
    func setColorViewColor() {
        colorView.backgroundColor = UIColor(red: CGFloat(sliders[0].value),
                                            green: CGFloat(sliders[1].value),
                                            blue: CGFloat(sliders[2].value),
                                            alpha: 1)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        setColorViewColor()
        valueLabels[sender.tag].text = sender.value.toString()
        textFields[sender.tag].text = sender.value.toString()
    }
    
}

//MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let _ = Double(textFieldText), let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let value = textField.text, let floatValue = Float(value), 0...1 ~= floatValue else {
            textField.text = sliders[textField.tag].value.description
            return true }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
        
        guard let value = textField.text else { return }
        valueLabels[textField.tag].text = value
        sliders[textField.tag].value = Float(value)!
        setColorViewColor()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: Setup keyboard
extension ViewController {
    
    func setupKeyBoards() {
        addDoneButtonOnKeyboards()
        registerForKeyboardNotification()
    }
    
    //MARK: Moving content with the appearance of the keyboard
    func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        // if active text field is not nil
        if let activeTextField = activeTextField {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
                self.view.frame.origin.y = 0 - (bottomOfTextField - topOfKeyboard) - 20
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: addDoneButtonOnKeyboards()
    func addDoneButtonOnKeyboards() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textFields.forEach { (textField) in
            textField.inputAccessoryView = doneToolbar
        }
    }
    
    @objc func doneButtonAction(TF: UITextField){
        view.endEditing(true)
    }
    
    // hide keyboard when tuch screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: Float extension
extension Float {
    func toString() -> String {
        return String(format: "%.2f", self)
    }
}

