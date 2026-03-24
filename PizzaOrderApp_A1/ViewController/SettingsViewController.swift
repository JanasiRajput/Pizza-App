//
//  SettingsViewController.swift
//  PizzaOrderApp_A1
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // --- STEP 1: Add Background Image with Opacity Overlay ---
        addBackground(imageName: "Contact")
        
        // --- STEP 2: Make all labels white for visibility ---
        makeLabelsWhite()

        // Set delegates
        nameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        
        // --- STEP: UserDefaults Loading (Requirement: Automatic Recall) ---
        let defaults = UserDefaults.standard
        
        if let name = defaults.string(forKey: "lastName") {
            nameTextField.text = name
        }
        if let phone = defaults.string(forKey: "lastPhone") {
            phoneTextField.text = phone
        }
        if let email = defaults.string(forKey: "lastEmail") {
            emailTextField.text = email
        }
    }

    // Helper to add the background image and a dark overlay (Matches Order Screen)
    func addBackground(imageName: String) {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.insertSubview(backgroundImageView, at: 0)
        view.insertSubview(overlay, at: 1)
    }
    
    // Helper to ensure all labels are white and readable
    func makeLabelsWhite() {
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.textColor = .white
                label.shadowColor = .black
                label.shadowOffset = CGSize(width: 1, height: 1)
            }
        }
    }

    // MARK: - Submit Button
    @IBAction func submitTapped(_ sender: Any) {

        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty,
              let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !phone.isEmpty,
              let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            showAlert(title: "Error", message: "All fields are required!")
            return
        }

        let nameRegex = "^[A-Za-z ]+$"
        if !NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name) {
            showAlert(title: "Invalid Name", message: "Name can only contain letters and spaces.")
            return
        }

        let phoneRegex = "^[0-9]+$"
        if !NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone) {
            showAlert(title: "Invalid Phone", message: "Phone can only contain numbers.")
            return
        }

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }

        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "lastName")
        defaults.set(phone, forKey: "lastPhone")
        defaults.set(email, forKey: "lastEmail")
        defaults.synchronize()

        let message = "Settings saved successfully for \(name)!"
        showAlert(title: "Success", message: message)
    }

    // MARK: - Keyboard Handling
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            emailTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Web Navigation
    @IBAction func openWebPageTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewController {
            navigationController?.pushViewController(webVC, animated: true)
        } else {
            print("Could not find WebViewController in storyboard!")
        }
    }

    // MARK: - Alert Helper
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
