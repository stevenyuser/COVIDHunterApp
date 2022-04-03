//
//  ChartView.swift
//  COVIDHunter
//
//  Created by Steven Yu on 3/27/22.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private var start: Int
    private var end: Int
    @State private var percentage: CGFloat = 0
    
    // add infections 0 and 1 later
    init(results: ResultModel, choice: GraphEnum) {
        switch choice {
        case .infections:
            data = (results.newlyInfected0 + results.newlyInfected1).map{
                Double($0)
            } ?? []
            maxY = data.max() ?? 0
            minY = data.min() ?? 0
        case .hospitalizations:
            data = results.hospitalizationsNumber.map{
                Double($0)
            } ?? []
            maxY = data.max() ?? 0
            minY = data.min() ?? 0
        case .deaths:
            data = results.deathsNumber.map{
                Double($0)
            } ?? []
            maxY = data.max() ?? 0
            minY = data.min() ?? 0
        }
        start = 0
        end = (results.hospitalizationsNumber.count - 1)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 300)
                .background(chartBackground)
                .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(results: ResultModel(newlyInfected0: [], newlyInfected1: [], hospitalizationsNumber: [], deathsNumber: [], totalInfections: 0), choice: .infections)
    }
}

extension ChartView {
    
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                }
            }
            .trim(from: 0.0, to: percentage)
            .stroke(Color.green, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: Color.green, radius: 10, x: 0.0, y: 10)
            .shadow(color: Color.green.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: Color.green.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: Color.green.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text("\(maxY)")
            Spacer()
            Text("\((maxY + minY) / 2)")
            Spacer()
            Text("\(minY)")
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text("Day \(start)")
            Spacer()
            Text("Day \(end)")
        }
    }
}
