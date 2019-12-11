//
//  ReferEarnVC.swift
//  Nisagra
//
//  Created by Apple on 26/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class ReferEarnVC: UIViewController {

    @IBOutlet weak var mLinkLabel: CustomFontLabel!
    @IBOutlet weak var mCodeTF: CustomFontTextField!
    @IBOutlet weak var mBorderView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mBorderView.layer.cornerRadius = 5
        self.mBorderView.layer.borderWidth = 1
        self.mBorderView.layer.borderColor = UIColor.lightGray.cgColor
        getCode()
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
    @IBAction func notificationBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func faqBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func copyBtnAction(_ sender: Any)
    {
        if((self.mCodeTF.text?.count)! > 0)
        {
        UIPasteboard.general.string = self.mCodeTF.text
        }
    }
    @IBAction func shareBtnAction(_ sender: Any)
    {
        // text to share
        let text = self.mLinkLabel.text
        let items = [text]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    // MARK: - API
    
    func getCode()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/customer/fatchRefaralCode",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
        ]
        print(parameters)
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
                            let resultArray = JSON["data"] as! NSArray
                            let dict = resultArray[0] as! NSDictionary
                            self.mCodeTF.text = dict["referal_code"] as? String
                            self.mLinkLabel.text = String(format:"Link : www.nisagara.com/refer/%@",(dict["referal_code"] as? String)!)
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
