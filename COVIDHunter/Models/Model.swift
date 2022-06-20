//
//  Model.swift
//  COVIDHunter
//
//  Created by Steven Yu on 1/29/22.
//

import Foundation

// get the values of a specified model

// want to seperate and organize them into different models
enum ModelEnum: String, CaseIterable {
    case CTC
    case Harvard
    case Brazil
    case Wang
    
//    // recommend CTC and CRW
//    func getModel() -> Model {
//        switch self {
//        case .Brazil:
//            return Model(TEMP_SCALING_FACTOR: 0.05, TEMP_SCALING_FLOOR: 10.0, TEMP_SCALING_CEILING: 26.0)
//        case .CTC:
//            return Model(TEMP_SCALING_FACTOR: 0.0367, TEMP_SCALING_FLOOR: 1.0, TEMP_SCALING_CEILING: 29.0)
//        case .Wang:
//            return Model(TEMP_SCALING_FACTOR: 0.02, TEMP_SCALING_FLOOR: <#T##Double#>, TEMP_SCALING_CEILING: <#T##Double#>)
//        case .HarvardCRW:
//            return Model(TEMP_SCALING_FACTOR: <#T##Double#>, TEMP_SCALING_FLOOR: <#T##Double#>, TEMP_SCALING_CEILING: <#T##Double#>)
//        }
//    }
    
}

// contains values needed to run simulation
struct Model {
    let TEMP_SCALING_FACTOR: Double
    let TEMP_SCALING_FLOOR: Double
    let TEMP_SCALING_CEILING: Double
    
    let ct: Double
    let rt: Double
    let r0mt: Double
    
    let M: [Double] // user configurable
    let TRANSITIONS: [Double] // user configurable
}

// every model needs M and transitions (editable by the user), user adds points
// every model needs the weather model

// focus on harvard and CTC

struct BrazilModel {
    let TEMP_SCALING_FACTOR: Double
    let TEMP_SCALING_FLOOR: Double
    let TEMP_SCALING_CEILING: Double
    
    init() {
        TEMP_SCALING_FACTOR = 0.05 // Linear scaling of infectiousness per degree temperature drop. 0.05 => 5% more infectious per degree of temperature drop
        TEMP_SCALING_FLOOR = 10.0 // Limit temperature below which linear temperature scaling is no longer applied to the R0 value.
        TEMP_SCALING_CEILING = 26.0 // Limit temperature above which linear temperature scaling is no longer applied to the R0 value.
    }
    
    init(TEMP_SCALING_FACTOR: Double, TEMP_SCALING_FLOOR: Double, TEMP_SCALING_CEILING: Double) {
        self.TEMP_SCALING_FACTOR = TEMP_SCALING_FACTOR // Linear scaling of infectiousness per degree temperature drop. 0.05 => 5% more infectious per degree of temperature drop
        self.TEMP_SCALING_FLOOR = TEMP_SCALING_FLOOR // Limit temperature below which linear temperature scaling is no longer applied to the R0 value.
        self.TEMP_SCALING_CEILING = TEMP_SCALING_CEILING // Limit temperature above which linear temperature scaling is no longer applied to the R0 value.
    }

}

struct HarvardModel {
    let CRW_Harvard = [0.997142857, 0.992428571, 0.998857143, 1.002714286, 0.995571429, 0.990714286, 0.978571429, 0.964571429, 0.948428571, 0.923571429, 0.902571429, 0.902285714, 0.900428571, 0.865, 0.869285714, 0.869, 0.858142857, 0.847857143, 0.851, 0.857142857, 0.851, 0.843428571, 0.85, 0.856428571, 0.851428571, 0.845428571, 0.84, 0.841857143, 0.846857143, 0.848714286, 0.841, 0.833571429, 0.836285714, 0.849714286, 0.864428571, 0.874142857, 0.890714286, 0.902428571, 0.906285714, 0.922714286, 0.945142857, 0.960285714, 0.959285714, 0.984285714, 1.018142857, 1.034285714, 1.017714286, 1.026428571, 1.037142857]
    let CRW_Harvard_TRANSITIONS = [3, 10, 17, 24, 31, 38, 44, 51, 58, 66, 73, 80, 87, 116, 123, 130, 137, 144, 151, 158, 165, 172, 179, 186, 193, 200, 207, 214, 221, 228, 235, 242, 249, 256, 263, 270, 277, 284, 291, 298, 305, 312, 319, 326, 333, 340, 347, 354, 361]
}

