//
//  MTEditView.swift
//  COVIDHunter
//
//  Created by Steven Yu on 7/11/22.
//

import SwiftUI

// add the 9999 at the end of the code, after the user adds params

struct MTEditView: View {
    @EnvironmentObject var vm: SimulationViewModel
    
    // default mt model is CTC100
    @State var mArray: [String] = [String](repeating: "", count: 17)
    @State var transitionArray: [String] = [String](repeating: "", count: 17)
    
    var body: some View {
        NavigationView {
            VStack {
                DisclosureGroup {
                    Text("Mitigation factor, M changes with time and addresses to what extent the population takes mitigation measures to protect themselves from the virus. Mitigation measures include items like social distancing, handwashing, contract tracing, quarantine, and lockdowns. A Mitigation value of 0.0 implies no mitigation whatsoever while a mitigation value of 1.0 implies perfect isolation of all infected individuals so no further spread is possible.")
                        .fixedSize(horizontal: false, vertical: true)
                } label: {
                    Text("Mitigation Factor Info")
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("M and Transitions Model: ")
                        .font(.subheadline)
                    Spacer()
                    Picker(selection: $vm.selectedMTModel) {
                        ForEach(MTEnum.allCases, id:\.self) { model in
                            Text(model.rawValue)
                                .tag(model)
                        }
                    } label: {
                        Text("MT Model")
                    }
                    .onChange(of: vm.selectedMTModel) { mtModelSelection in
                        vm.mtModel = mtModelSelection.model
                        
                        mArray = vm.mtModel.M.map{ String($0) }
                        transitionArray = vm.mtModel.TRANSITIONS.map{ String($0) }
                        
                        print("Current model: \(mtModelSelection.rawValue)")
                    }
                }
                .padding()
                
                List {
                    HStack {
                        Text("M Value")
                        Spacer()
                        Text("Transition")
                            .padding(.horizontal)
                    }
                    .font(.subheadline)
                    
                    ForEach(0..<mArray.count, id: \.self) { index in
                        HStack {
                            TextField("Value", text: $mArray[index])
                                .fixedSize()
                                .foregroundColor(Color.blue)
                                .keyboardType(.decimalPad)
                            //                                    .onSubmit {
                            //                                        model.CRW_Harvard[index] = Double(valueArray[index]) ?? 0
                            //                                        print("\(model.CRW_Harvard[index])")
                            //                                    }
                                .onChange(of: mArray[index]) { mValue in
                                    vm.mtModel.M[index] = Double(mValue) ?? 0
                                    print("\(index), \(vm.mtModel.TRANSITIONS[index])")
                                }
                            
                            Spacer()
                            
                            TextField("Transition", text: $transitionArray[index])
                                .fixedSize()
                                .foregroundColor(Color.blue)
                                .keyboardType(.numberPad)
                                .onChange(of: transitionArray[index]) { transition in
                                    vm.mtModel.TRANSITIONS[index] = Int(transition) ?? 0
                                    print("\(index), \(vm.mtModel.TRANSITIONS[index])")
                                }
                        }
                    }
                    .onDelete(perform: delete)
                    .onAppear {
                        vm.mtModel.M.indices.forEach { index in
                            mArray[index] = String(vm.mtModel.M[index])
                            transitionArray[index] = String(vm.mtModel.TRANSITIONS[index])
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        vm.mtModel.M.append(0)
                        vm.mtModel.TRANSITIONS.append(0)
                        
                        mArray.append("")
                        transitionArray.append("")
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Mitigation Measures")
        }
    }
    
    func delete(at offsets: IndexSet) {
        vm.mtModel.M.remove(atOffsets: offsets)
        vm.mtModel.TRANSITIONS.remove(atOffsets: offsets)
        
        mArray.remove(atOffsets: offsets)
        transitionArray.remove(atOffsets: offsets)
    }
}

struct MTEditView_Previews: PreviewProvider {
    static var previews: some View {
        MTEditView()
    }
}
