//
//  OrderViewController.swift
//  PizzaOrderApp_A1
//
//  Created by Janasi Rajput on 2026-02-08.
//

import UIKit

// Added delegates for the Image Picker functionality
class OrderViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var deliveryDatePicker: UIDatePicker!

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!

    @IBOutlet weak var pizzaSizeLabel: UILabel!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!

    @IBOutlet weak var meatToppingsLabel: UILabel!
    @IBOutlet weak var pepperoniLabel: UILabel!
    @IBOutlet weak var pepperoniSwitch: UISwitch!
    @IBOutlet weak var sausageLabel: UILabel!
    @IBOutlet weak var sausageSwitch: UISwitch!
    @IBOutlet weak var baconLabel: UILabel!
    @IBOutlet weak var baconSwitch: UISwitch!

    @IBOutlet weak var vegToppingsLabel: UILabel!
    @IBOutlet weak var onionLabel: UILabel!
    @IBOutlet weak var onionSwitch: UISwitch!
    @IBOutlet weak var oliveLabel: UILabel!
    @IBOutlet weak var oliveSwitch: UISwitch!
    @IBOutlet weak var pepperLabel: UILabel!
    @IBOutlet weak var pepperSwitch: UISwitch!
    
    @IBOutlet weak var avatarImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.delegate = self
        
        // --- STEP 1: Add Background Image with Opacity Overlay ---
        addBackground(imageName: "Make_Pizza")
        
        // --- STEP 2: Style UI elements and FIX overlapping ---
        makeLabelsWhite()

        // Load Avatar if it was previously set in UserDefaults
        if let imageData = UserDefaults.standard.data(forKey: "savedAvatar") {
            avatarImageView.image = UIImage(data: imageData)
        }
    }
    
    // Helper to add the background image and a dark overlay
    func addBackground(imageName: String) {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add a dark overlay so white text stands out
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6) // Increased slightly for better visibility
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Insert at the very bottom so they don't cover text fields/switches
        view.insertSubview(backgroundImageView, at: 0)
        view.insertSubview(overlay, at: 1)
    }
    
    // Helper to find all labels on screen and change them to white
    func makeLabelsWhite() {
        // Safe loop to bring all content to the top and style labels
        for subview in view.subviews {
            // Push the background and overlay to the back, bring everything else to front
            view.bringSubviewToFront(subview)
            
            if let label = subview as? UILabel {
                label.textColor = .white
                label.shadowColor = .black
                label.shadowOffset = CGSize(width: 1, height: 1)
                
                // --- FIX FOR OVERLAPPING ---
                // Ensures labels wrap text rather than squeezing into each other
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
            }
            
            // Style Segmented Control so it doesn't get "lost" in the image
            if let segment = subview as? UISegmentedControl {
                segment.selectedSegmentTintColor = .white
                segment.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
                segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            }
        }
        
        // Fix for the Date Picker text visibility (System safe way)
        deliveryDatePicker.overrideUserInterfaceStyle = .dark
    }
    
    // MARK: - Avatar Actions
    
    @IBAction func changeAvatarTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            self.avatarImageView.image = selectedImage
            
            if let imageData = selectedImage.jpegData(compressionQuality: 0.5) {
                UserDefaults.standard.set(imageData, forKey: "savedAvatar")
            }
        }
        picker.dismiss(animated: true)
    }

    // MARK: - Submit Order
    @IBAction func submitOrderTapped(_ sender: Any) {

        let date = deliveryDatePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let dateString = dateFormatter.string(from: date)

        let address = addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let finalAddress = address.isEmpty ? "No address provided" : address

        let pizzaSizeInt = sizeSegmentedControl.selectedSegmentIndex

        let meatToppings = [
            pepperoniSwitch.isOn ? "Pepperoni" : "",
            sausageSwitch.isOn ? "Sausage" : "",
            baconSwitch.isOn ? "Bacon" : ""
        ].filter { !$0.isEmpty }.joined(separator: ", ")

        let vegToppings = [
            onionSwitch.isOn ? "Onion" : "",
            oliveSwitch.isOn ? "Olive" : "",
            pepperSwitch.isOn ? "Pepper" : ""
        ].filter { !$0.isEmpty }.joined(separator: ", ")
        
        let uniqueImageName = "avatar_\(Date().timeIntervalSince1970).png"
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate

        if let imageToSave = avatarImageView.image {
            mainDelegate.saveImageToDisk(image: imageToSave, fileName: uniqueImageName)
        }
        
        let newOrder = OrderData()
        newOrder.initWithData(
            theRow: 0,
            theDate: dateString,
            theAddress: finalAddress,
            theSize: pizzaSizeInt,
            theMeat: meatToppings.isEmpty ? "None" : meatToppings,
            theVeg: vegToppings.isEmpty ? "None" : vegToppings,
            theAvatar: uniqueImageName
        )

        let returnCode = mainDelegate.insertIntoDatabase(order: newOrder)

        var returnMsg = "Order successfully saved to database!"
        if returnCode == false {
            returnMsg = "Failed to save order to SQLite."
        }

        let alert = UIAlertController(title: "Order Status", message: returnMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Keyboard Handling

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
