//
//  PaynowFailureVC.swift
//  Nisarga
//
//  Created by Hari Krish on 28/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class PaynowFailureVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func backBtnAction(_ sender: Any)
    {
        Constants.appDelegate?.goToHome()
    }
    @IBAction func mGoBackBtn(_ sender: Any)
    {
        Constants.appDelegate?.goToHome()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
