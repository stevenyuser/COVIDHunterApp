//
//  ResultsView.swift
//  COVIDHunter
//
//  Created by Steven Yu on 3/6/22.
//

import SwiftUI

struct ResultsView: View {
    var results: ResultModel
    
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
            .frame(height:450)
            
            Text("Overview")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            // total cases, total infections, total infected base, total immune
            
            
        }
        .padding()
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(results: ResultModel(newlyInfected0: [Int](repeating: 10, count: 100), newlyInfected1: [Int](repeating: 10, count: 100), hospitalizationsNumber: [Double](repeating: 10, count: 100), deathsNumber: [Double](repeating: 10, count: 100), totalInfections: 0))
    }
}

extension ResultsView {
    private var infections: some View {
        VStack {
            Text("Infections")
                .font(.title2)
                .bold()
            ChartView(results: results, choice: .infections)
        }
        
    }
    
    private var hospitalizations: some View {
        VStack {
            Text("Hospitalizations")
                .font(.title2)
                .bold()
            ChartView(results: results, choice: .hospitalizations)
        }
    }
    
    private var deaths: some View {
        VStack {
            Text("Deaths")
                .font(.title2)
                .bold()
            ChartView(results: results, choice: .deaths)
        }
    }
}
