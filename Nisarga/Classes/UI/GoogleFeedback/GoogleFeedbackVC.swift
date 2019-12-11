//
//  GoogleFeedbackVC.swift
//  Nisagra
//
//  Created by Apple on 27/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Cosmos

class GoogleFeedbackVC: UIViewController {
    
    @IBOutlet weak var mRatingView: CosmosView!

    @IBOutlet weak var mNameLabel: CustomFontLabel!
    @IBOutlet weak var mProfileImageView: UIImageView!
    @IBOutlet weak var mTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.mNameLabel.text =  UserDefaults.standard.string(forKey: "name") ?? ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any)
    {
        self.view.makeToast("Feedback Submitted Succesfully!")
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
