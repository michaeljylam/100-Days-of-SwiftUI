//
//  ContentView.swift
//  WeSplit
//
//  Created by Michael Lam on 2020-07-12.
//  Copyright © 2020 Michael Lam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var chequeAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    
    let tipPercentages = [0, 10, 15, 20, 25]
    
    var billTotal: Double {
        let orderAmount = Double(chequeAmount) ?? 0
        let tipSelection = Double(tipPercentages[tipPercentage])
        
        let tipValue = orderAmount * tipSelection / 100
        let totalCost = orderAmount + tipValue
        
        return totalCost
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople) ?? 1
        
        if (peopleCount != 0) {
            let amountPerPerson = billTotal / peopleCount
            return amountPerPerson
        } else {
            return billTotal
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Cost of Bill", text: $chequeAmount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Number of People", text: $numberOfPeople)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Total amount of cheque")) {
                    Text("$\(billTotal, specifier: "%.2f")")
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                .navigationBarTitle("WeSplit")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
