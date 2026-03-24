//
//  WebViewController.swift
//  PizzaOrderApp_A1
//
//  Created by Janasi Rajput on 2026-02-08.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        activityIndicator.hidesWhenStopped = true

        if let url = URL(string: "https://www.apple.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    // START loading → show spinner
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    // FINISH loading → hide spinner
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    // FAIL loading → hide spinner
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }

    // ALSO handle initial load failure
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