struct WangModel {
    let Wang_TEMP_SCALING_FACTOR = 0.02 // Linear scaling of infectiousness per degree temperature drop. 0.05 => 5% more infectious per degree of temperature drop
    let Wang_Humidity_SCALING_FACTOR = 0.008 // Linear scaling of infectiousness per degree temperature drop. 0.05 => 5% more infectious per degree of temperature drop

    // THIS IS FOR SWITZERLAND SPECIFIC, maybe change to be user configurable later
    let TEMP_MONTHLY_HIGH = [4, 6, 11, 15, 19, 23, 25, 24, 20, 15, 9, 5]
    let TEMP_November_HIGH = [13, 15, 12, 12, 8, 8, 8, 3, 6, 6, 9, 6, 5, 6, 4, 5, 2, 4, 3, 6, 7, 7, 8, 9, 9, 10, 9, 7, 4, 5]
    let TEMP_MONTHLY_LOW = [-1, 0, 3,  6, 10, 13,  15, 15, 12, 8,  3, 0]
    // Relative humidity https://www.worlddata.info/europe/switzerland/climate.php
    let Humidity_MONTHLY_HIGH = [80, 77, 71, 69, 71, 70, 68, 72, 76, 80, 80, 80]
}

struct CTCModel {
    let TEMP_SCALING_FACTOR_CTC: Double // Linear scaling of infectiousness per degree temperature drop. 0.05 => 5% more infectious per degree of temperature drop
    let TEMP_SCALING_FLOOR_CTC: Double // Limit temperature below which linear temperature scaling is no longer applied to the R0 value.
    let TEMP_SCALING_CEILING_CTC: Double // Limit temperature above which linear temperature scaling is no longer applied to the R0 value.
    
    init() {
        TEMP_SCALING_FACTOR_CTC = 0.0367 // Linear scaling of infectiousness per degree temperature drop. 0.05 => 5% more infectious per degree of temperature drop
        TEMP_SCALING_FLOOR_CTC = 1.0 // Limit temperature below which linear temperature scaling is no longer applied to the R0 value.
        TEMP_SCALING_CEILING_CTC = 29.0 // Limit temperature above which linear temperature scaling is no longer applied to the R0 value.
    }
    
    init(TEMP_SCALING_FACTOR: Double, TEMP_SCALING_FLOOR: Double, TEMP_SCALING_CEILING: Double) {
        self.TEMP_SCALING_FACTOR_CTC = TEMP_SCALING_FACTOR // Linear scaling of infectiousness per degree temperature drop. 0.05 => 5% more infectious per degree of temperature drop
        self.TEMP_SCALING_FLOOR_CTC = TEMP_SCALING_FLOOR // Limit temperature below which linear temperature scaling is no longer applied to the R0 value.
        self.TEMP_SCALING_CEILING_CTC = TEMP_SCALING_CEILING // Limit temperature above which linear temperature scaling is no longer applied to the R0 value.
    }
}

// model of results
//             print("\(day+1), \(POPULATION-free_person_ptr), \(newly_infected[0]), \(newly_infected[1]), \(hospitalizations_number), \(deaths_number), \(infected_original), \(contagious), \(sick_person_ptr+immune), \(total_vaccinated),  \(asymptomatic), \(total_travelers), \(intrinsic_r_string), \(C_string), \(M_string), \(phase_string), \(temp_r_string), \(phase_temp_r_string), \(actual_r_string)")
struct ResultModel: Codable {
    // graph data
    let newlyInfected0: [Int]
    let newlyInfected1: [Int]
    let hospitalizationsNumber: [Double]
    let deathsNumber: [Double]
    
    let infections: [Int]
    let immune: Double
    
    let period: Int
}

enum GraphEnum: String, CaseIterable {
    case infections
    case hospitalizations
    case deaths
}
