//
//  PayUVC.swift
//  Nisarga
//
//  Created by Hari Krish on 17/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Alamofire
import SDWebImage
import Toast_Swift

class PayUVC: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var mWebView: UIWebView!
    let TestEnvironment = 1
    var merchantKey = ""
    var salt = ""
    var PayUBaseUrl = ""
    var hashKey: String! = nil
    var totalPriceAmount = String()
    let productInfo = "Nisarga Veggies"
    let firstName = "Kaviya"
    let email = "Kaviyashetty18@gmail.com"
    let phone = "8682867295"
    let successUrl = "https://www.payumoney.com/mobileapp/payumoney/successs.php"   //Success URL
    let failureUrl = "https://www.payumoney.com/mobileapp/payumoney/failuree.php"   //Failure URL
    let service_provider = "payu_paisa"
    var txnid1: String! = ""    //a unique id for specific order number.
    var type : String!
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(TestEnvironment == 1)
        {
//            self.merchantKey = "6TsK9kaI"
//            self.salt = "Twb7XPbHtZ"
//            self.merchantKey = "kYz2vV"
//            self.salt = "zhoXe53j"
            self.PayUBaseUrl = "https://test.payu.in"
            
            self.merchantKey = "kYz2vV"
            self.salt = "zhoXe53j"

            

            
        }
        else
        {
            self.merchantKey = "kYz2vV"
            self.salt = "zhoXe53j"
            self.PayUBaseUrl = "https://test.payu.in"
        }
        SKActivityIndicator.show("Loading...")
        initPayment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Mark: - Btn Action
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Mark: Pay U
    func initPayment() {
        //Creating taxation id with timestamp
        txnid1 = "Nisarga\(String(Int(NSDate().timeIntervalSince1970)))"
        
        //Generating Hash Key
        let hashValue = String.localizedStringWithFormat("%@|%@|%@|%@|%@|%@|||||||||||%@",merchantKey,txnid1,totalPriceAmount,productInfo,firstName,email,salt)
        let hash=self.sha1(string: hashValue)
        
        let postStr = String(format:"%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@+%@","txnid=",txnid1,"&key=",merchantKey,"&amount=",totalPriceAmount,"&productinfo=",productInfo,"&firstname=",firstName,"&email=",email,"&phone=",phone,"&surl=",successUrl,"&furl=",failureUrl,"&hash=",hash,"&service_provider=",service_provider)
        
        let url = NSURL(string: String.localizedStringWithFormat("%@/_payment", PayUBaseUrl))
        let request = NSMutableURLRequest(url: url! as URL)
        
        do {
            let postLength = String.localizedStringWithFormat("%lu",postStr.characters.count)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Current-Type")
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.httpBody = postStr.data(using: String.Encoding.utf8)
            self.mWebView.loadRequest(request as URLRequest)
        } catch let error as NSError {
            print("Error:", error)
        }
    }
    
    func sha1(string:String) -> String {
        let cstr = string.cString(using: String.Encoding.utf8)
        let data = NSData(bytes: cstr, length: string.characters.count)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA512_DIGEST_LENGTH))
        CC_SHA512(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02x", $0) }
        return hexBytes.joined(separator: "")
    }
    // Mark: - Webview
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SKActivityIndicator.dismiss()
        let requestURL = self.mWebView.request?.url
        let requestString:String = (requestURL?.absoluteString)!
         print(requestString)
        if requestString.contains("https://www.payumoney.com/mobileapp/payumoney/success.php") {
            print("success payment done")
            if(self.type == "AddMoney")
            {
                self.addMoneyToWalletAPI()
            }
        }else if requestString.contains("https://www.payumoney.com/mobileapp/payumoney/failure.php") {
            print("payment failure")
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SKActivityIndicator.dismiss()
        let requestURL = self.mWebView.request?.url
        print("WebView failed loading with requestURL: \(requestURL) with error: \(error.localizedDescription) & error code: \(error)")
        
        if error._code == -1009 || error._code == -1003 {
            showAlertView(string: "Please check your internet connection!")
        }else if error._code == -1001 {
            showAlertView(string: "The request timed out.")
        }
    }
    
    func showAlertView(string: String) {
        let alertController = UIAlertController(title: "Alert", message: string, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){
            (result : UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK:- API
    func addMoneyToWalletAPI()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/customer/walletadd",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "amount" : totalPriceAmount ,
            "transaction_id" : ""
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
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "PayNowSuccessVC") as! PayNowSuccessVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else
                        {
                             self.view.makeToast(JSON["message"] as? String)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "PaynowFailureVC") as! PaynowFailureVC
                            self.navigationController?.pushViewController(vc, animated: true)
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
