//
//  CheckOutPayNowVC.swift
//  ECommerce
//
//  Created by Apple on 23/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import Toast_Swift
import SKActivityIndicatorView

class CheckOutPayNowVC: UIViewController {

    @IBOutlet weak var mwalletcheckbtn: UIButton!
    @IBOutlet weak var mDayLabel: CustomFontLabel!
    @IBOutlet weak var mInstructionLabel: CustomFontLabel!
    @IBOutlet weak var mAddressLabel: CustomFontLabel!
    @IBOutlet weak var mNumberLabel: CustomFontLabel!
    @IBOutlet weak var mApartmentLabel: CustomFontLabel!
    @IBOutlet weak var mNameLabel: CustomFontLabel!
    @IBOutlet weak var mOrderLabel: CustomFontLabel!
    @IBOutlet weak var mInvoiceLabel: CustomFontLabel!
    @IBOutlet weak var mOrderNoLabel: CustomFontLabel!
    @IBOutlet weak var mItemsLabel: CustomFontLabel!
    @IBOutlet weak var mSubTotalLabel: CustomFontLabel!
    @IBOutlet weak var mDeliveryChargesLabel: CustomFontLabel!
    @IBOutlet weak var mVariablePriceLabel: CustomFontLabel!
    @IBOutlet weak var mTotalLabel: CustomFontLabel!
    var orderID : String!
    var resultArray : NSArray = []
    var isNisargaSelected : String = ""
    var transactionId : String = ""
    var status : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
self.transactionId = SingletonClass.sharedInstance.randomString(withLength: 10)!
        // Do any additional setup after loading the view.
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - API
    func getData()
    {
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "order_id" : self.orderID ?? ""
        ]
        print (parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        let Url = String(format: "%@api/order/MyorderProductList",Constants.BASEURL)
        print(Url)
        SKActivityIndicator.show("Loading...")
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
                            let responseArray =  JSON["customer_details"] as? NSArray
                            self.resultArray =  (JSON["result"] as? NSArray)!
                            let dict = responseArray![0] as! NSDictionary
                            let resultDict = self.resultArray[0] as! NSDictionary
                            self.mApartmentLabel.text = dict["apartment"] as? String
                            self.mInvoiceLabel.text = dict["invoice_prefix"] as? String
                            self.mOrderNoLabel.text = dict["order_id"] as? String
                            self.mOrderLabel.text = dict["order_id"] as? String
                            self.mNameLabel.text = String(format:"%@ %@",(dict["firstname"] as? String)!,(dict["lastname"] as? String)!)
                            self.mNumberLabel.text = dict["telephone"] as? String
                            self.mApartmentLabel.text = dict["apartment"] as? String
                            self.mInstructionLabel.text = dict["delivery_instruction"] as? String
                            self.mDayLabel.text = dict["delivery_date"] as? String
                            let variablePriceSting = String(format : "%@",resultDict["revised_price"] as? String ?? "")
                            let variablePriceDouble =  Double (variablePriceSting)
                            self.mVariablePriceLabel.text = String(format : "₹%.2f",variablePriceDouble!)
                            self.mItemsLabel.text = String(format: "%@ Items",(JSON["TotalProduct"] as? String)!)
                            self.mAddressLabel.text = dict["shipping_address_1"] as? String
                            
                            let totalPriceSting = String(format : "%d",JSON["totalMoney"] as? Int ?? "")
                            self.mTotalLabel.text = String(format : "₹%@",totalPriceSting)
                            
                            let subTotalPriceSting = String(format : "%d",JSON["sub_total"] as? Int ?? "")
                           // let subTotalPriceDouble =  Double (subTotalPriceSting)
                            self.mSubTotalLabel.text = String(format : "₹%@",subTotalPriceSting)
                            
                            let deliveryChargeSting = String(format : "%",JSON["delivery_charges"] as? Int ?? "")
                            if(deliveryChargeSting == "")
                            {
                                self.mDeliveryChargesLabel.text = String(format : "₹0.00")
                            }
                            else{
                            self.mDeliveryChargesLabel.text = String(format : "₹%@",deliveryChargeSting)
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
    
// MARK: - Btn Action
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func faqBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func payNowBtnAction(_ sender: Any)
    {
        var amount = self.mTotalLabel.text!
        amount.remove(at: amount.startIndex)
        PayUServiceHelper.sharedManager()?.getPayment(self, "Kaviyashetty18@gmail.com", "8682867295", "Kaviya", amount, self.transactionId, didComplete: { (dict, error) in
            if let error = error {
                print("Error")
                self.status = "failure"
                self.onlinePaymentApi()
            }else {
                print("Sucess")
                self.status = "success"
                if(self.isNisargaSelected == "1")
                {
                    self.getWalletMoney()
                }
                else{
                    self.onlinePaymentApi()
                }
            }
        }, didFail: { (error) in
            print("Payment Process Breaked")
        })
    }
    @IBAction func checkBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "CheckOutListVC") as? CheckOutListVC
        myVC?.itemsArray = self.resultArray
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func walletcheckBtnAction(_ sender: Any) {
        
            if(self.mwalletcheckbtn.isSelected)
            {
                self.mwalletcheckbtn.isSelected = false
                self.mwalletcheckbtn.setImage(UIImage(named: "Uncheckbox"), for: .normal)
                isNisargaSelected = "0"
            }
            else
            {
                self.mwalletcheckbtn.isSelected = true
                self.mwalletcheckbtn.setImage(UIImage(named: "checkbox"), for: .normal)
                isNisargaSelected = "1"
            }
        self.status = "failure"
        self.getWalletMoney()
    }
    func getWalletMoney()
    {
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "order_id" : self.orderID ?? "",
                "wallet" : isNisargaSelected,
                "status" : self.status
        ]
        print (parameters)
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
        let Url = String(format: "%@api/payment/useWallet",Constants.BASEURL)
        print(Url)
        SKActivityIndicator.show("Loading...")
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
                            if(JSON["total_to_be_paid"] as? Int == 0)
                            {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let myVC = storyboard.instantiateViewController(withIdentifier: "PayNowSuccessVC") as? PayNowSuccessVC
                                self.navigationController?.pushViewController(myVC!, animated: true)
                                
                            }
                            else{
                                self.view.makeToast(JSON["message"] as? String)
                                self.mTotalLabel.text = String(format:"₹%d",(JSON["total_to_be_paid"] as? Int)!)
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
    func onlinePaymentApi()
    {
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "order_id" : self.orderID ?? "",
                "status" : self.status
        ]
        print (parameters)
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
        let Url = String(format: "%@api/payment/onlinePayment",Constants.BASEURL)
        print(Url)
        SKActivityIndicator.show("Loading...")
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
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "PayNowSuccessVC") as? PayNowSuccessVC
                            self.navigationController?.pushViewController(myVC!, animated: true)
                            
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "PayNowSuccessVC") as? PayNowSuccessVC
                            self.navigationController?.pushViewController(myVC!, animated: true)
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
