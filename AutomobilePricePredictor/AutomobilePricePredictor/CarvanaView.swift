//
//  CarvanaView.swift
//  AutomobilePricePredictor
//
//  Created by Jason Sanchez on 7/17/24.
//

import SwiftUI
import CreateML

struct CarvanaView: View {
    
    @State private var selectedYear: Int = 2021
    @State private var selectedName: String = ""
    @State private var miles: Double?
    @State private var price: Double?
    
    //let model = try! Carvana(configuration: MLModelConfiguration())
    
    let calendar = Calendar.current
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CarvanaView()
}
