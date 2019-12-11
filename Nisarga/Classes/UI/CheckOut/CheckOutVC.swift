//
//  CheckOutVC.swift
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

class CheckOutVC: UIViewController {

    @IBOutlet weak var mDeliveyDayLabel: CustomFontLabel!
    @IBOutlet weak var mDeliveryInstructionLabel: CustomFontLabel!
    @IBOutlet weak var mAddressLabel: CustomFontLabel!
    @IBOutlet weak var mApartmentLabel: CustomFontLabel!
    @IBOutlet weak var mNumberLabel: CustomFontLabel!
    @IBOutlet weak var mNameLabel: CustomFontLabel!
    @IBOutlet weak var mApproximateLabel: CustomFontLabel!
    @IBOutlet weak var mTotalSavingsLabel: CustomFontLabel!
    @IBOutlet weak var mCartValueLabel: CustomFontLabel!
    @IBOutlet weak var mDeliveryValueLabel: CustomFontLabel!
    
    var total : String = ""
    var total_savings : String = ""
     var total_payable : String = ""
    var totalArray : NSArray!
    var delivery_charge : String = ""
    var address : String = ""
    
   override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mDeliveryInstructionLabel.sizeToFit()
        self.mCartValueLabel.text = String(format:"₹%@",self.total)
         self.mApproximateLabel.text = String(format:"₹%@",self.total_payable)
         self.mTotalSavingsLabel.text = String(format:"- ₹%@",self.total_savings)
         self.mDeliveryValueLabel.text = String(format:"+ ₹%@",self.delivery_charge)
    
        setData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.setShippingData), name: NSNotification.Name("RefreshshippingAddress"), object: nil)
    }
     func setData()
    {
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
            self.mNameLabel.text =  String(format:"%@",(dataDict["firstname"] as? String)!,(dataDict["telephone"] as? String)!)
            self.mNumberLabel.text =  String(format:"%@",(dataDict["telephone"] as? String)!)
            self.mApartmentLabel.text = dataDict["company"] as? String
//             self.mAddressLabel.text = String(format:"%@,%@,%@,%@,%@,%@,%@",(dataDict["block"] as? String)!,(dataDict["floor"] as? String)!,(dataDict["door"] as? String)!,(dataDict["address_1"] as? String)!,(dataDict["city"] as? String)!,(dataDict["postcode"] as? String)!)
             self.mAddressLabel.text = self.address
            self.mDeliveyDayLabel.text = UserDefaults.standard.string(forKey: "DeliveryDate")
            
            self.mDeliveryInstructionLabel.text = UserDefaults.standard.string(forKey: "DeliveryInstruction")
        }
    }
    @objc func setShippingData()
    {
         //setData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
    @IBAction func faqBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func confirmBtnAction(_ sender: Any)
    {
        orderAddApi()
    }
    @IBAction func editBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NewAddressVC") as? NewAddressVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }

    
    func orderAddApi()
    {
       
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/order/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let date =  UserDefaults.standard.string(forKey: "DeliveryDay")
        let parameters: Parameters =
            [
                "delivery_date" : date ?? "",
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
                            let responseArray =  JSON["data"] as? NSArray
                            let dict = responseArray![0] as! NSDictionary
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "ConfirmationVC") as? ConfirmationVC
                            myVC?.dataDict = dict
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
