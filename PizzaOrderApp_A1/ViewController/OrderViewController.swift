//
//  OrderViewController.swift
//  PizzaOrderApp_A1
//
//  Created by Janasi Rajput on 2026-02-08.
//

import UIKit

class OrderViewController: UIViewController {

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
    
    
        
    @IBAction func submitOrderTapped(_ sender: Any) {
        
        // Read delivery date
        let date = deliveryDatePicker.date

        // Read address
        let address = addressTextField.text ?? "No address provided"

        //  Read pizza size
        let sizeIndex = sizeSegmentedControl.selectedSegmentIndex
        let pizzaSize: String
        switch sizeIndex {
        case 0: pizzaSize = "Small"
        case 1: pizzaSize = "Medium"
        case 2: pizzaSize = "Large"
        default: pizzaSize = "Unknown"
        }

        // Read meat toppings
        let meatToppings: [String] = [
            pepperoniSwitch.isOn ? "Pepperoni" : "",
            sausageSwitch.isOn ? "Sausage" : "",
            baconSwitch.isOn ? "Bacon" : ""
        ].filter { !$0.isEmpty } // Only keep selected toppings

        // Read vegetable toppings
        let vegToppings: [String] = [
            onionSwitch.isOn ? "Onion" : "",
            oliveSwitch.isOn ? "Olive" : "",
            pepperSwitch.isOn ? "Pepper" : ""
        ].filter { !$0.isEmpty }

        // Show confirmation alert
        let orderSummary = """
        Address: \(address)
        Date: \(date)
        Size: \(pizzaSize)
        Meat: \(meatToppings.joined(separator: ", "))
        Veg: \(vegToppings.joined(separator: ", "))
        """

        let alert = UIAlertController(title: "Order Submitted", message: orderSummary, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)


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
