//
//  TermsOfServiceViewController.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/8/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

class DRCTermsOfServiceViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var termsOfServiceWebView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        termsOfServiceWebView.delegate = self
        if let url = NSURL(string: "https://www.drchrono.com/terms/") {
            let request = NSURLRequest(URL: url)
            termsOfServiceWebView.loadRequest(request)
        }

    }

    @IBAction func doneButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    func webViewDidStartLoad(webView: UIWebView) {
        spinner.startAnimating()
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        spinner.stopAnimating()
    }
}
