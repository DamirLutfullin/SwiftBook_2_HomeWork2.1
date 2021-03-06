//
//  ViewController.swift
//  SwiftBook_2_HomeWork2.1
//
//  Created by Damir Lutfullin on 08.09.2020.
//  Copyright © 2020 DamirLutfullin. All rights reserved.
//

import UIKit

class SetColorViewController: UIViewController {
    
    weak var delegate: SendingColorDelegate?
    var activeTextField: UITextField?
    var colorFromColorViewController: CIColor!
    
    //MARK: IBOutlets
    @IBOutlet var colorView: UIView!
    @IBOutlet var valueLabels: [UILabel]!
    @IBOutlet var sliders: [UISlider]!
    @IBOutlet var textFields: [UITextField]!
    
    //MARK: ViewController life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorFromColorVC(color: colorFromColorViewController)
        
        setupKeyBoards()
        textFields.forEach{$0.delegate = self}
        
        colorView.layer.cornerRadius = 18
        
        
        
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        setColorViewColor()
        valueLabels[sender.tag].text = sender.value.toString()
        textFields[sender.tag].text = sender.value.toString()
    }
    
    @IBAction func applyColorButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.getColor(colorView.backgroundColor!)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func changeStatusBarColor() {
        let statusBarBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        statusBarBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.9952029586, blue: 0.9402899742, alpha: 1)
        view.insertSubview(statusBarBackgroundView, at: 0)
    }
    
    //Set color of ColorView from sliders value
    private func setColorViewColor() {
        colorView.backgroundColor = UIColor(red: CGFloat(sliders[0].value),
                                            green: CGFloat(sliders[1].value),
                                            blue: CGFloat(sliders[2].value),
                                            alpha: 1)
//        delegate?.getColor(colorView.backgroundColor!)
//
    }
    
    //Установка цвета при переходе от главного скрина
    private func setColorFromColorVC(color: CIColor) {
        
        let rgbArray = [Float(color.red), Float(color.green), Float(color.blue)]
        
        for index in 0...2 {
            sliders[index].value = rgbArray[index]
            textFields[index].text = rgbArray[index].toString()
            valueLabels[index].text = rgbArray[index].toString()
        }
        colorView.backgroundColor = UIColor(ciColor: colorFromColorViewController)
    }
}

//MARK: UITextFieldDelegate
extension SetColorViewController: UITextFieldDelegate {
    
    //set active TF for moving content with keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText)
        else { return false }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let value = textField.text, let floatValue = Float(value), 0...1 ~= floatValue else {
            textField.text = sliders[textField.tag].value.toString()
            return true }
        textField.text = floatValue.toString()
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

//MARK: Set keyboard
extension SetColorViewController {
    
    private func setupKeyBoards() {
        addDoneButtonOnKeyboards()
        registerForKeyboardNotification()
    }
    
    //MARK: Moving content with the appearance of the keyboard
    private func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            print("dont got keyboardSize")
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
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: addDoneButtonOnKeyboards()
    private func addDoneButtonOnKeyboards() {
        
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
    
    @objc private func doneButtonAction(textField: UITextField){
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

