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
                }
                .padding(.horizontal)
                
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
                            TextField("M", text: $mArray[index])
                                .fixedSize()
                                .foregroundColor(Color.blue)
                                .keyboardType(.decimalPad)
                            //                                    .onSubmit {
                            //                                        vm.M[index] = Double(mArray[index]) ?? 0
                            //                                        print("\(vm.TRANSITIONS[index])")
                            //                                    }
                                .onChange(of: mArray[index]) { value in
                                    vm.M[index] = Double(value) ?? 0
                                    print("\(index), \(vm.M[index])")
                                }
                            
                            Spacer()
                            
                            TextField("Transition", text: $transitionArray[index])
                                .fixedSize()
                                .foregroundColor(Color.blue)
                                .keyboardType(.numberPad)
                                .onChange(of: transitionArray[index]) { value in
                                    vm.TRANSITIONS[index] = Int(value) ?? 0
                                    print("\(index), \(vm.TRANSITIONS[index])")
                                }
                        }
                    }
                    .onDelete(perform: delete)
                    .onAppear {
                        vm.M.indices.forEach { index in
                            mArray[index] = String(vm.M[index])
                            transitionArray[index] = String(vm.TRANSITIONS[index])
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        vm.M.append(0)
                        vm.TRANSITIONS.append(0)
                        
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
        vm.M.remove(atOffsets: offsets)
        vm.TRANSITIONS.remove(atOffsets: offsets)
        
        mArray.remove(atOffsets: offsets)
        transitionArray.remove(atOffsets: offsets)
    }
}

struct MTEditView_Previews: PreviewProvider {
    static var previews: some View {
        MTEditView()
    }
}
