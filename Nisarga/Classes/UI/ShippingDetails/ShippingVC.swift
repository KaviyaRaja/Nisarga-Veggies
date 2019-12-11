//
//  ShippingVC.swift
//  ECommerce
//
//  Created by Apple on 22/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import Toast_Swift
import SKActivityIndicatorView

class ShippingVC: UIViewController {

    @IBOutlet weak var mDayTF: CustomFontTextField!
    @IBOutlet weak var mInstructionTF: CustomFontTextField!
    @IBOutlet weak var mNumberTF: CustomFontTextField!
    @IBOutlet weak var mNameTF: CustomFontTextField!
     @IBOutlet weak var mLastNameTF: CustomFontTextField!
    @IBOutlet weak var mAddressLabel: CustomFontLabel!
    @IBOutlet weak var mApartmentLabel: CustomFontLabel!
    var deliveryDate : String!
    var addressDict : NSDictionary!
    var count = 0
    var total : String!
    var total_savings : String!
    var total_payable : String!
    var delivery_charge : String = ""
    var address : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mDayTF.text = self.deliveryDate
        
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
            addressDict = dataDict
            self.mApartmentLabel.text =  String(format:"%@",(dataDict["company"] as? String)!)
             self.mNameTF.text =  String(format:"%@",(dataDict["firstname"] as? String)!)
           self.mLastNameTF.text =  String(format:"%@",(dataDict["lastname"] as? String)!)
            self.mNumberTF.text =  String(format:"%@",(dataDict["telephone"] as? String)!)
            self.mAddressLabel.text =  String(format:"%@,%@,%@,%@,%@,%@",(dataDict["block"] as? String)!,(dataDict["floor"] as? String)!,(dataDict["door"] as? String)!,(dataDict["address_1"] as? String)!,(dataDict["city"] as? String)!,(dataDict["postcode"] as? String)!)
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setData), name: NSNotification.Name("RefreshshippingAddress"), object: nil)
        count = 0
    }
    @objc func setData()
    {
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "ShippingAddress") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
            addressDict = dataDict
            self.mNameTF.text =  String(format:"%@",(dataDict["firstname"] as? String)!)
            self.mLastNameTF.text =  String(format:"%@",(dataDict["lastname"] as? String)!)
            self.mNumberTF.text =  String(format:"%@",(dataDict["telephone"] as? String)!)
            self.mApartmentLabel.text = dataDict["company"] as? String
            self.mAddressLabel.text = String(format:"%@,%@,%@,%@,%@,%@,%@",(dataDict["block"] as? String)!,(dataDict["floor"] as? String)!,(dataDict["door"] as? String)!,(dataDict["address_1"] as? String)!,(dataDict["city"] as? String)!,(dataDict["postcode"] as? String)!)
        }
    }
    // MARK: - Btn Action
    @IBAction func backActionBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func faqBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func editBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NewAddressVC") as? NewAddressVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func continueBtnAction(_ sender: Any)
    {
        if(self.mNameTF.text == "")
        {
            self.view.makeToast("Please Enter First Name")
            return
        }
        if(self.mLastNameTF.text == "")
        {
            self.view.makeToast("Please Enter Last Name")
            return
        }
        if(self.mNumberTF.text == "")
        {
            self.view.makeToast("Please Enter Number")
            return
        }
//        if(self.mInstructionTF.text == "")
//        {
//            self.view.makeToast("Please Enter Delivery Instruction")
//            return
//        }
        if(self.mDayTF.text == "")
        {
            self.view.makeToast("Please Select Delivery Date")
            return
        }
        if(self.mAddressLabel.text == "")
        {
            self.view.makeToast("Please Enter Address")
            return
        }
        UserDefaults.standard.setValue(self.mInstructionTF.text, forKey: "DeliveryInstruction")
        shippingAPI()
    }
    //MARK:- API
    func shippingAPI()
    {
        
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/shipping/address_android&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        
     
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "firstname":self.mNameTF.text ?? "",
            "lastname":self.mLastNameTF.text ?? "",
            "address_1":self.mAddressLabel.text ?? "",
            "city":self.addressDict["city"] ?? "",
            "country_id":"IN",
            "zone_id":"KA",
            "company":self.mApartmentLabel.text ?? "",
            "postcode":self.addressDict["postcode"] ?? "",
            "custom_field":self.mInstructionTF.text ?? "",
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
                            self.total = String(format:"%d",(JSON["total"]  as? Int)!)
                            self.total_savings = String(format:"%d",(JSON["total_savings"]  as? Int)!)
                            self.total_payable = String(format:"%d",(JSON["total_payable"]  as? Int)!)
                            let deliverycharge = JSON["delivery_charge"] as? AnyObject
                            self.delivery_charge = String(format:"%@",(deliverycharge as? String)!)
                            let responseArray =  JSON["data"] as? NSArray
                            let dict = responseArray![0] as! NSDictionary
                            self.address = (dict["address_1"] as? String)!
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "CheckOutVC") as? CheckOutVC
                            myVC?.total = self.total
                            myVC?.total_savings = self.total_savings
                            myVC?.delivery_charge = self.delivery_charge
                            myVC?.total_payable = self.total_payable
                            myVC?.address = self.address
                            self.navigationController?.pushViewController(myVC!, animated: true)
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
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

