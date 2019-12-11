//
//  ForgotPasswordVC.swift
//  Nisarga
//
//  Created by Hari Krish on 03/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var mBackImageView: UIImageView!
    @IBOutlet weak var mEmailTF : CustomFontTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mBackImageView.image = mBackImageView.image!.withRenderingMode(.alwaysTemplate)
        mBackImageView.tintColor = UIColor.black
        
        self.mEmailTF.addBorder()
        self.mEmailTF.setLeftPaddingPoints(10)
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
        if(self.mEmailTF.text == "")
        {
            self.view.makeToast("Please Enter Mobile Number/Email Id")
            return
        }
        getOTP()
    }
    @IBAction func resendBtnAction(_ sender: Any)
    {
        self.getOTP()
        
    }
    
    // MARK: - API
    func getOTP()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/forgetpassword/forgotpassword",Constants.BASEURL)
        print(Url)
        let parameters : Parameters =
        [
            "email_or_mobile" :self.mEmailTF.text ?? ""
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
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let myVC = storyboard.instantiateViewController(withIdentifier: "OTPVC") as? OTPVC
                        myVC?.email = self.mEmailTF.text
                        self.navigationController?.pushViewController(myVC!, animated: false)
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
