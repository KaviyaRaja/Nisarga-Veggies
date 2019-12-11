//
//  ViewController.swift
//  PayU
//
//  Created by Suganya on 8/19/19.
//  Copyright © 2019 Suganya. All rights reserved.
//

import UIKit

class PaymentGateway: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        PayUServiceHelper.sharedManager().getPayment("Controller", "mail@mymail.com", "+91-9896952757", "Name", "Amount0011", "", didComplete: { (dict, error) in
//            if let error = error {
//                print("Error")
//            }else {
//                print("Sucess")
//            }
//        }) { (error) in
//            print("Payment Process Breaked")
//        }
        PayUServiceHelper.sharedManager()?.getPayment(self, "Kaviyashetty181@gmail.com", "8682867295", "Kaviya", "10", "123456", didComplete: { (dict, error) in
            if let error = error {
                                print("Error")
                            }else {
                                print("Sucess")
                            }
        }, didFail: { (error) in
            print("Payment Process Breaked")
        })
    }


    // Mark: - Btn Action
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}

