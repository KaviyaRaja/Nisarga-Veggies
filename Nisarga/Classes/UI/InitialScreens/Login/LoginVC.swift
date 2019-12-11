 //  LoginVC.swift
//  Nisagra
//
//  Created by Suganya on 7/31/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
import Foundation

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func addBorder() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
}
extension String {
    var isDigits: Bool {
        guard !self.isEmpty else { return false }
        return !self.contains { Int(String($0)) == nil }
    }
}
class LoginVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,IQDropDownTextFieldDelegate {
    
    
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var loginHeight: NSLayoutConstraint!
    @IBOutlet weak var innerHeight: NSLayoutConstraint!
    @IBOutlet weak var signupHeight: NSLayoutConstraint!
    @IBOutlet weak var mSelectBtn: UIButton!
    @IBOutlet weak var mPasswordTF: CustomFontTextField!
    @IBOutlet weak var mEmailIdTF: CustomFontTextField!
    @IBOutlet weak var mLoginView: UIView!
    @IBOutlet weak var mSignupView: UIView!
    @IBOutlet weak var mCircularView: UIView!
    @IBOutlet weak var mLoginLineLabel: UILabel!
    @IBOutlet weak var msignupLineLabel: UILabel!
    @IBOutlet weak var mDescLabel : CustomFontLabel!
    var isLogin: Bool = true
    var isEmail : Bool = true
    var imagePicker = UIImagePickerController()
    var imageUrl : String = "0"
    @IBOutlet weak var mProfileImageView : UIImageView!
    @IBOutlet weak var mFirstNameTF: CustomFontTextField!
    @IBOutlet weak var mLastNameTF: CustomFontTextField!
    @IBOutlet weak var mMobileNoTF: CustomFontTextField!
    @IBOutlet weak var mEmailTF: CustomFontTextField!
    @IBOutlet weak var mBlockTF: CustomFontTextField!
    @IBOutlet weak var mFloorTF: CustomFontTextField!
    @IBOutlet weak var mApartmentTF: IQDropDownTextField!
    @IBOutlet weak var msignupPasswordTF: CustomFontTextField!
    @IBOutlet weak var mApartmentBtn: UIButton!
    @IBOutlet weak var mPinCodeTF: CustomFontTextField!
    @IBOutlet weak var mLandMarkTF: CustomFontTextField!
    @IBOutlet weak var mAddressTF: CustomFontTextField!
    @IBOutlet weak var mAreaTF: CustomFontTextField!
    @IBOutlet weak var mDoorTF: CustomFontTextField!
    @IBOutlet weak var mCityTF: CustomFontTextField!
    
    var area : String = ""
    
