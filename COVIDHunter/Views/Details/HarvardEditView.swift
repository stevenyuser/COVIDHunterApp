//
//  HarvardEditView.swift
//  COVIDHunter
//
//  Created by Steven Yu on 7/11/22.
//

import SwiftUI

struct HarvardEditView: View {
    @EnvironmentObject var vm: SimulationViewModel
    
    @State var valueArray: [String] = [String](repeating: "", count: 49)
    @State var transitionArray: [String] = [String](repeating: "", count: 49)
    
    @State private var showAddItemView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if var model = vm.harvardModel {
                    List {
                        HStack {
                            Text("Value")
                            Spacer()
                            Text("Transition")
                                .padding(.horizontal)
                        }
                        .font(.subheadline)
                        ForEach(0..<valueArray.count, id: \.self) { index in
                            HStack {
                                TextField("Value", text: $valueArray[index])
                                    .fixedSize()
                                    .foregroundColor(Color.blue)
                                    .keyboardType(.decimalPad)
                                //                                    .onSubmit {
                                //                                        model.CRW_Harvard[index] = Double(valueArray[index]) ?? 0
                                //                                        print("\(model.CRW_Harvard[index])")
                                //                                    }
                                    .onChange(of: valueArray[index]) { value in
                                        model.CRW_Harvard[index] = Double(value) ?? 0
                                        print("\(index), \(model.CRW_Harvard[index])")
                                    }
                                
                                Spacer()
                                
                                TextField("Transition", text: $transitionArray[index])
                                    .fixedSize()
                                    .foregroundColor(Color.blue)
                                    .keyboardType(.numberPad)
                                    .onChange(of: transitionArray[index]) { value in
                                        model.CRW_Harvard_TRANSITIONS[index] = Int(value) ?? 0
                                        print("\(index), \(model.CRW_Harvard_TRANSITIONS[index])")
                                    }
                            }
                        }
                        .onDelete(perform: delete)
                        .onAppear {
                            model.CRW_Harvard.indices.forEach { index in
                                valueArray[index] = String(model.CRW_Harvard[index])
                                transitionArray[index] = String(model.CRW_Harvard_TRANSITIONS[index])
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        vm.harvardModel?.CRW_Harvard.append(0)
                        vm.harvardModel?.CRW_Harvard_TRANSITIONS.append(0)
                        
                        valueArray.append("")
                        transitionArray.append("")
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
            }
            .navigationTitle("Harvard CRW")
        }
    }
    
    func delete(at offsets: IndexSet) {
        vm.harvardModel?.CRW_Harvard.remove(atOffsets: offsets)
        vm.harvardModel?.CRW_Harvard_TRANSITIONS.remove(atOffsets: offsets)
        
        valueArray.remove(atOffsets: offsets)
        transitionArray.remove(atOffsets: offsets)
    }
}

struct HarvardEditView_Previews: PreviewProvider {
    static var previews: some View {
        HarvardRowView(value: 100, transition: 100)
    }
}

struct HarvardRowView: View {
    var value: Double
    var transition: Int
    
    var body: some View {
        HStack {
            Text("\(value)")
            Spacer()
            Text("\(transition)")
        }
        .padding(.horizontal)
    }
}

//struct AddItemView: View {
//    @EnvironmentObject var vm: SimulationViewModel
//
//
//    var body: some View {
//
//    }
//}
