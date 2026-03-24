//
//  WebViewController.swift
//  PizzaOrderApp_A1
//
//  Created by Janasi Rajput on 2026-02-08.
//


import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var webView:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add activity indicator
                let activityIndicator = UIActivityIndicatorView(style: .large)
                activityIndicator.center = self.view.center
                activityIndicator.startAnimating()
                view.addSubview(activityIndicator)

                // Navigation delegate
               

                // Load website
                if let url = URL(string: "https://www.apple.com") {
                    webView.load(URLRequest(url: url))
                }
            }

            // Stop spinner when page finishes loading
            func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                for subview in view.subviews {
                    if let indicator = subview as? UIActivityIndicatorView {
                        indicator.stopAnimating()
                        indicator.removeFromSuperview()
                    }
                }
            }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


