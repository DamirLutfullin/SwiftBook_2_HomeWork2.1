//
//  ViewController.swift
//  SwiftBook_2_HomeWork2.1
//
//  Created by Damir Lutfullin on 08.09.2020.
//  Copyright © 2020 DamirLutfullin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var colorView: UIView!
    @IBOutlet var valueLabels: [UILabel]!
    @IBOutlet var sliders: [UISlider]!
    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor()

        textFields.forEach { (textField) in
            textField.delegate = self
            addDoneButtonOnKeyboard(textField: textField)
        }
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setColor() {
        colorView.backgroundColor = UIColor(red: CGFloat(sliders[0].value),
                                            green: CGFloat(sliders[1].value),
                                            blue: CGFloat(sliders[2].value),
                                            alpha: 1)
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField) {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        textField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(TF: UITextField){
            view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func sliderAction(_ sender: UISlider) {
        setColor()
        valueLabels[sender.tag].text = sender.value.toString()
        textFields[sender.tag].text = sender.value.toString()
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = textField.text else { return }
        valueLabels[textField.tag].text = value
        sliders[textField.tag].value = Float(value)!
        setColor()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let value = textField.text, let floatValue = Float(value), 0...1 ~= floatValue else {
            textField.text = sliders[textField.tag].value.description
            return true }
        return true
    }
    
}

extension Float {
    func toString() -> String {
        return String(format: "%.2f", self)
    }
}

