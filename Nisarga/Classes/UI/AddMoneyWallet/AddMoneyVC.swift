//
//  AddMoneyVC.swift
//  Nisagra
//
//  Created by Apple on 25/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class AddMoneyVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mPriceLabel: CustomFontLabel!
    @IBOutlet weak var mAmountCollectionView: UICollectionView!
    @IBOutlet weak var mAmountTF: CustomFontTextField!
    var mMoneyArray : NSArray = []
    var status : String = ""
    var Description : String = ""
    var transactionId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transactionId = SingletonClass.sharedInstance.randomString(withLength: 10)!
        self.mMoneyArray = ["₹100","₹200","₹500","₹1000"]
        self.mAmountCollectionView.register(UINib(nibName: "MoneyCell", bundle: nil), forCellWithReuseIdentifier: "MoneyCell")
        getWalletBalance()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Btn Actions
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func faqBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as! FAQSVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func proceedBtnAction(_ sender: Any)
    {
        if(self.mAmountTF.text == "₹")
        {
            self.view.makeToast("Please Choose or Enter Amount")
            return
        }
        
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentGateway") as! PaymentGateway
//        self.navigationController?.pushViewController(vc, animated: true)

        
        var amount = self.mAmountTF.text!
        amount.remove(at: amount.startIndex).unicodeScalars
        PayUServiceHelper.sharedManager()?.getPayment(self, "Kaviyashetty18@gmail.com", "8682867295", "Kaviya", amount, self.transactionId, didComplete: { (dict, error) in
            if let error = error {
                print("Error")
                self.status = "failure"
                self.Description = "Transaction Failure"
                self.addMoneyToWalletAPI()
            }else {
                print("Sucess")
                self.status = "success"
                self.Description = "Money Added to Wallet"
                self.addMoneyToWalletAPI()
                
            
            }
        }, didFail: { (error) in
            print("Payment Process Breaked")
            self.status = "failure"
            self.Description = "Transaction Failure"
            self.addMoneyToWalletAPI()
            
        })
    
    }
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.mMoneyArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: MoneyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoneyCell", for: indexPath) as! MoneyCell
        cell.mBgView.layer.cornerRadius = 5
        cell.mBgView.layer.borderWidth = 1
        cell.mBgView.layer.borderColor = UIColor(red:0.98, green:0.82, blue:0.29, alpha:1.0).cgColor
        cell.mPriceLabel.text = self.mMoneyArray[indexPath.row] as? String
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.mAmountTF.text = self.mMoneyArray[indexPath.row] as? String
    }
    
    // MARK:- API
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
                            self.mPriceLabel.text = ""
                        }
                        else
                        {
                            self.mPriceLabel.text = String(format:"₹%@",balance!)
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
    func addMoneyToWalletAPI()
    {
        var amount = self.mAmountTF.text!
        amount.remove(at: amount.startIndex).unicodeScalars
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/customer/walletadd",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "amount" : amount ,
                "transaction_id" : self.transactionId,
                "status1" : self.status,
                "description" : self.Description
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
                            if(self.status == "success")
                            {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "PaymentSummaryVC") as! PaymentSummaryVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else
                            {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "PaymentSummaryFailedVC") as! PaymentSummaryFailedVC
                                self.navigationController?.pushViewController(vc, animated: true)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
