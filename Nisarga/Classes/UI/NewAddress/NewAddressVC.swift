//
//  NewAddressVC.swift
//  Nisagra
//
//  Created by Apple on 25/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class NewAddressVC: UIViewController {

    @IBOutlet weak var mPinCodeTF: CustomFontTextField!
    @IBOutlet weak var mAddressTF: CustomFontTextField!
    @IBOutlet weak var mCityTF: CustomFontTextField!
    @IBOutlet weak var mAreaTF: CustomFontTextField!
    @IBOutlet weak var mFloorTF: CustomFontTextField!
    @IBOutlet weak var mApartmentTF: CustomFontTextField!
    @IBOutlet weak var mDoorTf: CustomFontTextField!
    @IBOutlet weak var mBlockTF: CustomFontTextField!
    @IBOutlet weak var mPhoneNoTF: UITextField!
    @IBOutlet weak var mEmailTF: CustomFontTextField!
    @IBOutlet weak var mLastNemTF: CustomFontTextField!
    @IBOutlet weak var mFirstNameTF: CustomFontTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
             self.mFirstNameTF.text =  String(format:"%@",(dataDict["firstname"] as? String)!)
            self.mLastNemTF.text =  String(format:"%@",(dataDict["lastname"] as? String)!)
            self.mEmailTF.text =  String(format:"%@",(dataDict["email"] as? String)!)
            self.mPhoneNoTF.text =  String(format:"%@",(dataDict["telephone"] as? String)!)
            self.mApartmentTF.text =  String(format:"%@",(dataDict["company"] as? String)!)
            self.mBlockTF.text =  String(format:"%@",(dataDict["block"] as? String)!)
            self.mDoorTf.text =  String(format:"%@",(dataDict["door"] as? String)!)
            self.mFloorTF.text =  String(format:"%@",(dataDict["floor"] as? String)!)
            self.mAreaTF.text =  String(format:"%@",(dataDict["address_1"] as? String)!)
            self.mCityTF.text =  String(format:"%@",(dataDict["city"] as? String)!)
            self.mAddressTF.text =  String(format:"%@",(dataDict["address_2"] as? String)!)
            self.mPinCodeTF.text =  String(format:"%@",(dataDict["postcode"] as? String)!)
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addNewAddressBtn(_ sender: Any)
    {
        if(self.mApartmentTF.text == "")
        {
            self.view.makeToast("Please Enter Appartment Name")
            return
        }
        
        if(self.mDoorTf.text == "")
        {
            self.view.makeToast("Please Enter Door Number")
            return
        }
        if(self.mFloorTF.text == "")
        {
            self.view.makeToast("Please Enter Floor Number")
            return
        }
        if(self.mBlockTF.text == "")
        {
            self.view.makeToast("Please Enter Block Number")
            return
        }
        if(self.mAddressTF.text == "")
        {
            self.view.makeToast("Please Enter Address")
            return
        }
        if(self.mAreaTF.text == "")
        {
            self.view.makeToast("Please Enter Area")
            return
        }
        if(self.mCityTF.text == "")
        {
            self.view.makeToast("Please Enter City")
            return
        }
        if(self.mPinCodeTF.text == "")
        {
            self.view.makeToast("Please Enter Pincode")
            return
        }
        let dataDict : NSMutableDictionary = [:]
        dataDict.setValue(self.mFirstNameTF.text ?? "", forKey: "firstname")
        dataDict.setValue(self.mLastNemTF.text ?? "", forKey: "lastname")
        dataDict.setValue(self.mEmailTF.text ?? "", forKey: "email")
        dataDict.setValue(self.mPhoneNoTF.text ?? "", forKey: "telephone")
        dataDict.setValue(self.mApartmentTF.text ?? "", forKey: "company")
        dataDict.setValue(self.mDoorTf.text ?? "", forKey: "door")
        dataDict.setValue(self.mFloorTF.text ?? "", forKey: "floor")
        dataDict.setValue(self.mBlockTF.text ?? "", forKey: "block")
        dataDict.setValue(self.mAddressTF.text ?? "", forKey: "address_1")
        dataDict.setValue(self.mAreaTF.text ?? "", forKey: "area")
        dataDict.setValue(self.mCityTF.text ?? "", forKey: "city")
        dataDict.setValue(self.mPinCodeTF.text ?? "", forKey: "postcode")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: dataDict), forKey: "ShippingAddress")
         NotificationCenter.default.post(name: NSNotification.Name("RefreshshippingAddress"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func faqtnAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func BackBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
