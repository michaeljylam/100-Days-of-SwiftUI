//
//  ContentView.swift
//  Project 4: BetterRest
//
//  Created by Michael Lam on 2021-01-24.
//

import SwiftUI
import CoreML

struct ContentView: View {
    var cupsOfCoffee = ["0", "1", "2", "3", "4", "5"]

    @State private var wakeTime = defaultWakeTime
    @State private var sleepDuration = 8.0
    @State private var selectedCups = 1
    
    init() {
        UITableView.appearance().contentInset.top = -20
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Wake up time:")
                        .font(.headline)
                    Spacer()
                    DatePicker("Please enter a time", selection: $wakeTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired sleep duration:")
                        .font(.headline)
                    Stepper(value: $sleepDuration, in: 4...12, step: 0.25) {
                        Text("\(sleepDuration, specifier: "%g") hours")
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Cups of coffee:")
                        .font(.headline)
                    Picker("Cups of coffee", selection: $selectedCups) {
                        ForEach(0 ..< cupsOfCoffee.count) {
                            Text(self.cupsOfCoffee[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section() {
                    VStack {
                        Text("Your ideal bedtime is \(calculateBedtime()).")
                            .font(.title2)
                        Spacer()
                        Text("Sleep well!")
                            .font(.title3)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .listRowBackground(Color(.systemGroupedBackground))
            }
            .navigationTitle("BetterRest")
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
        
    func calculateBedtime() -> String {
        let bedtime = wakeTime - (sleepDuration * 60 * 60)
        let formatter = DateFormatter()
        formatter.timeStyle = .short

        if (Int(cupsOfCoffee[selectedCups]) ?? 0 >= 1) {
            do {
                let model = try SleepCalculator(configuration: MLModelConfiguration())
                let components = Calendar.current.dateComponents([.hour, .minute], from: wakeTime)
                let hour = (components.hour ?? 0) * 60 * 60
                let minute = (components.minute ?? 0) * 60
                let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepDuration, coffee: Double(cupsOfCoffee[selectedCups]) ?? 0)
                let bedtime = wakeTime - prediction.actualSleep
                
                return formatter.string(from: bedtime)
            } catch {
                print("Error calculating bedtime: \(error).")
            }
        }
        
        return formatter.string(from: bedtime)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
