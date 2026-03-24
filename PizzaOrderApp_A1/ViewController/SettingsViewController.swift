//
//  SettingsViewController.swift
//  PizzaOrderApp_A1
//
//  Created by Janasi Rajput on 2026-02-08.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func submitTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
                      let phone = phoneTextField.text, !phone.isEmpty,
                      let email = emailTextField.text, !email.isEmpty else {
                    showAlert(title: "Error", message: "All fields are required!")
                    return
                }
                
                // Validate name (letters and spaces only)
                let nameRegex = "^[A-Za-z ]+$"
                if !NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name) {
                    showAlert(title: "Invalid Name", message: "Name can only contain letters and spaces.")
                    return
                }
                
                // Validate phone (numbers only)
                let phoneRegex = "^[0-9]+$"
                if !NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone) {
                    showAlert(title: "Invalid Phone", message: "Phone can only contain numbers.")
                    return
                }
                
                // Validate email
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
                    showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
                    return
                }
                
                // All valid → show confirmation
                let message = """
                Name: \(name)
                Phone: \(phone)
                Email: \(email)
                """
                showAlert(title: "User Info Submitted", message: message)
            }
            
            // Helper function to show alerts
            func showAlert(title: String, message: String) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
    }
    
    @IBAction func openWebPageTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewController {
                self.navigationController?.pushViewController(webVC, animated: true)
            } else {
                print("Could not find WebViewController in storyboard!")
            }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
