//
//  ContentView.swift
//  COVIDHunter
//
//  Created by Steven Yu on 1/29/22.
//

import SwiftUI

// TODO: add quick start simulation button to beginning
// TODO: options for default params or user saved params

struct ContentView: View {
    
    @EnvironmentObject var vm: SimulationViewModel
    
    @State private var showGeneralInfoView: Bool = false
    @State private var showModelInfoView: Bool = false
    @State private var showResultsView: Bool = false
    
    @State private var showHarvardEditView: Bool = false
    @State private var showMTEditView: Bool = false
    
    // ctc
    @State var TEMP_SCALING_FACTOR_CTC: Double = 0.0367
    @State var TEMP_SCALING_FLOOR_CTC: Double = 1.0
    @State var TEMP_SCALING_CEILING_CTC: Double = 29.0
    
    // brazil
    @State var TEMP_SCALING_FACTOR: Double = 0.05
    @State var TEMP_SCALING_FLOOR: Double = 10.0
    @State var TEMP_SCALING_CEILING: Double = 26.0
    
    // wang
    @State var Wang_TEMP_SCALING_FACTOR: Double = 0.02
    @State var Wang_Humidity_SCALING_FACTOR: Double = 0.008
    
    private let months = ["January", "Febuary", "March", "April", "May", "June", "July", "August", "September", "November", "December"]
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
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
        VStack(alignment: .leading, spacing: 10) {
            Group {
                Text("Welcome to COVIDHunter!")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Initially, this simulation model has the parameters set to Switzerland.")
                Text("Please customize the parameters to your liking and then press simulate in the end.")
                Text("Please click info on any of the pages for more information on the parameters.")
            }
            
            Divider()
            
            Spacer()
            
            Group {
                Link(destination: URL(string: "https://github.com/CMU-SAFARI/COVIDHunter")!) {
                    Label("COVIDHunter Model Source Code", systemImage: "link")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                Link(destination: URL(string: "https://arxiv.org/abs/2206.06692")!) {
                    Label("COVIDHunter Arxiv Paper", systemImage: "link")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                Spacer()
                
                Text("Created by")
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Link(destination: URL(string: "https://safari.ethz.ch/")!) {
                    Label("SAFARI Research Group", systemImage: "link")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            
            Spacer()
            
            //            Group {
            //                Spacer()
            //                Spacer()
            //                Spacer()
            //                Spacer()
            //                Spacer()
            //                Spacer()
            //                Spacer()
            //                Spacer()
            //                Spacer()
            //            }
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
                    HStack {
                        Text("Start Month")
                        Spacer()
                        Picker(selection: $vm.START_MONTH, label: Text("Start month"), content: {
                            ForEach(0..<months.count) { month in
                                Text("\(self.months[month])")
                            }
                        })
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    HStack {
                        Text("Number of days")
                        Spacer()
                        TextField("Number of days", value: $vm.NUM_DAYS, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("First infection day")
                        Spacer()
                        TextField("First infection day", value: $vm.FIRST_INFECTION_DAY, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("Minimum Incubation Days")
                        Spacer()
                        TextField("MIN_INCUBATION_DAYS", value: $vm.MIN_INCUBATION_DAYS, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("Maximum Incubation Days")
                        Spacer()
                        TextField("MAX_INCUBATION_DAYS", value: $vm.MAX_INCUBATION_DAYS, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                }
                
                Section {
                    HStack {
                        Text("Population")
                        Spacer()
                        TextField("POPULATION", value: $vm.POPULATION, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("Maximum Victims")
                        Spacer()
                        TextField("MAX_VICTIMS", value: $vm.MAX_VICTIMS, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                }
                
                Section {
                    HStack {
                        Text("Travel Sick Rate (%)")
                        Spacer()
                        TextField("TRAVEL_SICK_RATE", value: $vm.TRAVEL_SICK_RATE, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("Travelers Per Day")
                        Spacer()
                        TextField("TRAVELERS_PER_DAY", value: $vm.TRAVELERS_PER_DAY, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("First Travel Day")
                        Spacer()
                        TextField("FIRST_TRAVEL_DAY", value: $vm.FIRST_TRAVEL_DAY, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("Last Travel Day")
                        Spacer()
                        TextField("LAST_TRAVEL_DAY", value: $vm.LAST_TRAVEL_DAY, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                }
                
                Section {
                    HStack {
                        Text("Hospitalizations-to-cases ratio")
                        Spacer()
                        TextField("Hospitalizations-to-cases ratio", value: $vm.X, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("Deaths-to-cases ratio")
                        Spacer()
                        TextField("Deaths-to-cases ratio", value: $vm.Y, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("R0 Intrinsic")
                        Spacer()
                        TextField("R0_INTRINSIC", value: $vm.R0_INTRINSIC, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("R0 Intrinsic Variant")
                        Spacer()
                        TextField("R0_INTRINSIC_VARIANT1", value: $vm.R0_INTRINSIC_VARIANT1, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("Asymptomatic Percentage")
                        Spacer()
                        TextField("ASYMPTOMATIC_PERCENTAGE", value: $vm.ASYMPTOMATIC_PERCENTAGE, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("Imported Mutation Rate (%)")
                        Spacer()
                        TextField("IMPORTED_MUTATION_RATE", value: $vm.IMPORTED_MUTATION_RATE, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("R0 Asymptomatic")
                        Spacer()
                        TextField("R0_ASYMPTOMATIC", value: $vm.R0_ASYMPTOMATIC, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                    
                    HStack {
                        Text("R0 Asymptomatic Variant")
                        Spacer()
                        TextField("R0_ASYMPTOMATIC_VARIANT1", value: $vm.R0_ASYMPTOMATIC_VARIANT1, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.blue)
                    }
                }
                
                Section {
                    Toggle(isOn: $vm.ENABLE_VACCINATIONS, label: {
                        Text("Vaccinations")
                    })
                    
                    HStack {
                        Text("First Vaccination Day")
                        Spacer()
                        TextField("FIRST_VACCINATION_DAY", value: $vm.FIRST_VACCINATION_DAY, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(vm.ENABLE_VACCINATIONS ? Color.blue : Color.gray)
                            .disabled(vm.ENABLE_VACCINATIONS == false)
                    }
                    
                    HStack {
                        Text("Vaccination Rate")
                        Spacer()
                        TextField("VACCINATION_RATE", value: $vm.VACCINATION_RATE, formatter: formatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .foregroundColor(vm.ENABLE_VACCINATIONS ? Color.blue : Color.gray)
                            .disabled(vm.ENABLE_VACCINATIONS == false)
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
                            TextField("TEMP_SCALING_FACTOR", value: $TEMP_SCALING_FACTOR_CTC, formatter: formatter)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(Color.blue)
                        }
                        
                        HStack {
                            Text("Temperature Scaling Floor")
                            Spacer()
                            TextField("TEMP_SCALING_FLOOR", value: $TEMP_SCALING_FLOOR_CTC, formatter: formatter)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(Color.blue)
                        }
                        
                        HStack {
                            Text("Temperature Scaling Ceiling")
                            Spacer()
                            TextField("TEMP_SCALING_CEILING", value: $TEMP_SCALING_CEILING_CTC, formatter: formatter)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(Color.blue)
                        }
                        
                        Button(action: {
                            vm.ctcModel = CTCModel(TEMP_SCALING_FACTOR: TEMP_SCALING_FACTOR_CTC, TEMP_SCALING_FLOOR: TEMP_SCALING_FLOOR_CTC, TEMP_SCALING_CEILING: TEMP_SCALING_CEILING_CTC)
                            vm.modelInitalized = true
                        }, label: {
                            Text(vm.modelInitalized ? "Model Initalized!" : "Initialize Model to Continue")
                        })
                        .disabled(vm.modelInitalized)
                    }
                    
                    // requires a way to edit list
                case ModelEnum.Harvard:
                    Section {
                        Button {
                            vm.harvardModel = HarvardModel()
                            showHarvardEditView = true
                            vm.modelInitalized = true
                        } label: {
                            Text("Initalize and Edit CRW Values and Transitions")
                        }
                        
                    }
                    
                case ModelEnum.Brazil:
                    Section {
                        HStack {
                            Text("Temperature Scaling Factor")
                            Spacer()
                            TextField("TEMP_SCALING_FACTOR", value: $TEMP_SCALING_FACTOR, formatter: formatter)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(Color.blue)
                        }
                        
                        HStack {
                            Text("Temperature Scaling Floor")
                            Spacer()
                            TextField("TEMP_SCALING_FLOOR", value: $TEMP_SCALING_FLOOR, formatter: formatter)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(Color.blue)
                        }
                        
                        HStack {
                            Text("Temperature Scaling Ceiling")
                            Spacer()
                            TextField("TEMP_SCALING_CEILING", value: $TEMP_SCALING_CEILING, formatter: formatter)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(Color.blue)
                        }
                        
                        Button(action: {
                            vm.brazilModel = BrazilModel(TEMP_SCALING_FACTOR: TEMP_SCALING_FACTOR, TEMP_SCALING_FLOOR: TEMP_SCALING_FLOOR, TEMP_SCALING_CEILING: TEMP_SCALING_CEILING)
                            vm.modelInitalized = true
                        }, label: {
                            Text(vm.modelInitalized ? "Model Initalized!" : "Initialize Model to Continue")
                        })
                        .disabled(vm.modelInitalized)
                    }
                case ModelEnum.Wang:
                    Section {
                        HStack {
                            Text("Temperature Scaling Factor")
                            Spacer()
                            TextField("Wang_TEMP_SCALING_FACTOR", value: $Wang_TEMP_SCALING_FACTOR, format: .number)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(Color.blue)
                        }
                        
                        HStack {
                            Text("Humidity Scaling Factor")
                            Spacer()
                            TextField("Wang_Humidity_SCALING_FACTOR", value: $Wang_Humidity_SCALING_FACTOR, formatter: formatter)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(Color.blue)
                        }
                        
                        Button(action: {
                            vm.wangModel = WangModel(Wang_TEMP_SCALING_FACTOR: Wang_TEMP_SCALING_FACTOR, Wang_Humidity_SCALING_FACTOR: Wang_Humidity_SCALING_FACTOR)
                            vm.modelInitalized = true
                        }, label: {
                            Text(vm.modelInitalized ? "Model Initalized!" : "Initialize Model to Continue")
                        })
                        .disabled(vm.modelInitalized)
                    }
                }
                
                Section {
                    Button(action: {
                        vm.selectedMTModel = MTEnum.CTC100
                        vm.mtModel = MTEnum.CTC100.model
                        
                        showMTEditView.toggle()
                    }, label: {
                        Text("Edit M and Transitions")
                    })
                }
            }
        }
        .sheet(isPresented: $showModelInfoView, content: {
            ModelInfoView()
        })
        .sheet(isPresented: $showHarvardEditView) {
            HarvardEditView()
        }
        .sheet(isPresented: $showMTEditView) {
            MTEditView()
        }
    }
    
    
    var endScreen: some View {
        ZStack {
            VStack {
                Button(action: {
                    Task {
                        print("Append 9999...")
                        vm.mtModel.TRANSITIONS.append(9999)
                        print("Appended")
                        await vm.run()
                        print("finished running")
                        showResultsView.toggle()
                    }
                }, label: {
                    Text("Start Simulation!")
                })
            }
            .tint(Color.blue)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .disabled(!vm.modelInitalized)
            .sheet(isPresented: $showResultsView, content: {
                // force unwrapping, will crash if not initialized properly
                ResultsView(results: vm.resultModel!)
            })
            
            if(vm.isLoading) {
                //                ProgressView("\(vm.currentDay) - Calculating")
                //                    .padding()
                //                    .background(Color.secondary)
                //                    .cornerRadius(10)
                
                ProgressView("Calculating...", value: Double(vm.currentDay), total: Double(vm.NUM_DAYS))
                    .padding()
                    .background(
                        Rectangle()
                            .foregroundColor(Color.secondary.opacity(0.1))
                            .background(.thickMaterial)
                            .cornerRadius(10)
                    )
                    .padding()
            }
        }
    }
}
