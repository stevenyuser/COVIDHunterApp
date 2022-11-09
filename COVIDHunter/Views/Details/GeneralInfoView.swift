//
//  GeneralInfoView.swift
//  COVIDHunter
//
//  Created by Steven Yu on 2/27/22.
//

import SwiftUI

struct GeneralInfoView: View {
    var body: some View {
        
        Text("COVIDHunter can be customized with a variety of parameters.")
            .font(.title2)
            .padding()
        
        ScrollView {
            VStack {
                Text("Basic Parameters")
                    .font(.title3)
                    .bold()
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        VStack(alignment: .leading) {
                            Text("Start Month")
                                .font(.headline)
                            Text("Start simulation on January (use normal 1-12 representation for month here)")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Number of Days")
                                .font(.headline)
                            Text("Maximum number of simulation days")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("First Infection Day")
                                .font(.headline)
                            Text("The day of first infection that is imported into population")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Minimum Infection Days")
                                .font(.headline)
                            Text("The minimum number of days from being infected to being contagious")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Maximum Infection Days")
                                .font(.headline)
                            Text("The maximum number of days from being infected to being contagious")
                                .font(.subheadline)
                        }
                    }
                    Group {
                        VStack(alignment: .leading) {
                            Text("Population")
                                .font(.headline)
                            Text("Population size to simulate (default is Switzerland's 2020 population)")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Maximum Victims")
                                .font(.headline)
                            Text("The maximum number of folks one person can infect (minimum is always 0). Assumes a normal distribution")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Travel Sick Rate")
                                .font(.headline)
                            Text("The percent chance a traveler returning from a trip abroad is contagious and undetected")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Travelers Per Day")
                                .font(.headline)
                            Text("The number of travelers entering country from abroad every day as of first travel day")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("First Travel Day")
                                .font(.headline)
                            Text("The day of first infection that is imported into population")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Last Travel Day")
                                .font(.headline)
                            Text("Point at which potentially infected travelers (some of whom are contagious) start entering country")
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
            }
            
            VStack {
                Text("Advanced Parameters")
                    .font(.title3)
                    .bold()
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        VStack(alignment: .leading) {
                            Text("Hospitalizations-to-cases ratio")
                                .font(.headline)
                            Text("Hospitalizations-to-cases ratio, for CRW-100% = 4.288% for CTC-100% = 2.780%")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Deaths-to-cases ratio")
                                .font(.headline)
                            Text("deaths-to-cases ratio, for CRW-100% = 2.730% for CTC-100% = 1.739%")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Deaths-to-cases ratio")
                                .font(.headline)
                            Text("deaths-to-cases ratio, for CRW-100% = 2.730% for CTC-100% = 1.739%")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("R0_INTRINSIC")
                                .font(.headline)
                            Text("The base reproduction number, R0")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("R0_INTRINSIC_VARIANT1")
                                .font(.headline)
                            Text("The base reproduction number, R0, for the virus variant")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Asymptomatic Percentage")
                                .font(.headline)
                            Text("Percentage of infections that are asymptomatic relative to symptomatic. Asymptomatic folks gain immunity but are less contagious")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Imported Mutation Rate")
                                .font(.headline)
                            Text("Percentage of imported cases that are of mutated variant 1 (as of FIRST_VARIANT_DAY). Set to 0 to disable mutations")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("R0 Asymptomatic")
                                .font(.headline)
                            Text("The base reproduction number, R0, for the asymptomatic cases")
                                .font(.subheadline)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("R0 Asymptomatic Variant")
                                .font(.headline)
                            Text("The base reproduction number, R0, for the asymptomatic cases caused by the virus variant")
                                .font(.subheadline)
                        }
                    }
                }
                
            }
            .padding()
        }
    }
}

struct GeneralInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralInfoView()
    }
}
