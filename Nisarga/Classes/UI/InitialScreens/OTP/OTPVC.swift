//
//  OTPVC.swift
//  Nisarga
//
//  Created by Hari Krish on 03/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class OTPVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var mBackImageView: UIImageView!
    @IBOutlet weak var mFirstTF: CustomFontTextField!
    @IBOutlet weak var mSecondTF: CustomFontTextField!
    @IBOutlet weak var mThirdTF: CustomFontTextField!
    @IBOutlet weak var mFouthTF: CustomFontTextField!
    var otp : String! = ""
    var email : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mFirstTF.delegate = self
        self.mSecondTF.delegate = self
        self.mThirdTF.delegate = self
        self.mFouthTF.delegate = self
        mBackImageView.image = mBackImageView.image!.withRenderingMode(.alwaysTemplate)
        mBackImageView.tintColor = UIColor.black
        self.mFirstTF.addBorder()
        self.mSecondTF.addBorder()
        self.mThirdTF.addBorder()
        self.mFouthTF.addBorder()
        //getOTP()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - API
    func getOTP()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/forgetpassword/forgotpassword",Constants.BASEURL)
        print(Url)
        var parameters : Parameters =
        [
            "email_or_mobile" : self.email ?? ""
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
                        self.view.makeToast(JSON["message"] as? String)
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }

    }
    
    func verifyOTP()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/forgetpassword/verifyotp",Constants.BASEURL)
        print(Url)
        let otpStr = self.otp
        let parameters : Parameters =
            [
                "email_or_mobile" : self.email ?? "",
                "otp" : otpStr ?? ""
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
                        self.next()
                        //                        if(JSON["status"] as? String == "success")
                        //                        {
                        //
                        //                        }
                        // self.view.makeToast(JSON["message"] as? String)
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
    }
      // MARK:- Btn Action
    @IBAction func verifyBtnAction(_ sender: Any)
    {
        self.mFirstTF.resignFirstResponder()
        self.mSecondTF.resignFirstResponder()
        self.mThirdTF.resignFirstResponder()
        self.mFouthTF.resignFirstResponder()
        let totalStr = String(format : "%@%@%@%@",self.mFirstTF.text!,self.mSecondTF.text!,self.mThirdTF.text!,self.mFouthTF.text!)
        self.otp = totalStr
        if(totalStr == "")
        {
            self.view .makeToast("Please enter OTP")
            return
        }
//        else if(totalStr != self.otp)
//        {
//            self.view .makeToast("Please enter correct OTP")
//            return
//        }
        else
        {
            verifyOTP()
        }
    }
    
   
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func resendBtnAction(_ sender: Any)
    {
        getOTP()
    }
    func next()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        vc.email = self.email
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK:- Textfield
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        do {
            // This allows numeric text only, but also backspace for deletes
            if string.count > 0 && !Scanner(string: string).scanInt32(nil) {
                return false
            }
            if Int(range.location) > 0 {
                return false
            }
            if (textField.text?.count ?? 0) == 0 {
                // perform(Selector(changeTextFieldFocus:), with: textField, afterDelay: 0)
                perform(#selector(changeTextFieldFocus), with: textField, afterDelay: 0)
            }
            
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92) {
                perform(#selector(keyboardInputShouldDelete), with: textField, afterDelay: 0)
                print("Backspace was pressed")
            }
            //perform(Selector(("secureTextField:")), with: textField, afterDelay: 0)
            //        NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
            //        return !(proposedNewString.length>1);
            return true
        }
    }
    @objc func changeTextFieldFocus(toNextTextField textField: UITextField?) {
        let tagValue: Int = (textField?.tag ?? 0) + 1
        let txtField = view.viewWithTag(tagValue) as? UITextField
        //let value = textField?.text
        if textField?.tag == 101 {
            
        } else if textField?.tag == 102 {
            
        } else if textField?.tag == 103 {
            
        } else if textField?.tag == 104 {
            
        }
        
        txtField?.becomeFirstResponder()
    }
    
    
    
    @objc func keyboardInputShouldDelete(_ textField: UITextField?) -> Bool {
        let shouldDelete = true
        if (textField?.text?.count ?? 0) == 0 && (textField?.text == "") {
            let tagValue: Int = (textField?.tag ?? 0) - 1
            let txtField = view.viewWithTag(tagValue) as? UITextField
            if textField?.tag == 101 {
                
            } else if textField?.tag == 102 {
                
            } else if textField?.tag == 103 {
                
            } else if textField?.tag == 104 {
                
            }
            txtField?.becomeFirstResponder()
        }
        return shouldDelete
    }
    
    func secureTextField(_ txtView: UITextField?) {
        txtView?.isSecureTextEntry = true
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
