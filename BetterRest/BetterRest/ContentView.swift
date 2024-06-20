//
//  ContentView.swift
//  BetterRest
//
//  Created by Radek Grzywacz on 19/06/2024.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var bedtime: String {
        var message: String
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            message = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            message = "Sorry, there was a problem calculating your bedtime."
        }
        
        return message
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section(header: Text("When do you want to wake up?").font(.headline)){
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Section(header: Text("Desired amount of sleep").font(.headline)){
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 0...12, step: 0.25)
                }
                
                Section(header: Text("Daily coffee intake").font(.headline)){
                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 0...20)
//                    I Like stepper more but it's challange 2:
//                    Picker("Coffe intake", selection: $coffeeAmount) {
//                        ForEach(1...20, id: \.self) { i in
//                            Text("\(i) \(i == 1 ? "cup" : "cups")")
//                        }
//                    }
//                    .labelsHidden()
                }
                Section(header: Text("Recommended bedtime").font(.headline)){
                    Text(bedtime)
                }
            }
            .navigationTitle("BetterRest")

        }
    }
}

#Preview {
    ContentView()
}
