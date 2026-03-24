//
//  OrderData.swift
//  PizzaOrderApp_A1
//
//  Created by Janasi Rajput on 2026-03-20.
//
import UIKit

class OrderData: NSObject {
    var id: Int?
    var deliveryDate: String?
    var address: String?
    var size: Int? // Required as Int
    var meatToppings: String?
    var vegToppings: String?
    var avatar: String?
    
    func initWithData(theRow i: Int, theDate d: String, theAddress a: String, theSize s: Int, theMeat m: String, theVeg v: String, theAvatar av: String) {
        id = i
        deliveryDate = d
        address = a
        size = s
        meatToppings = m
        vegToppings = v
        avatar = av
    }
}
