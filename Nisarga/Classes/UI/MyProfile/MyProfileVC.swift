//
//  MyProfileVC.swift
//  ECommerce
//
//  Created by Apple on 15/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class MyProfileVC: UIViewController {
    @IBOutlet weak var mProfileImage: UIImageView!
    @IBOutlet weak var mFirstName: CustomFontLabel!
    @IBOutlet weak var mmobileNo: CustomFontLabel!
    @IBOutlet weak var mEmail: CustomFontLabel!
    @IBOutlet weak var mAppartrmenText: CustomFontTextField!
    @IBOutlet weak var mDoorText: CustomFontTextField!
    @IBOutlet weak var mAreaTexrt: CustomFontTextField!
    @IBOutlet weak var mAddressText: CustomFontTextField!
    @IBOutlet weak var mPinCodeTF: CustomFontTextField!
    @IBOutlet weak var mNearByLabel : CustomFontLabel!
    var dataDict: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    @IBAction func mProfileBackArrow(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func mEditProfile(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.dataDict = self.dataDict
        vc.isFromSideMenu = false
         self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - API
    
    func getData()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/myprofile/Myprofile",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? ""
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
                            let responseArray =  JSON["result"] as? NSArray
                            self.dataDict = responseArray![0] as! NSDictionary
                            self.mAppartrmenText.text = self.dataDict["apartment"] as? String
                            self.mDoorText.text = self.dataDict["door"] as? String
                            self.mAreaTexrt.text = self.dataDict["address_1"] as? String
                            self.mAddressText.text = self.dataDict["address_1"] as? String
                            self.mPinCodeTF.text = self.dataDict["postcode"] as? String
                            self.mmobileNo.text = self.dataDict["telephone"] as? String
                            self.mEmail.text = self.dataDict["email"] as? String
                            self.mFirstName.text =  String(format: "%@ %@",(self.dataDict["firstname"] as? String)!,(self.dataDict["lastname"] as? String)!)
                            var image = self.dataDict["image"] as? String
                            if(image != nil){
                                image = image?.replacingOccurrences(of: " ", with: "%20")
                                self.mProfileImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "Rectangle"))
                                self.mProfileImage.layer.cornerRadius = self.mProfileImage.frame.size.width/2
                                self.mProfileImage.layer.masksToBounds = true
                                UserDefaults.standard.setValue(image, forKey: "ProfilePic")
                            }
                            let nearby = self.dataDict["nearby"] as? String
                            if(nearby == "1")
                            {
                                self.mNearByLabel.isHidden = false
                            }
                            else{
                                self.mNearByLabel.isHidden = true
                            }
                            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: self.dataDict), forKey: "UserData")
                            NotificationCenter.default.post(name: NSNotification.Name("REFRESHSIDEMENU"), object: nil)

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
