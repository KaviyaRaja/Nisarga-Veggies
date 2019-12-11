//
//  ContactUsVC.swift
//  Nisagra
//
//  Created by Apple on 27/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class ContactUsVC: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var mWebView: UIWebView!
    @IBOutlet weak var mHeaderLabel : CustomFontLabel!
    var screenType : String!
    var contactText : String!
    @IBOutlet weak var mDescriptionLabel : CustomFontLabel!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(self.screenType == "About")
        {
            self.mHeaderLabel.text = "About & Contact us"
        }
        else if(self.screenType == "Terms")
        {
            self.mHeaderLabel.text = "Terms & Conditions"
        }
        else if(self.screenType == "Policy")
        {
            self.mHeaderLabel.text = "Policy"
        }
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Btn Action
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - API
    
    func getData()
    {
        
        var id : String!
        if(self.screenType == "About")
        {
            id = "7"
        }
      if(self.screenType == "ContactUs")
        {
            id = "4"
        }
        else if(self.screenType == "Terms")
        {
            id = "5"
        }
        else if(self.screenType == "Policy")
        {
            id = "3"
        }
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/custom/pages",Constants.BASEURL)
        print(Url)
        let parameters: Parameters =
        [
                "id" : id ?? ""
        ]
        print(parameters)
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
                            let resultArray = (JSON["result"] as? NSArray)!
                            let dict = resultArray[0] as! NSDictionary
                            if(self.screenType == "About")
                            {
                                self.contactText = String(format:"%@ %@",dict["title"] as! String,dict["desciption"] as! String)
                                self.screenType = "ContactUs"
                                self.getData()
                            }
                            else if(self.screenType == "ContactUs")
                            {
                                let htmlStr = String(format: "%@%@%@",self.contactText,dict["title"] as! String,dict["desciption"] as! String)
                                self.mDescriptionLabel.attributedText = htmlStr.convertHtml()
                                self.mDescriptionLabel.sizeToFit()
                                self.descriptionHeight.constant = self.mDescriptionLabel.bounds.size.height
                            }
                            else
                            {
                                let htmlStr = dict["desciption"] as! String
                                self.mDescriptionLabel.attributedText = htmlStr.convertHtml()
                                self.mDescriptionLabel.sizeToFit()
                                self.descriptionHeight.constant = self.mDescriptionLabel.bounds.size.height
                                let descStr = dict["description"] as? String ?? ""
                                print(descStr)
                                //self.mWebView.loadHTMLString(descStr, baseURL: nil)
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
