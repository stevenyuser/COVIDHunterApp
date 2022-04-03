//
//  ContentView.swift
//  COVIDHunter
//
//  Created by Steven Yu on 1/29/22.
//

import SwiftUI

struct ContentView: View {
    // add quick start simulation button to beginning
    // options for github default params or user saved params
    
    
    @EnvironmentObject var vm: SimulationViewModel
    
    @State private var showGeneralInfoView: Bool = false
    @State private var showModelInfoView: Bool = false
    @State private var showResultsView: Bool = false
    
    // ctc
    @State var TEMP_SCALING_FACTOR_CTC: Double = 0.0367
    @State var TEMP_SCALING_FLOOR_CTC: Double = 1.0
    @State var TEMP_SCALING_CEILING_CTC: Double = 29.0
    
    // brazil
    @State var TEMP_SCALING_FACTOR: Double = 0.05
    @State var TEMP_SCALING_FLOOR: Double = 10.0
    @State var TEMP_SCALING_CEILING: Double = 26.0
    
    var body: some View {
        TabView {
            WelcomeScreen
                .tag(1)
            GeneralParams
                .tag(2)
            ModelParams
                .tag(3)
            endScreen
                .tag(4)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .navigationTitle("COVIDHunter 🦠")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
        .environmentObject(SimulationViewModel())
    }
}

extension ContentView {
    var WelcomeScreen: some View {
        VStack(alignment: .leading) {
            Text("Welcome to COVIDHunter!")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            Text("Please customize the parameters to your liking and then press simulate in the end.")
            Spacer()
            Text("Please click info on any of the pages for more information on the parameters")
            Group {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    var GeneralParams: some View {
        VStack {
            HStack {
                Text("General Parameters")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showGeneralInfoView.toggle()
                }, label: {
                    Label("Info", systemImage: "info.circle.fill")
                })
            }
            .padding()
            Form {
                Section {
                    Picker(selection: $vm.START_MONTH, label: Text("Start month"), content: {
                        ForEach(0..<13) { month in
                            Text("\(month)")
                        }
                    })
                    
                    HStack {
                        Text("Number of days")
                        Spacer()
                        TextField("Number of days", value: $vm.NUM_DAYS, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("First infection day")
                        Spacer()
                        TextField("First infection day", value: $vm.FIRST_INFECTION_DAY, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Minimum Incubation Days")
                        Spacer()
                        TextField("MIN_INCUBATION_DAYS", value: $vm.MIN_INCUBATION_DAYS, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Maximum Incubation Days")
                        Spacer()
                        TextField("MAX_INCUBATION_DAYS", value: $vm.MAX_INCUBATION_DAYS, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    HStack {
                        Text("Population")
                        Spacer()
                        TextField("POPULATION", value: $vm.POPULATION, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Maximum Victims")
                        Spacer()
                        TextField("MAX_VICTIMS", value: $vm.MAX_VICTIMS, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    HStack {
                        Text("Travel Sick Rate")
                        Spacer()
                        TextField("TRAVEL_SICK_RATE", value: $vm.TRAVEL_SICK_RATE, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Travelers Per Day")
                        Spacer()
                        TextField("TRAVELERS_PER_DAY", value: $vm.TRAVELERS_PER_DAY, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("First Travel Day")
                        Spacer()
                        TextField("FIRST_TRAVEL_DAY", value: $vm.FIRST_TRAVEL_DAY, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Last Travel Day")
                        Spacer()
                        TextField("LAST_TRAVEL_DAY", value: $vm.LAST_TRAVEL_DAY, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    HStack {
                        Text("Hospitalizations-to-cases ratio")
                        Spacer()
                        TextField("hospitalizations-to-cases ratio", value: $vm.X, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("deaths-to-cases ratio")
                        Spacer()
                        TextField("deaths-to-cases ratio", value: $vm.Y, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("R0_INTRINSIC_VARIANT1")
                        Spacer()
                        TextField("R0_INTRINSIC_VARIANT1", value: $vm.R0_INTRINSIC_VARIANT1, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Asymptomatic Percentage")
                        Spacer()
                        TextField("ASYMPTOMATIC_PERCENTAGE", value: $vm.ASYMPTOMATIC_PERCENTAGE, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Imported Mutation Rate")
                        Spacer()
                        TextField("IMPORTED_MUTATION_RATE", value: $vm.IMPORTED_MUTATION_RATE, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("R0_ASYMPTOMATIC")
                        Spacer()
                        TextField("R0_ASYMPTOMATIC", value: $vm.R0_ASYMPTOMATIC, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("R0_ASYMPTOMATIC_VARIANT1")
                        Spacer()
                        TextField("R0_ASYMPTOMATIC_VARIANT1", value: $vm.R0_ASYMPTOMATIC_VARIANT1, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    Toggle(isOn: $vm.ENABLE_VACCINATIONS, label: {
                        Text("Vaccinations")
                    })
                    
                    HStack {
                        Text("First Vaccination Day")
                        Spacer()
                        TextField("FIRST_VACCINATION_DAY", value: $vm.FIRST_VACCINATION_DAY, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Vaccination Rate")
                        Spacer()
                        TextField("VACCINATION_RATE", value: $vm.VACCINATION_RATE, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
        .sheet(isPresented: $showGeneralInfoView, content: {
            GeneralInfoView()
        })
    }
    
    var ModelParams: some View {
        VStack {
            HStack {
                Text("Model Parameters")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showModelInfoView.toggle()
                }, label: {
                    Label("Info", systemImage: "info.circle.fill")
                })
            }
            .padding()
            
            Section {
                Picker("Models", selection: $vm.selectedModel) {
                    ForEach(ModelEnum.allCases, id: \.rawValue) { model in
                        Text(model.rawValue).tag(model)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            Form {
                switch vm.selectedModel {
                case ModelEnum.CTC:
                    Section {
                        HStack {
                            Text("Temperature Scaling Factor")
                            Spacer()
                            TextField("TEMP_SCALING_FACTOR", value: $TEMP_SCALING_FACTOR_CTC, formatter: NumberFormatter())
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Temperature Scaling Floor")
                            Spacer()
                            TextField("TEMP_SCALING_FLOOR", value: $TEMP_SCALING_FLOOR_CTC, formatter: NumberFormatter())
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Temperature Scaling Ceiling")
                            Spacer()
                            TextField("TEMP_SCALING_CEILING", value: $TEMP_SCALING_CEILING_CTC, formatter: NumberFormatter())
                                .multilineTextAlignment(.trailing)
                        }
                        
                        Button(action: {
                            vm.ctcModel = CTCModel(TEMP_SCALING_FACTOR: TEMP_SCALING_FACTOR_CTC, TEMP_SCALING_FLOOR: TEMP_SCALING_FLOOR_CTC, TEMP_SCALING_CEILING: TEMP_SCALING_CEILING_CTC)
                            
                        }, label: {
                            Text("Initialize Model")
                        })
                    }
                case ModelEnum.Harvard:
                    Text("Harvard")
                case ModelEnum.Brazil:
                    Text("Not implemented yet")
                case ModelEnum.Wang:
                    Text("Not implemented yet")
                }
                
                Section {
                    Button(action: {
                        // add sheet
                    }, label: {
                        Text("Edit M and Transitions")
                    })
                }
            }
        }
        .sheet(isPresented: $showModelInfoView, content: {
            ModelInfoView()
        })
    }
    
    
    var endScreen: some View {
        ZStack {
            VStack {
                Button(action: {
                    vm.runSimulation()
                    showResultsView.toggle()
                }, label: {
                    Text("Start Simulation!")
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5)
                })
            }
            .sheet(isPresented: $showResultsView, content: {
                // force unwrapping, will crash if not initialized properly
                ResultsView(results: vm.resultModel!)
            })
            
            
            if(vm.isLoading) {
                ProgressView("Calculating")
                    .padding()
                    .background(Color.secondary)
                    .cornerRadius(10)
            }
            
        }
    }
}
