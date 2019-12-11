//
//  WalletVC.swift
//  ECommerce
//
//  Created by Apple on 11/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class WalletVC: UIViewController {

    @IBOutlet weak var nisargaWalletView: UIView!
    @IBOutlet weak var nisargaWalletImage: UIImageView!
    @IBOutlet weak var walletAmount: UILabel!
    @IBOutlet weak var addmoneyButton: UIButton!
    @IBOutlet weak var loyalityView: UIView!
        @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var redeemButton: UIButton!
    
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var transactionImageView: UIImageView!
    
   
    
     override func viewDidLoad() {
        super.viewDidLoad()

      nisargaWalletView.layer.shadowColor = UIColor.darkGray.cgColor
      nisargaWalletView.layer.shadowOffset = CGSize(width: 1, height:3)
      nisargaWalletView.layer.shadowOpacity = 0.6
      nisargaWalletView.layer.shadowRadius = 3.0
      nisargaWalletView.layer.cornerRadius = 5.0
        
        
        loyalityView.layer.shadowColor = UIColor.darkGray.cgColor
        loyalityView.layer.shadowOffset = CGSize(width: 1, height:3)
        loyalityView.layer.shadowOpacity = 0.6
        loyalityView.layer.shadowRadius = 3.0
        loyalityView.layer.cornerRadius = 5.0
        
        transactionView.layer.shadowColor = UIColor.darkGray.cgColor
        transactionView.layer.shadowOffset = CGSize(width: 1, height:3)
        transactionView.layer.shadowOpacity = 0.6
        transactionView.layer.shadowRadius = 3.0
        transactionView.layer.cornerRadius = 5.0
        
       addmoneyButton.layer.masksToBounds = true
     addmoneyButton.layer.cornerRadius = 5
     addmoneyButton.layer.borderWidth = 0.50
        
       redeemButton.layer.masksToBounds = true
        redeemButton.layer.cornerRadius = 5
        redeemButton.layer.borderWidth = 0.50
        
        historyButton.layer.masksToBounds = true
       historyButton.layer.cornerRadius = 5
        historyButton.layer.borderWidth = 0.50
        
        getWalletBalance()
        getLoyalityPoints()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Btn Action
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func faqBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func historyButton(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "PaymentHistoryVC") as? PaymentHistoryVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func addMoneyButton(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "AddMoneyVC") as? AddMoneyVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func redeemButton(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "LoyalityPointsVC") as?  LoyalityPointsVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    // MARK:- API
    func getWalletBalance()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/customer/getwalletbalance",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? ""
        ]
        
        print (parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SKActivityIndicator.dismiss()
            print(response)
            
            switch(response.result) {
                
            case .success:
                if let json = response.result.value
                {
                    let JSON = json as! NSDictionary
                    print(JSON)
                    if(JSON["status"] as? String == "success")
                    {
                        let balance = JSON["data"] as? String
                        if(balance == "0")
                        {
                            self.walletAmount.text = ""
                        }
                        else
                        {
                            self.walletAmount.text = String(format:"₹%@",balance!)
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
    func getLoyalityPoints()
{
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/customer/getloyaltypoints",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "0"
        ]
            print (parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SKActivityIndicator.dismiss()
            print(response)
            switch(response.result) {
                
            case .success:
                if let json = response.result.value
                {
                    let JSON = json as! NSDictionary
                    print(JSON)
                    if(JSON["status"] as? String == "success")
                    {
                        let balance = JSON["data"] as? String
                        if(balance == "0")
                        {
                            self.pointsLabel.text = "0 points"
                        }
                        else
                        {
                            self.pointsLabel.text = String(format:"₹%@",balance!)
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
}


