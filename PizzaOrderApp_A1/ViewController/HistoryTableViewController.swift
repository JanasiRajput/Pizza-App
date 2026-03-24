//
//  HistoryTableViewController.swift
//  PizzaOrderApp_A1
//
//  Created by Janasi Rajput on 2026-03-20.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Order History"
        
        // --- STEP 1: Add Background Image with Opacity Overlay ---
        if let bgImage = UIImage(named: "pizza_bg_1") {
            let imageView = UIImageView(image: bgImage)
            imageView.contentMode = .scaleAspectFill
            
            let overlay = UIView(frame: imageView.bounds)
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            
            imageView.addSubview(overlay)
            self.tableView.backgroundView = imageView
        }

        // Standardize row height for better spacing
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150 // Increased estimate
        
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainDelegate.readDataFromDatabase()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")
        let row = mainDelegate.orders[indexPath.row]

        let sizeMap = ["Small", "Medium", "Large"]
        let sizeStr = sizeMap[row.size ?? 1]

        // --- STEP 3: Configure Main Title with Top Padding ---
        // Adding \n at the start pushes the content down from the previous order
        cell.textLabel?.text = "\n🍕 \(sizeStr) Pizza"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.textColor = .white
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.shadowColor = .black
        cell.textLabel?.shadowOffset = CGSize(width: 1, height: 1)

        // --- STEP 4: Configure Detail Text with Bottom Padding ---
        let date = row.deliveryDate ?? "No Date"
        let address = row.address ?? "No Address"
        let meat = row.meatToppings ?? "None"
        let veg = row.vegToppings ?? "None"
        
        // Adding \n\n at the end pushes the NEXT order further down
        cell.detailTextLabel?.text = "Date: \(date)\nAddress: \(address)\nMeat: \(meat)\nVeg: \(veg)\n\n"
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.textColor = .white
        
        cell.detailTextLabel?.shadowColor = .black
        cell.detailTextLabel?.shadowOffset = CGSize(width: 1, height: 1)

        // --- STEP 5: Load Avatar and Standardize Size ---
        var avatarImage: UIImage?
        
        if let fileName = row.avatar, !fileName.isEmpty, fileName != "Default.png" {
            let fileManager = FileManager.default
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imagePath = documentsPath.appendingPathComponent(fileName).path
            
            if fileManager.fileExists(atPath: imagePath) {
                avatarImage = UIImage(contentsOfFile: imagePath)
            } else {
                avatarImage = UIImage(systemName: "person.circle")
            }
        } else {
            avatarImage = UIImage(systemName: "person.circle")
        }

        // Force the image to be 60x60 so it doesn't shift or overlap the text
        let itemSize = CGSize.init(width: 60, height: 60)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        avatarImage?.draw(in: imageRect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        cell.imageView?.tintColor = .white
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.layer.cornerRadius = 30 // Perfectly round for 60x60
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
}
