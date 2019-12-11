//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
import Alamofire
import SKActivityIndicatorView
class LeftViewController: UITableViewController, UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
//    var titlesArray : NSMutableArray = ["Home","My Order","My Address","My Wallet","Offers","Refer & Earn","Rate Us","About & Contact US","FAQ","Terms & Conditions","Google Feedback","Policy","Logout"]
//    var imagesArray : NSMutableArray = ["Home","shopping-cart","MyAddress","Wallet2","Offers","Shape","rateus","support","Help","Combined Shape","Googlefeedback","Policy","Logout"]
    var titlesArray : NSMutableArray = ["Home","My Order","My Wallet","Refer & Earn","Rate Us","About & Contact US","FAQ","Terms & Conditions","Google Feedback","Policy","Logout"]
    var imagesArray : NSMutableArray = ["Home","shopping-cart","Wallet2","Shape","rateus","support","Help","Combined Shape","Googlefeedback","Policy","logout_yellow"]
    
    @IBOutlet weak var mHeaderView : UIView!
    @IBOutlet weak var mProfileImage : UIImageView!
    @IBOutlet weak var mNameLabel : UILabel!
    @IBOutlet weak var mmEmailLabel : UILabel!
    @IBOutlet weak var mMobileLabel : UILabel!
    var dataDict: NSDictionary!
    var count = 0
    var imageUrl : String = "0"
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        self.tableView.tableHeaderView = self.mHeaderView
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 44.0, right: 0.0)
        self.mProfileImage.layer.cornerRadius = self.mProfileImage.frame.size.width/2
        self.mProfileImage.layer.masksToBounds = true
        refreshmenu()
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         NotificationCenter.default.addObserver(self, selector: #selector(self.refreshmenu), name: NSNotification.Name("REFRESHSIDEMENU"), object: nil)
       
    }
    @objc func refreshmenu()
    {
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
            self.mNameLabel.text =  String(format:"%@ %@",(dataDict["firstname"] as? String)!,(dataDict["lastname"] as? String)!)
            self.mmEmailLabel.text =  dataDict["email"] as? String
            self.mMobileLabel.text =  dataDict["telephone"] as? String
            var image = dataDict["image"] as? String
            if(image != nil){
                if(image == "0")
                {
                    image = "http://3.213.33.73/Ecommerce/upload/image/backend/profile.png"
                }
                else
                {
                image = image?.replacingOccurrences(of: " ", with: "%20")
                }
                self.mProfileImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "Rectangle"))
            }
        }
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    // MARK: - Button Actions
    
    @IBAction func profileEditBtnAction(_ sender: Any)
    {
        UserDefaults.standard.setValue("0", forKey: "isProfileTapped")
        Constants.kMainViewController?.hideLeftViewAnimated(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.dataDict = self.dataDict
        vc.isFromSideMenu = true
        Constants.kNavigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func myProfileBtnAction(_ sender: Any) {
        UserDefaults.standard.setValue("0", forKey: "isProfileTapped")
        Constants.kMainViewController?.hideLeftViewAnimated(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
        Constants.kNavigationController?.pushViewController(vc, animated: true)
        
        
    }
    @IBAction func cameraBtnAction(_ sender: Any)
    {
       // Constants.kMainViewController?.hideLeftViewAnimated(true)
        UserDefaults.standard.setValue("1", forKey: "isProfileTapped")
        //Constants.kMainViewController?.hideLeftViewAnimated(true)
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
            self.mProfileImage.image = pickedImage
            self.mProfileImage.contentMode = .scaleToFill
            self.mProfileImage.layer.cornerRadius = self.mProfileImage.frame.size.width/2
            self.mProfileImage.layer.masksToBounds = true
        }
        picker.dismiss(animated: true, completion: nil)
        count = 0
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
        let img = self.mProfileImage.image
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
                            NotificationCenter.default.post(name: NSNotification.Name("RefreshPic"), object: nil)
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
    
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftViewCell
        
        cell.mTitleLabel.text = String(format : "%@",titlesArray[indexPath.row]  as! String)
        if(indexPath.row == 4 || indexPath.row == 11)
        {
            cell.separatorView.isHidden = false
        }
        cell.mImageView.image = UIImage(named: imagesArray[indexPath.row] as! String)
        return cell
    }
    
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.setValue("0", forKey: "isProfileTapped")
        let mainViewController = sideMenuController!
        Constants.kMainViewController?.hideLeftViewAnimated(true)
        if(indexPath.row == 0)
        {
            Constants.appDelegate?.goToHome()
        }
        else if(indexPath.row == 1)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
            Constants.kNavigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 2)
        {
            UserDefaults.standard.setValue("Wallet", forKey: "SelectedTab")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
            Constants.kNavigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 3)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReferEarnVC") as! ReferEarnVC
            Constants.kNavigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 4)
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Rate_ReviewVC") as! Rate_ReviewVC
            Constants.kNavigationController?.pushViewController(vc, animated: true)
             
//            Constants.appDelegate?.goToHome()
//             NotificationCenter.default.post(name: NSNotification.Name("ShowRate"), object: nil)
        }
        else if(indexPath.row == 5)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            vc.screenType = "About"
            Constants.kNavigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 6)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as! FAQSVC
            Constants.kNavigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 7)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            vc.screenType = "Terms"
            Constants.kNavigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 8)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GoogleFeedbackVC") as! GoogleFeedbackVC
            Constants.kNavigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 9)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            vc.screenType = "Policy"
            Constants.kNavigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 10)
        {
            Constants.kMainViewController?.hideLeftViewAnimated(true)
            let isRememberMe =  UserDefaults.standard.string(forKey: "isRememberMe")
            if(isRememberMe == "1")
            {
                UserDefaults.standard.setValue("", forKey: "isLoggedin")
            }
            else
            {
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            Constants.kNavigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
