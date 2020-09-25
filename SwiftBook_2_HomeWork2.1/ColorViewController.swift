//
//  ColorViewController.swift
//  SwiftBook_2_HomeWork2.1
//
//  Created by Damir Lutfullin on 25.09.2020.
//  Copyright © 2020 DamirLutfullin. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {
    
    weak var colorDelegate: SendingColorDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let color = colorDelegate?.color else { return }
        view.backgroundColor = color
    }
}

protocol SendingColorDelegate: class {
    var color: UIColor? {get set}
}
