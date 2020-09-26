//
//  ColorViewController.swift
//  SwiftBook_2_HomeWork2.1
//
//  Created by Damir Lutfullin on 25.09.2020.
//  Copyright © 2020 DamirLutfullin. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, SendingColorDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let setColorVC = segue.destination as! SetColorViewController
        setColorVC.delegate = self
        setColorVC.colorFromColorViewController = CIColor(color: view.backgroundColor!)
    }
    
    func getColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}

protocol SendingColorDelegate: class {
    func getColor(_ color: UIColor)
}
