//
//  ViewController.swift
//  DatabaseDemo
//
//  Created by Bhagyashree Mahajan on 26/09/18.
//  Copyright © 2018 KK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtfName: UITextField!
    @IBOutlet weak var txtfAge: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func  btnAdd(_ sender: UIButton) {
        let isInserted = ModelManager.getInstance().saveData(name: txtfName.text!, age: txtfAge.text!)
        
        if isInserted
        {
            print("yes")
        }
        else
        {
            print("no")
        }
    }
    
    @IBAction func  btnDisplay(_ sender: UIButton) {
        let getTime = ModelManager.getInstance().getData()
        
        print(getTime.age)
         print(getTime.name)
    }
}

