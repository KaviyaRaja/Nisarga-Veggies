//
//  ResetPasswordVC.swift
//  Nisarga
//
//  Created by Hari Krish on 03/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var mBackImageView: UIImageView!
    @IBOutlet weak var mNewPasswordTF: CustomFontTextField!
    @IBOutlet weak var mConfirmPasswordTF: CustomFontTextField!
    @IBOutlet weak var mEyeButton: UIButton!
    @IBOutlet weak var mEyeButton1: UIButton!
     @IBOutlet weak var mEyeImageView: UIImageView!
    @IBOutlet weak var mEye1ImageView: UIImageView!
    var email : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mBackImageView.image = mBackImageView.image!.withRenderingMode(.alwaysTemplate)
        mBackImageView.tintColor = UIColor.black
        
        self.mNewPasswordTF.addBorder()
        self.mNewPasswordTF.setLeftPaddingPoints(10)
        self.mConfirmPasswordTF.addBorder()
        self.mConfirmPasswordTF.setLeftPaddingPoints(10)
        
        self.mEyeButton.isSelected = true
        self.mNewPasswordTF.isSecureTextEntry = true
        
        self.mEyeButton1.isSelected = true
        self.mConfirmPasswordTF.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Btn Action
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnAction(_ sender: Any)
    {
        if(self.mNewPasswordTF.text == "")
        {
            self.view.makeToast("Please Enter New Password")
            return
        }
        if(self.mConfirmPasswordTF.text == "")
        {
            self.view.makeToast("Please Enter Confirm Password")
            return
        }
        if(self.mNewPasswordTF.text != self.mConfirmPasswordTF.text)
        {
            self.view.makeToast("New Password and Confirm Password should be same")
            return
        }
        resetPassword()
    }
    
    @IBAction func showPasswordBtnAction(_ sender: Any)
    {
        if((sender as AnyObject).tag == 100)
        {
            if(self.mEyeButton.isSelected)
            {
                self.mEyeButton.isSelected = false
                self.mNewPasswordTF.isSecureTextEntry = false
                self.mEyeImageView.image = UIImage(named: "Showpass")
            }
            else{
                self.mEyeButton.isSelected = true
                self.mNewPasswordTF.isSecureTextEntry = true
                self.mEyeImageView.image = UIImage(named: "HidePass")
            }
        }
        else
        {
            if(self.mEyeButton1.isSelected)
            {
                self.mEyeButton1.isSelected = false
                self.mConfirmPasswordTF.isSecureTextEntry = false
                self.mEye1ImageView.image = UIImage(named: "Showpass")
            }
            else{
                self.mEyeButton1.isSelected = true
                self.mConfirmPasswordTF.isSecureTextEntry = true
                self.mEye1ImageView.image = UIImage(named: "HidePass")
            }
        }
    }
    // MARK: - API
    func resetPassword()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/forgetpassword/savechangedpassword",Constants.BASEURL)
        print(Url)
        let parameters : Parameters =
        [
            "email_or_mobile" : self.email ?? "",
            "new_password" : self.mNewPasswordTF.text ?? "",
            "confirm_password" : self.mConfirmPasswordTF.text ?? ""
        ]
        
        print (parameters)
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                SKActivityIndicator.dismiss()
                switch(response.result) {
                    
                case .success:
                    if let json = response.result.value
                    {
                        let JSON = json as! NSDictionary
                        print(JSON)
                        if(JSON["status"] as? String == "success")
                        {
                            self.view.makeToast(JSON["message"] as? String)
                            for controller: UIViewController in (self.navigationController?.viewControllers)! {
                                if (controller is LoginVC) {
                                    self.navigationController?.popToViewController(controller, animated: false)
                                    break
                                }
                            }
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
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
