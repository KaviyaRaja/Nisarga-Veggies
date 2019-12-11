//
//  ConfirmationVC.swift
//  Nisarga
//
//  Created by Hari Krish on 11/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class ConfirmationVC: UIViewController {

    @IBOutlet weak var mSubmitBtn: CustomFontButton!
    @IBOutlet weak var mFeedbackView: UIView!
    @IBOutlet weak var mTextView: UITextView!
    @IBOutlet weak var mRateView: CosmosView!
    @IBOutlet weak var mAddressLabel: CustomFontLabel!
    @IBOutlet weak var mApartmentLabel: CustomFontLabel!
    @IBOutlet weak var mDeliveryChargeLabel: CustomFontLabel!
    @IBOutlet weak var mOrderAmountLabel: CustomFontLabel!
    @IBOutlet weak var mTotalSavingsLabel: CustomFontLabel!
    @IBOutlet weak var mStatusLabel: CustomFontLabel!
    @IBOutlet weak var mMessageLabel: CustomFontLabel!
    @IBOutlet weak var mTotalAmount: CustomFontLabel!
    
    var dataDict : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mFeedbackView.layer.cornerRadius = 5
        self.mFeedbackView.layer.borderColor = UIColor.lightGray.cgColor
        self.mFeedbackView.layer.borderWidth = 1
        self.mSubmitBtn.layer.cornerRadius = 5
        self.mSubmitBtn.layer.borderWidth = 1
        self.mSubmitBtn.layer.borderColor = UIColor(red:0.20, green:0.47, blue:0.24, alpha:1.0).cgColor
        self.mMessageLabel.text = String(format: "Dear Member Your Order is confirmed, will be delivered %@ Morning.Thank You",UserDefaults.standard.string(forKey:  "DeliveryDate")!)
        self.mOrderAmountLabel.text = String(format:"₹%d",(self.dataDict["cart_total"] as? Int)!)
        self.mDeliveryChargeLabel.text = String(format:"₹%@",(self.dataDict["delivery_charges"] as? String)!)
        self.mTotalSavingsLabel.text = String(format:"₹%d",(self.dataDict["savings"] as? Int)!)
        self.mTotalAmount.text = String(format:"₹%d",(self.dataDict["total"] as? Int)!)
        self.mStatusLabel.text = "Pending"
        self.mAddressLabel.text = String(format:"%@",(self.dataDict["address"] as? String)!)
        setData()
    }
    func setData()
    {
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
            self.mApartmentLabel.text = dataDict["company"] as? String
           // self.mAddressLabel.text = String(format:"%@,%@,%@,%@,%@,%@,%@",(dataDict["block"] as? String)!,(dataDict["floor"] as? String)!,(dataDict["door"] as? String)!,(dataDict["address_1"] as? String)!,(dataDict["area"] as? String)!,(dataDict["city"] as? String)!,(dataDict["postcode"] as? String)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Mark: - Btn Action
    @IBAction func backBtnAction(_ sender: Any)
    {
        Constants.appDelegate?.goToHome()
    }
    @IBAction func submitBtnAction(_ sender: Any)
    {
        submitRate()
        
    }
    // MARK: - API
    func submitRate()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/orderreview/giveOrderreview",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let orderID = self.dataDict["order_id"] as? String
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "rating" : mRateView.rating,
            "feedback" : self.mTextView.text ?? "",
            "order_id" : orderID ?? ""
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
                            Constants.appDelegate?.goToHome()
                            self.view.makeToast("Thanks for your Valuable Feedback!")
                            self.mRateView.removeFromSuperview()
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
