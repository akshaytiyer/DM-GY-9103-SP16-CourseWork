//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Akshay Iyer on 2/16/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController
{
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            /* Load a web page into our web view */
            let url = NSURL(string: "https://www.bignerdranch.com")
            let urlRequest = NSURLRequest(URL: url!)
            webView.loadRequest(urlRequest)
        }
}
