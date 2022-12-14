//
//  ContentView.swift
//  C1-LengthConverter
//
//  Created by Michael Lam on 2022-06-12.
//

import SwiftUI

struct ContentView: View {
    private let units = [("metres", UnitLength.meters), ("kilometres", UnitLength.kilometers), ("feet", UnitLength.feet), ("yards", UnitLength.yards), ("miles", UnitLength.miles)]
    private var formatter = MeasurementFormatter()

    @State private var inputValue: Double = 1
    @State private var inputUnitIndex = 1
    @State private var outputUnitIndex = 0
    
    var originalLength: String {
        formatter.string(from: Measurement(value: inputValue, unit: units[inputUnitIndex].1))
    }
    
    var convertedLength: String {
        formatter.string(from: Measurement(value: inputValue, unit: units[inputUnitIndex].1)
            .converted(to: units[outputUnitIndex].1))
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
        
        formatter.unitOptions = [.providedUnit]
        formatter.unitStyle = .long
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter a length to convert", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Picker("Convert from...", selection: $inputUnitIndex) {
                        ForEach(0 ..< units.count, id: \.self) {
                            Text(units[$0].0)
                        }
                    }
                    
                    Picker("Convert to...", selection: $outputUnitIndex) {
                        ForEach(0 ..< units.count, id: \.self) {
                            Text(units[$0].0)
                        }
                    }
                }
                
                Section {
                    VStack(alignment: .center) {
                        Image(systemName: "ruler.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 40)
                            .padding(.trailing, 10)
                        Text("\(originalLength) is equal to")
                            .font(.headline)
                        Text(convertedLength)
                            .font(.system(.largeTitle, design: .rounded))
                            .bold()
                    }
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Length Converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
