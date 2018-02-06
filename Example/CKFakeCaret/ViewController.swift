//
//  ViewController.swift
//  CKFakeCaret
//
//  Created by chengkai1853@163.com on 02/06/2018.
//  Copyright (c) 2018 chengkai1853@163.com. All rights reserved.
//

import UIKit
import CKFakeCaret

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.setupFakeCaret()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func click(_ sender: Any) {
        textField.text = (textField.text ?? "") + "a"
    }
}

