//
//  EditProfileVC.swift
//  ECommerce
//
//  Created by Apple on 15/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class EditProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var mPincodeTF: CustomFontTextField!
    @IBOutlet weak var mAddressTF: CustomFontTextField!
    @IBOutlet weak var mDoorNameTF: CustomFontTextField!
    @IBOutlet weak var mApartmentNameTF: CustomFontTextField!
    @IBOutlet weak var mConfirmPasswordTF: CustomFontTextField!
    @IBOutlet weak var mNewPasswordTF: CustomFontTextField!
    @IBOutlet weak var mOldPasswordTF: CustomFontTextField!
    @IBOutlet weak var mNumberTF: CustomFontTextField!
    @IBOutlet weak var mFirstNameTF: CustomFontTextField!
    @IBOutlet weak var mLastNameTF: CustomFontTextField!
    @IBOutlet weak var mEmailTF: CustomFontTextField!
    var imagePicker = UIImagePickerController()
     @IBOutlet weak var mProfileImageView : UIImageView!
    @IBOutlet weak var mOldEyeImageView : UIImageView!
    @IBOutlet weak var mNewEyeImageView : UIImageView!
    @IBOutlet weak var mConfirmEyeImageView : UIImageView!
    @IBOutlet weak var mOldEyeBtn : UIButton!
    @IBOutlet weak var mNewEyeBtn : UIButton!
    @IBOutlet weak var mConfirmEyeBtn : UIButton!
    @IBOutlet weak var mCity: CustomFontTextField!
    @IBOutlet weak var mCityTF: CustomFontTextField!
    var dataDict: NSDictionary!
    var count = 0
    var imageUrl : String = "0"
    var isFromSideMenu : Bool!
    @IBOutlet weak var mNearByLabel : CustomFontLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.isFromSideMenu == false)
        {
            setUI()
        }
        else
        {
            getData()
        }
        self.imagePicker.delegate = self
       // getData()
       
        // Do any additional setup after loading the view.
    }
    func setUI()
    {
        self.mApartmentNameTF.text = self.dataDict["apartment"] as? String
        self.mDoorNameTF.text = self.dataDict["door"] as? String
        self.mCityTF.text = self.dataDict["city"] as? String
        self.mAddressTF.text = self.dataDict["address_1"] as? String
        self.mPincodeTF.text = self.dataDict["postcode"] as? String
        self.mNumberTF.text = self.dataDict["telephone"] as? String
        self.mEmailTF.text = self.dataDict["email"] as? String
        self.mFirstNameTF.text =  self.dataDict["firstname"] as? String
        self.mLastNameTF.text =  self.dataDict["lastname"] as? String
        let nearby = self.dataDict["nearby"] as? String
        if(nearby == "1")
        {
            self.mNearByLabel.isHidden = false
        }
        else{
            self.mNearByLabel.isHidden = true
        }
        var image = self.dataDict["image"] as? String
        if(image != nil){
            image = image?.replacingOccurrences(of: " ", with: "%20")
            self.imageUrl = (self.dataDict["image"] as? String)!
            self.mProfileImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "Rectangle"))
            self.mProfileImageView.layer.cornerRadius = self.mProfileImageView.frame.size.width/2
            self.mProfileImageView.layer.masksToBounds = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     //MARK:- Btn Actions

    @IBAction func updateDetailsBtnAction(_ sender: Any)
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/customer/cusedit",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "firstname" : self.mFirstNameTF.text ?? "",
            "lastname" : self.mLastNameTF.text ?? "",
            "email" : self.mEmailTF.text ?? "",
            "phn" : self.mNumberTF.text ?? "",
            "apartment" : self.mApartmentNameTF.text ?? "",
            "pincode" : self.mPincodeTF.text ?? "",
            "address_1" : self.mAddressTF.text ?? "",
            "old_password" : self.mOldPasswordTF.text ?? "",
            "new_password" : self.mConfirmPasswordTF.text ?? "",
            "door" : self.mDoorNameTF.text ?? "",
            //"address_1" : self.mAreaTF.text ?? "",
            "city" : self.mCityTF.text ?? "",
            "apartmentId" : self.dataDict["apartment_id"] as? String ?? "",
            "profile_pic" : self.imageUrl ,
             "nearby" : self.dataDict["nearby"] as? String ?? "",
//             UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: dataDict), forKey: "MyProfileVC")
//             NotificationCenter.default.post(name: NSNotification.Name("RefreshMyProfile"), object: nil)
//            self.navigationController?.popViewController(animated: true)
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
                         self.navigationController?.popViewController(animated: true)
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
    
   
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func eyeBtnAction(_ sender: Any)
    {
        if((sender as AnyObject).tag == 1)
        {
            if(self.mOldEyeBtn.isSelected)
            {
                self.mOldEyeBtn.isSelected = false
                self.mOldPasswordTF.isSecureTextEntry = false
                self.mOldEyeImageView.image = UIImage(named: "Showpass")
            }
            else{
                self.mOldEyeBtn.isSelected = true
                self.mOldPasswordTF.isSecureTextEntry = true
                 self.mOldEyeImageView.image = UIImage(named: "HidePass")
            }
        }
        else if((sender as AnyObject).tag == 2)
        {
            if(self.mNewEyeBtn.isSelected)
            {
                self.mNewEyeBtn.isSelected = false
                self.mNewPasswordTF.isSecureTextEntry = false
                self.mNewEyeImageView.image = UIImage(named: "Showpass")
            }
            else{
                self.mNewEyeBtn.isSelected = true
                self.mNewPasswordTF.isSecureTextEntry = true
                self.mNewEyeImageView.image = UIImage(named: "HidePass")
            }
        }
        else if((sender as AnyObject).tag == 3)
        {
            if(self.mConfirmEyeBtn.isSelected)
            {
                self.mConfirmEyeBtn.isSelected = false
                self.mConfirmPasswordTF.isSecureTextEntry = false
                self.mConfirmEyeImageView.image = UIImage(named: "Showpass")
            }
            else{
                self.mConfirmEyeBtn.isSelected = true
                self.mConfirmPasswordTF.isSecureTextEntry = true
                self.mConfirmEyeImageView.image = UIImage(named: "HidePass")
            }
        }
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
        self.imageUploading()
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
        let imageData = UIImageJPEGRepresentation(img!, 1.0)
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
                        self.uploadImage()
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
            SKActivityIndicator.dismiss()
        }
    }
    // MARK: - API
    func uploadImage()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/uploadprofile/editNavImage",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
                "customer_id" : userID ?? "",
                "profile_pic" : self.imageUrl ?? "",
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
                          UserDefaults.standard.setValue(self.imageUrl, forKey: "ProfilePic")
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