    var apartmentArray = [String]()
    var apartmentIdArray : NSArray = []
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setUI()
    }
    func setUI()
    {
        if(self.isLogin)
        {
            self.mDescLabel.text = "Log In to Continue"
            self.mLoginView.isHidden = false
            self.mSignupView.isHidden = true
            self.loginHeight.constant = 210
            self.innerHeight.constant = self.loginHeight.constant + 100
           
            self.mLoginLineLabel.isHidden = false
            self.msignupLineLabel.isHidden = true
            self.mSelectBtn.isSelected = false
            self.mSelectBtn .setImage(UIImage(named: "Uncheckbox"), for: .normal)
            let isRememberMe =  UserDefaults.standard.string(forKey: "isRememberMe")
            if(isRememberMe == "1")
            {
                self.mSelectBtn.isSelected = true
                self.mSelectBtn .setImage(UIImage(named: "checkbox"), for: .normal)
                self.mEmailIdTF.text = UserDefaults.standard.string(forKey: "LoginEmail")
                self.mPasswordTF.text = UserDefaults.standard.string(forKey: "LoginPassword")
            }
        }
        else
        {
            self.mDescLabel.text = "Sign up to Continue"
            self.mLoginLineLabel.isHidden = true
            self.msignupLineLabel.isHidden = false
            self.mLoginView.isHidden = true
            self.mSignupView.isHidden = false
            self.signupHeight.constant = 950
            self.innerHeight.constant = self.signupHeight.constant + 100
            self.mApartmentBtn.isSelected = false
            self.mApartmentBtn .setImage(UIImage(named: "Uncheckbox"), for: .normal)
            if(self.apartmentArray.count == 0)
            {
                getApartments()
            }
            else
            {
                 self.mApartmentTF.itemList = self.apartmentArray
            }
            imagePicker.delegate = self
            //self.mProfileImageView.image = UIImage(named:"Empty Cart")
        }
         self.contentHeight.constant = self.innerHeight.constant + 50
        // Do any additional setup after loading the view.
        self.mCircularView.layer.cornerRadius = self.mCircularView.frame.size.width/2
        self.mCircularView.layer.masksToBounds = true
        
        self.mEmailIdTF.addBorder()
        self.mEmailIdTF.setLeftPaddingPoints(10)
        
        self.mPasswordTF.addBorder()
        self.mPasswordTF.setLeftPaddingPoints(10)
        
        self.mFirstNameTF .addBorder()
        self.mFirstNameTF.setLeftPaddingPoints(10)
        
        self.mLastNameTF .addBorder()
        self.mLastNameTF.setLeftPaddingPoints(10)
        
        self.mMobileNoTF .addBorder()
        self.mMobileNoTF.setLeftPaddingPoints(10)
        
        self.mEmailTF .addBorder()
        self.mEmailTF.setLeftPaddingPoints(10)
        
        self.mBlockTF .addBorder()
        self.mBlockTF.setLeftPaddingPoints(10)
        
        self.mFloorTF .addBorder()
        self.mFloorTF.setLeftPaddingPoints(10)
        
        self.mApartmentTF .addBorder()
        self.mApartmentTF.setLeftPaddingPoints(10)
        
        
        self.msignupPasswordTF .addBorder()
        self.msignupPasswordTF.setLeftPaddingPoints(10)
        
        self.mPinCodeTF .addBorder()
        self.mPinCodeTF.setLeftPaddingPoints(10)
        
        self.mLandMarkTF .addBorder()
        self.mLandMarkTF.setLeftPaddingPoints(10)
        
//        self.mAddressTF .addBorder()
//        self.mAddressTF.setLeftPaddingPoints(10)
        
        self.mAreaTF .addBorder()
        self.mAreaTF.setLeftPaddingPoints(10)
        
        self.mDoorTF .addBorder()
        self.mDoorTF.setLeftPaddingPoints(10)
        
        self.mCityTF .addBorder()
        self.mCityTF.setLeftPaddingPoints(10)
    }
    // MARK: - Button Actions
    @IBAction func loginBtnAction(_ sender: Any)
    {
        self.isLogin = true
        setUI()
    }
    @IBAction func signupBtnAction(_ sender: Any)
    {
        self.isLogin = false
        setUI()
    }
    @IBAction func profileBtnAction(_ sender: Any)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
    
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func appartmentBtnAction(_ sender: Any)
    {
        if(self.mApartmentBtn.isSelected)
        {
            self.mApartmentBtn.isSelected = false
            self.mApartmentBtn .setImage(UIImage(named: "Uncheckbox"), for: .normal)
             self.mAreaTF.text = self.area
        }
        else
        {
            self.mApartmentBtn.isSelected = true
            self.mApartmentBtn .setImage(UIImage(named: "checkbox"), for: .normal)
            self.mAreaTF.text = ""
        }
    }
    
    @IBAction func selectBtnAction(_ sender: Any)
    {
        if(self.mSelectBtn.isSelected)
        {
            self.mSelectBtn.isSelected = false
            self.mSelectBtn .setImage(UIImage(named: "Uncheckbox"), for: .normal)
        }
        else
        {
            self.mSelectBtn.isSelected = true
            self.mSelectBtn .setImage(UIImage(named: "checkbox"), for: .normal)
        }
    }
    @IBAction func forgotBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    @IBAction func goBtnAction(_ sender: Any)
    {
        
        if(self.isLogin)
        {
            self.loginValidations()
        }
        else
        {
            self.signupValidations()
        }
        
       // self.next()
    }
    func loginValidations()
    {
        if(self.mEmailIdTF.text == "")
        {
            self.view.makeToast("Please Enter Mobile Number/Email Id")
            return
        }
        else if((self.mEmailIdTF.text?.count)! > 0)
        {
            let letters = CharacterSet.letters
            let phrase = self.mEmailIdTF.text
            let range = phrase?.rangeOfCharacter(from: letters)
            // range will be nil if no letters is found
            if let test = range {
                print("letters found")
                self.isEmail = self.isValidEmail(emailStr: self.mEmailIdTF.text!)
                if(self.isEmail == false)
                {
                    self.view.makeToast("Please Enter valid EmailID")
                    return
                }
            }
            else {
                print("letters not found")
                self.isEmail = false
                if((self.mEmailIdTF.text?.count)! < 10)
                {
                    self.view.makeToast("Please Enter valid Mobile Number")
                    return
                }
            }
        }
        if(self.mPasswordTF.text == "")
        {
            self.view.makeToast("Please Enter Password")
            return
        }
        self.mEmailIdTF.resignFirstResponder()
        self.mPasswordTF.resignFirstResponder()
        self.loginAPI()
    }
    func signupValidations()
    {
        if(self.mFirstNameTF.text == "")
        {
            self.view.makeToast("Please Enter First Name")
            return
        }
        
        if(self.mLastNameTF.text == "")
        {
            self.view.makeToast("Please Enter Last Name")
            return
        }
        else if((self.mMobileNoTF.text?.count)! < 10)
        {
            self.view.makeToast("Please Enter valid Mobile Number")
            return
        }
        if(self.mEmailTF.text == "")
        {
            self.view.makeToast("Please Enter EmailID")
            return
        }
        else if (self.isValidEmail(emailStr: self.mEmailTF.text!) == false)
        {
            self.view.makeToast("Please Enter valid EmailID")
            return
        }
        if(self.msignupPasswordTF.text == "")
        {
            self.view.makeToast("Please Enter Password")
            return
        }
        if(self.mApartmentTF.selectedItem == "")
        {
            self.view.makeToast("Please Enter Apartment Name")
            return
        }
        if(self.mDoorTF.text == "")
        {
            self.view.makeToast("Please Enter Door Number")
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
        self.signupAPI()
    }
    func next()
    {
        UserDefaults.standard.setValue("1", forKey: "isLoggedin")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func loginNavigation()
    {
        if(mSelectBtn.isSelected == true)
        {
            UserDefaults.standard.setValue("1", forKey: "isRememberMe")
            UserDefaults.standard.setValue(self.mEmailIdTF.text, forKey: "LoginEmail")
            UserDefaults.standard.setValue(self.mPasswordTF.text, forKey: "LoginPassword")
        }
        self.next()
    }
    // MARK: - Textfield Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == self.mMobileNoTF)
        {
            if(range.location > 9)
            {
                return false
            }
        }
        return true
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
     // MARK: - API
    func loginAPI()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/login",Constants.BASEURL)
        print(Url)
        let parameters : Parameters =
        [
            "user" : self.mEmailIdTF.text ?? "",
            "password" : self.mPasswordTF.text ?? ""
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
                        if(JSON["status"] as? String == "success")
                        {
                            let responseArray =  JSON["data"] as? NSArray
                            let dict = responseArray![0] as! NSDictionary
                            UserDefaults.standard.setValue(dict["customer_id"] as? String, forKey: "customer_id")
                            UserDefaults.standard.setValue(dict["image"] as? String, forKey: "ProfilePic")
                            UserDefaults.standard.setValue(dict["api_token"] as? String, forKey: "api_token")
                             UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: dict), forKey: "UserData")
                             NotificationCenter.default.post(name: NSNotification.Name("REFRESHSIDEMENU"), object: nil)
                            self.setCustomerDetails()
                            
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
    func signupAPI()
    {
        let selectedRow = self.mApartmentTF.selectedRow
        let idDict = self.apartmentIdArray[selectedRow] as? NSDictionary
        var apartmentID : String!
        apartmentID = idDict!["apartment_id"] as? String
        
        var nearby : String!
        if(self.mSelectBtn .isSelected)
        {
            nearby = "1"
        }
        else
        {
            nearby = "0"
        }
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/customer/register",Constants.BASEURL)
        print(Url)
        let parameters : Parameters =
        [
            "firstname" : self.mFirstNameTF.text ?? "",
            "lastname" : self.mLastNameTF.text ?? "",
            "mobile" : self.mMobileNoTF.text ?? "",
            "email" : self.mEmailTF.text ?? "",
            "password" : self.msignupPasswordTF.text ?? "",
            "apartment_name" : self.mApartmentTF.selectedItem ?? "",
            "block" : self.mBlockTF.text ?? "",
            "floor" : self.mFloorTF.text ?? "",
            "door" : self.mDoorTF.text ?? "",
            "address" : self.mAreaTF.text ?? "",
            //"address" : self.mAddressTF.text ?? "",
            "pincode" : self.mPinCodeTF.text ?? "",
            "landmark" : self.mLandMarkTF.text ?? "",
            "city" : self.mCityTF.text ?? "",
            "apartment_id" : apartmentID ?? "",
            "profile" : self.imageUrl,
            "nearby" : nearby ?? ""
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
                        if(JSON["status"] as? String == "success")
                        {
                             self.view.makeToast(JSON["message"] as? String)
                            self.isLogin = true
                            self.mEmailIdTF.text = ""
                            self.mPasswordTF.text = ""
                            self.mSelectBtn.isSelected = false
                            self.mSelectBtn .setImage(UIImage(named: "Uncheckbox"), for: .normal)
                            self.setUI()
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
    func getApartments()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/custom/getApartments",Constants.BASEURL)
        print(Url)
        Alamofire.request(Url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
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
                            self.apartmentIdArray = (JSON["data"] as? NSArray)!
                            for dict in responseArray! {
                                let name = (dict as AnyObject).object(forKey: "name") as? String
                                self.apartmentArray.append(name!)
                                self.mApartmentTF.itemList = self.apartmentArray
                               // self.imageUploading()
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
    func setCustomerDetails()
    {
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
        }
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/customer/customerindex&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "firstname" : dataDict["firstname"] ?? "",
                "lastname" : dataDict["lastname"] ?? "",
                "address_1" : dataDict["address_1"] ?? "",
                "city" : dataDict["city"] ?? "",
                "country_id" : "IN",
                "zone_id" : "KA",
                "company" : dataDict["company"] ?? "",
                "address_2" : dataDict["address_2"] ?? "",
                "postcode" : dataDict["postcode"] ?? "",
                "telephone" : dataDict["telephone"] ?? "",
                "email" : dataDict["email"] ?? "",
                "customer_group_id" : dataDict["customer_group_id"] ?? "",
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
                            
                            self.fcmRegistration()
                        }
                        else
                        {
                             self.fcmRegistration()
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    func fcmRegistration()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/custom/NotifyToken",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let deviceID =  UserDefaults.standard.string(forKey: "deviceToken")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "token" : deviceID ?? ""
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
                            self.loginNavigation()
                        }
                        else
                        {
                            self.loginNavigation()
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    func imageUploading()
    {
        if(count == 1)
        {
            return
        }
        else if(count == 0)
        {
            count = count + 1
        }
        SKActivityIndicator.show("Loading...")
        let img = self.mProfileImageView.image
        let imageData = UIImageJPEGRepresentation(img!, 0.6)
        let url = String(format: "%@api/uploadprofile/fileupload",Constants.BASEURL)
        print(url)
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
                if let data = imageData{
                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let json = response.result.value
                    {
                        let JSON = json as! NSDictionary
                        print(JSON)
                        self.imageUrl = (JSON["files"] as? String)!
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
             SKActivityIndicator.dismiss()
        }
    }
    //MARK:-- Image Picker
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            self.mProfileImageView.image = pickedImage
            self.mProfileImageView.contentMode = .scaleToFill
            self.mProfileImageView.layer.cornerRadius = self.mProfileImageView.frame.size.width/2
            self.mProfileImageView.layer.masksToBounds = true
        }
        picker.dismiss(animated: true, completion: nil)
        
        imageUploading()
    }
     //MARK: IQDropdown delegate
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        print ("textFieldTag=\(textField.tag)")
        print ("item=\(textField.selectedRow)")
        if (textField.selectedRow == -1) {
            textField.selectedRow = 1
        }
        let selectedRow = textField.selectedRow
        let dict = self.apartmentIdArray[selectedRow] as? NSDictionary
        self.mAreaTF.text = dict!["address"] as? String
        area = (dict!["address"] as? String)!
        self.mCityTF.text = dict!["city"] as? String
        self.mPinCodeTF.text = dict!["pincode"] as? String
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
