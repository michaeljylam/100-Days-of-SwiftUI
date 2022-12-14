//
//  ContentView.swift
//  P1-WeSplit
//
//  Created by Michael Lam on 2022-06-08.
//

import SwiftUI

struct ContentView: View {
    @State private var chequeAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
        
    var totalAmount: Double {
        let tipValue = chequeAmount / 100 * Double(tipPercentage)
        return chequeAmount + tipValue
    }
    
    var totalPerPerson: Double {
        totalAmount / Double(numberOfPeople + 2)
    }
    
    var currency: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currencyCode ?? "CAD")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $chequeAmount, format: currency)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<101) {
                            Text("\($0)%")
                        }
                    }
                }
                
                Section {
                    Text(totalAmount, format: currency)
                        .foregroundColor(tipPercentage == 0 ? Color.red : Color.primary)
                } header: {
                    Text("Total amount")
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "CAD"))
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
