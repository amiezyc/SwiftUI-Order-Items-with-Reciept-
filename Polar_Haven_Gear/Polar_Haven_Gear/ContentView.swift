//
//  ContentView.swift
//  Polar_Haven_Gear
//
//  Created by 周雨橙 on 4/7/23.
//

import SwiftUI

struct KitItem{
    var name: String
    var image: String
    var price: Double
    
    func decrebeKitItem() -> String{
        return "\(name):(price.formatted())"
    }
}
//First Struct KitItem

struct KitItemOrder {
    var kitItem : KitItem
    var unit : Int
    
    func getItemCost() -> Double{
        return kitItem.price*Double(unit)
    }
    
    func formatItemCost() -> String {
        let itemCost = getItemCost()
        return "$" + String(itemCost.formatted())
    }
    
    func describeKitItemOrder() -> String{
        return "\(kitItem.name)x\(unit):\(formatItemCost())"
    }
}


struct KitOrder{
    var kitItemOrders: [KitItemOrder]
    
    mutating func appendKitItemOrder(kitItemOrder: KitItemOrder){
        var unitIsUpdated = false
        //go through each order item to see if it is the same as the current order
        for index in 0 ..< kitItemOrders.count{
            if kitItemOrders[index].kitItem.name == kitItemOrder.kitItem.name{
                kitItemOrders[index].unit += kitItemOrder.unit
                unitIsUpdated = true
            }//end of if statement
        }//end of my for loop
        
        //only append if there is no repeats
        if !unitIsUpdated{
            kitItemOrders.append(kitItemOrder)
            
        }
    }
    
    func getTotalCost() -> Double {
        var totalCost = 0.0
        for each in kitItemOrders {
            totalCost = totalCost + each.getItemCost()
        }
        return totalCost
    }
    
    //Total Cosst Receipt
    func getKitOrderReceipt() -> String {
        
        var receipt = ""
        
        for each in kitItemOrders{
            receipt = receipt + "\n\(each.describeKitItemOrder())"
        }
        
        receipt = receipt + "\n\nTotal Amount:$\(getTotalCost().formatted())"
        return receipt
        
    }
    
    
}

struct ContentView: View {
    @State private var gearIndex = 0
    @State private var unitStr = "1"
    @State private var order = KitOrder(kitItemOrders: [])
    private let gears = [
        KitItem(name: "Beginner Thick Turtle Cusion Set(PAINLESS Knee+Butt Pads)", image: "beginnerSet", price: 34.99),
              KitItem(name: "Wrist Guard(Beginner-Intermediate)", image: "wristGuard", price: 9.99),
              KitItem(name: "Knee Protector Non Slipe(Beginner-Intermediate)", image: "kneeProtector", price: 14.99),
              KitItem(name: "Extra thick Slicon Knee Pads(Knee Protector Add On)", image: "kneePad", price: 4.99),
              KitItem(name: "Knee Protector Expert", image: "proKneeProtector", price: 59.99),
              KitItem(name: "Sillicon Butt Protector(Intermediate-Expert)", image: "buttProtector", price: 49.99),
              KitItem(name: "High Impact Lowerback, Tialbone Protector(Expert)", image: "proButtProtector", price: 89.99),
              KitItem(name: "High Impact Expert Set(LIGHT Armor+Butt Pads)", image: "proSet", price: 149.99)

    ]
    //information about each individual kit item, name, image and price

    
    
    var body: some View {
        
        VStack{
            Image(gears[gearIndex].image)
                .resizable()
                .frame(width: 300, height: 300, alignment: .center)
                .scaledToFill()
                .padding(20)
            
            Text("\(gears[gearIndex].name): $\(gears[gearIndex].price.formatted())")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .italic()
                .padding(.horizontal, 30.0)
                .multilineTextAlignment(.center)

            
            HStack{
                    Text("Quantity: ")
                        .bold()
                        .padding(.leading, 110.0)
                    Stepper(value: Binding<Int>(
                        get: {
                            Int(unitStr) ?? 1
                        },
                        set: {
                            unitStr = "\($0)"
                        }
                    ), in: 1...10) {
                        Text("\(unitStr)")
                            .bold()
                            .padding(.leading, 80)
                    }
                }

            
            HStack{
                Button("Show Next Gear") {
                   
                    if gearIndex < gears.count-1 {
                        gearIndex += 1
                    }
                    else {
                        gearIndex = 0
                    }
                    
                    unitStr = "1"
                }
                .font(.caption)
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button("Order This Kit") {
                    //turn unitStr to unit
                    let unit = Int(unitStr)!
                    //create an food Item Order
                    let kitItem = gears[gearIndex]
                    let kitItemOrders = KitItemOrder(kitItem: kitItem, unit: unit)
                    order.appendKitItemOrder(kitItemOrder: kitItemOrders)
                }
                .font(.caption)
                .buttonStyle(.borderedProminent)
                .padding()
            }
            
            Text(order.getKitOrderReceipt())
            
            
        }
        
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
