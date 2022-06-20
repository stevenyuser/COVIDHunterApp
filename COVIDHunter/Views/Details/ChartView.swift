//
//  ChartView.swift
//  COVIDHunter
//
//  Created by Steven Yu on 4/10/22.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    private let data: [Double]
    private let title: String
    private let legend: String?
    private let style: ChartStyle
    private let start = 1
    private let end: Int
    
    // add infections 0 and 1 later
    init(results: ResultModel, choice: GraphEnum) {
        switch choice {
        case .infections:
//            data = (results.newlyInfected0 + results.newlyInfected1).map{
//                Double($0)
//            }
            data = results.infections.map {
                Double($0)
            }
            title = "Infections"
            legend = nil
            style = ChartStyle(
                backgroundColor: Color.white,
                accentColor: Color.green,
                secondGradientColor: Color.green,
                textColor: Color.black,
                legendTextColor: Color.gray,
                dropShadowColor: Color.gray)
        case .hospitalizations:
            data = results.hospitalizationsNumber.map{
                Double($0)
            }
            title = "Hospitalizations"
            legend = nil
            style = ChartStyle(
                backgroundColor: Color.white,
                accentColor: Color.yellow,
                secondGradientColor: Color.yellow,
                textColor: Color.black,
                legendTextColor: Color.gray,
                dropShadowColor: Color.gray)
        case .deaths:
            data = results.deathsNumber.map{
                Double($0)
            }
            title = "Deaths"
            legend = nil
            style = ChartStyle(
                backgroundColor: Color.white,
                accentColor: Color.red,
                secondGradientColor: Color.red,
                textColor: Color.black,
                legendTextColor: Color.gray,
                dropShadowColor: Color.gray)
        }
        end = results.period
    }
    
    var body: some View {
        VStack {
            LineView(data: data, title: title, legend: legend, style: style, valueSpecifier: "%.0f")
                .frame(height: 325)
            chartXAxis
        }
        .padding()
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(results: ResultModel.init(newlyInfected0: [1,1,1,1,1,1,7,1,1,0,1,1,1,1,1,1,7,1,1,0], newlyInfected1: [1,23,2,4,34,323,2,3,500000,10,1,1,1,1,1,1,7,1,1,0], hospitalizationsNumber: [1,23,2,4,34,323,2,3,0,10,1,23,2,4,34,323,2,3,0,10], deathsNumber: [1,23,2,4,34,323,2,3,0,10,1,23,2,4,34,323,2,3,0,10], infections: [1,23,2,40043,34000,323,2,3,50000,10390,1,1,1,1,1,1,70000,1,1,0], immune: 50, period: 20), choice: .infections)
    }
}

extension ChartView {
    private var chartXAxis: some View {
        HStack {
            Text("Day \(start)")
            Spacer()
            Text("Day \(end)")
        }
        .font(.callout)
    }
}
