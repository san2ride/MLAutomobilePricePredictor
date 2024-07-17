//
//  CarvanaView.swift
//  AutomobilePricePredictor
//
//  Created by Jason Sanchez on 7/17/24.
//

import SwiftUI
import CoreML

struct Car: Decodable, Identifiable {
    let id = UUID()
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
}

struct CarvanaView: View {
    
    @State private var selectedYear: Int = 2021
    @State private var selectedName: String = ""
    @State private var miles: Int64?
    @State private var price: Double?
    
    let model = try! Carvana(configuration: MLModelConfiguration())
    
    let calendar = Calendar.current
    
    private var last5Years: ClosedRange<Int> {
        let currentYear = calendar.component(.year, from: Date())
        return (currentYear - 5)...currentYear
    }
    
    private var cars: [Car] {
        guard let fileURL = Bundle.main.url(forResource: "CarNames", withExtension: "json") else {
            fatalError("failed to load json file bundle")
        }
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let cars = try JSONDecoder().decode([Car].self, from: jsonData)
            return cars
        } catch {
            return []
        }
    }
    
    private var isFormValid: Bool {
        miles != nil && miles! > 0
    }
    
    var body: some View {
        Form {
            
            Picker("Select Name", selection: $selectedName) {
                ForEach(cars) { car in
                    Text(car.name).tag(car.name)
                }
            }
            
            Picker("Select Year", selection: $selectedYear) {
                ForEach(last5Years.reversed(), id: \.self) { year in
                    Text(year.description).tag(year)
                }
                
            }.pickerStyle(.segmented)
            .onAppear {
                selectedYear = calendar.component(.year, from: Date())
            }
            
            TextField("Miles", value: $miles, format: .number)
            
            Button {
                // action
                do {
                    let results = try model.prediction(Name: selectedName, Year: Int64(selectedYear), Miles: miles!)
                    price = results.Price
                } catch {
                    print(error.localizedDescription)
                }
                
            } label: {
                Text("Predict Car Price")
                    .frame(maxWidth: .infinity, alignment: .center)
            }.buttonStyle(.borderedProminent)
            .disabled(!isFormValid)

            if let price {
                if price > 0 {
                    Text(price, format: .currency(code: Locale.currencyCode))
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.green)
                } else {
                    Text("")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.green)
                }
            }
            
            
        }.navigationTitle("Carvana")
    }
}

#Preview {
    NavigationStack {
        CarvanaView()
    }
}

extension Locale {
    static var currencyCode: String {
        current.currency?.identifier ?? "USD"
    }
}
