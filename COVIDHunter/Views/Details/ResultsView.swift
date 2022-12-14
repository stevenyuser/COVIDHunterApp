//
//  ResultsView.swift
//  COVIDHunter
//
//  Created by Steven Yu on 3/6/22.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

struct ResultsView: View {
    @State private var showExporter = false
    var results: ResultModel
    @State var document: JSONDocument? = nil
    
    var body: some View {
        ScrollView {
            Text("Results")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                TabView {
                    infections
                    hospitalizations
                    deaths
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
            .frame(height: 350)
            
            Text("Overview")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            // total cases, total infections, total infected base, total immune
            
            stats
            
            Button {
                self.document = try! JSONDocument(results: results)
                showExporter.toggle()
            } label: {
                Text("Export Results")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .fileExporter(isPresented: $showExporter, document: document, contentType: UTType.json) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(results: ResultModel(newlyInfected0: [Int](repeating: 10, count: 730), newlyInfected1: [Int](repeating: 10, count: 730), hospitalizationsNumber: [Double](repeating: 10, count: 730), deathsNumber: [Double](repeating: 10, count: 730), infections: [0, 10, 10, 10], immune: 50, period: 730, totalInfected0: 100, totalInfected1: 100, model: .Harvard))
    }
}

extension ResultsView {
    private var infections: some View {
        VStack {
            ChartView(results: results, choice: .infections)
        }
    }
    
    private var hospitalizations: some View {
        VStack {
            ChartView(results: results, choice: .hospitalizations)
        }
    }
    
    private var deaths: some View {
        VStack {
            ChartView(results: results, choice: .deaths)
        }
    }
    
    private var stats: some View {
        VStack(spacing: 10) {
            VStack() {
                Text("Simulation Model")
                    .font(.subheadline)
                Text("\(results.model.rawValue)")
                    .font(.headline)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Infections")
                        .font(.subheadline)
                    Text("\(results.totalInfected0 + results.totalInfected1)")
                        .font(.headline)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Total Deaths")
                        .font(.subheadline)
                    Text("\(Int(results.deathsNumber.reduce(0, +)))")
                        .font(.headline)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Hospitalizations")
                        .font(.subheadline)
                    Text("\(Int(results.hospitalizationsNumber.reduce(0, +)))")
                        .font(.headline)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Total Immune")
                        .font(.subheadline)
                    Text("\(Int(results.immune))")
                        .font(.headline)
                }
            }
        }
        .padding()
    }
}
