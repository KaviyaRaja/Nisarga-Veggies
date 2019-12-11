//
//  FAQSVC.swift
//  Nisagra
//
//  Created by Apple on 27/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class FAQSVC: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var mWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SKActivityIndicator.show("Loading...")
        mWebView.delegate = self
        let url = URL (string: "http://3.213.33.73/Ecommerce/upload/index.php?route=api/faq/faq")
        let requestObj = URLRequest(url: url!)
        mWebView.loadRequest(requestObj)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Btn Action
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SKActivityIndicator.dismiss()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SKActivityIndicator.dismiss()
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

