//
//  ContentView.swift
//  P4-BetterRest
//
//  Created by Michael Lam on 2022-06-09.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    init() {
        let navigationTitleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont(
                descriptor:
                    navigationTitleFont.fontDescriptor
                    .withDesign(.rounded)?
                    .withSymbolicTraits(.traitBold)
                ??
                navigationTitleFont.fontDescriptor,
                size: navigationTitleFont.pointSize
            )
        ]
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Wake up time")
                        .font(.headline)
                    Spacer()
                    DatePicker("Wake up time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Picker(selection: $coffeeAmount) {
                    ForEach(1..<20) {
                        if $0 == 1 {
                            Text("1 cup")
                        } else {
                            Text("\($0) cups")
                        }
                    }
                } label: {
                    Text("Daily coffee intake")
                        .font(.headline)
                }
                
                Section() {
                    VStack(alignment: .center) {
                        Text("Your ideal bedtime is")
                            .font(.system(.title3, design: .rounded))
                        Text(calculateBedtime())
                            .font(.system(.largeTitle, design: .rounded))
                        Spacer()
                        Spacer()
                        Text("Sleep well!")
                            .font(.system(.title3, design: .rounded))
                    }
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color(UIColor.systemGroupedBackground))
            }
            .navigationTitle("BetterRest")
        }
    }
    
    func calculateBedtime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hourInSeconds = (components.hour ?? 0) * 60 * 60
            let minuteInSeconds = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hourInSeconds + minuteInSeconds), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            print(error)
            return "Unknown"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
