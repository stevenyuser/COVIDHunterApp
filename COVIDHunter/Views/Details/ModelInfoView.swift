//
//  ModelInfoView.swift
//  COVIDHunter
//
//  Created by Steven Yu on 3/27/22.
//

import SwiftUI

struct ModelInfoView: View {
    var body: some View {
        Text("COVIDHunter can directly leverage a variety of existing models to predict the reproduction number (R).")
            .font(.title2)
            .padding()
        
        ScrollView {
            VStack {
                Text("CTC")
                    .font(.title3)
                    .bold()
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("Temperature Scaling Factor")
                            .font(.headline)
                        Text("Linear scaling of infectiousness per degree temperature drop. 0.0367 => 3.67% more infectious per degree of temperature drop")
                            .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Temperature Scaling Floor")
                            .font(.headline)
                        Text("Limit temperature below which linear temperature scaling is no longer applied to the R0 value.")
                            .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Temperature Scaling Ceiling")
                            .font(.headline)
                        Text("Limit temperature above which linear temperature scaling is no longer applied to the R0 value.")
                            .font(.subheadline)
                    }
                }
            }
            .padding()
            
            VStack {
                Text("Harvard CRW")
                    .font(.title3)
                    .bold()
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("CRW Values")
                            .font(.headline)
                        Text("Relative COVID-19 risk due to weather (CRW) value extracted from [Harvard's CRW projections](https://projects.iq.harvard.edu/covid19/global)")
                            .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("CRW Transitions")
                            .font(.headline)
                        Text("Day transition of CRW value extracted from [Harvard's CRW projections](https://projects.iq.harvard.edu/covid19/global)")
                            .font(.subheadline)
                    }
                }
            }
            .padding()
            
            VStack {
                Text("Brazil CTC")
                    .font(.title3)
                    .bold()
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("Temperature Scaling Factor")
                            .font(.headline)
                        Text("Linear scaling of infectiousness per degree temperature drop. 0.0367 => 3.67% more infectious per degree of temperature drop")
                            .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Temperature Scaling Floor")
                            .font(.headline)
                        Text("Limit temperature below which linear temperature scaling is no longer applied to the R0 value.")
                            .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Temperature Scaling Ceiling")
                            .font(.headline)
                        Text("Limit temperature above which linear temperature scaling is no longer applied to the R0 value.")
                            .font(.subheadline)
                    }
                }
            }
            .padding()
            
            VStack {
                Text("Wang Temperature & Humidity")
                    .font(.title3)
                    .bold()
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("Temperature Scaling Factor")
                            .font(.headline)
                        Text("Scaling of infectiousness per degree temperature dros.")
                            .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Humidity Scaling Factor")
                            .font(.headline)
                        Text("Scaling of infectiousness per percent relative humidity drop.")
                            .font(.subheadline)
                    }
                }
            }
            .padding()
        }
    }
}

struct ModelInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ModelInfoView()
    }
}
