//
//  Model.swift
//  COVIDHunter
//
//  Created by Steven Yu on 1/29/22.
//

import Foundation

// get the values of a specified model

// want to seperate and organize them into different models
enum ModelEnum: String, CaseIterable, Codable {
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
    // COVID-19 Risk due to Weather
    var CRW_Harvard: [Double]
    var CRW_Harvard_TRANSITIONS: [Int]
    
    init() {
        CRW_Harvard = [0.997142857, 0.992428571, 0.998857143, 1.002714286, 0.995571429, 0.990714286, 0.978571429, 0.964571429, 0.948428571, 0.923571429, 0.902571429, 0.902285714, 0.900428571, 0.865, 0.869285714, 0.869, 0.858142857, 0.847857143, 0.851, 0.857142857, 0.851, 0.843428571, 0.85, 0.856428571, 0.851428571, 0.845428571, 0.84, 0.841857143, 0.846857143, 0.848714286, 0.841, 0.833571429, 0.836285714, 0.849714286, 0.864428571, 0.874142857, 0.890714286, 0.902428571, 0.906285714, 0.922714286, 0.945142857, 0.960285714, 0.959285714, 0.984285714, 1.018142857, 1.034285714, 1.017714286, 1.026428571, 1.037142857]
        CRW_Harvard_TRANSITIONS = [3, 10, 17, 24, 31, 38, 44, 51, 58, 66, 73, 80, 87, 116, 123, 130, 137, 144, 151, 158, 165, 172, 179, 186, 193, 200, 207, 214, 221, 228, 235, 242, 249, 256, 263, 270, 277, 284, 291, 298, 305, 312, 319, 326, 333, 340, 347, 354, 361]
    }
    
    init(CRW_Harvard: [Double], CRW_Harvard_TRANSITIONS: [Int]) {
        self.CRW_Harvard = CRW_Harvard
        self.CRW_Harvard_TRANSITIONS = CRW_Harvard_TRANSITIONS
    }
}

struct WangModel {
    let Wang_TEMP_SCALING_FACTOR: Double // Linear scaling of infectiousness per degree temperature drop. 0.05 => 5% more infectious per degree of temperature drop
    let Wang_Humidity_SCALING_FACTOR: Double // Linear scaling of infectiousness per degree temperature drop. 0.05 => 5% more infectious per degree of temperature drop
    
    // not specifically needed for the wang model
    //    // THIS IS FOR SWITZERLAND SPECIFIC, maybe change to be user configurable later
    //    let TEMP_MONTHLY_HIGH = [4, 6, 11, 15, 19, 23, 25, 24, 20, 15, 9, 5]
    //    let TEMP_November_HIGH = [13, 15, 12, 12, 8, 8, 8, 3, 6, 6, 9, 6, 5, 6, 4, 5, 2, 4, 3, 6, 7, 7, 8, 9, 9, 10, 9, 7, 4, 5]
    //    let TEMP_MONTHLY_LOW = [-1, 0, 3,  6, 10, 13,  15, 15, 12, 8,  3, 0]
    //    // Relative humidity https://www.worlddata.info/europe/switzerland/climate.php
    //    let Humidity_MONTHLY_HIGH = [80, 77, 71, 69, 71, 70, 68, 72, 76, 80, 80, 80]
    
    init() {
        Wang_TEMP_SCALING_FACTOR = 0.02
        Wang_Humidity_SCALING_FACTOR = 0.008
    }
    
    init(Wang_TEMP_SCALING_FACTOR: Double, Wang_Humidity_SCALING_FACTOR: Double) {
        self.Wang_TEMP_SCALING_FACTOR = Wang_TEMP_SCALING_FACTOR
        self.Wang_Humidity_SCALING_FACTOR = Wang_Humidity_SCALING_FACTOR
    }
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

struct MitigationModel {
    
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
    
    let totalInfected0: Int
    let totalInfected1: Int
    
    let model: ModelEnum
}

enum GraphEnum: String, CaseIterable {
    case infections
    case hospitalizations
    case deaths
}

struct MTModel: Codable {
    var M: [Double]
    var TRANSITIONS: [Int] // Day
}

enum MTEnum: String, CaseIterable, Identifiable {
    var id: MTEnum { self }
    
    
    case Brazil100 = "Brazil 100%"
    case Brazil10 = "Brazil 10%"
    
    case CTC100 = "CTC 100%"
    case CTC50 = "CTC 50%"
    case CTC50_notemp = "CTC 50% - no temp."
    case CTC10 = "CTC 10%"
    
    case CRW100 = "CRW 100%"
    case CRW50 = "CRW 50%"
    case CRW10 = "CRW 10%"
    
    case Wang100 = "Wang 100%"
    case Wang10 = "Wang 10%"
    
    var model: MTModel {
        switch self {
        case .Brazil100:
            return MTModel(
                M: [0, 0.2233, 0.329, 0.384, 0.4, 0.4444, 0.7315, 0.6944, 0.6574, 0.6296, 0.5, 0.4815, 0.3704, 0.412, 0.406, 0.438, 0.5019, 0.55, 0.7, 0.75,    0, 0.75],
                TRANSITIONS: [1,     56,     58,   59,   63,     73,    77,    118,    132,    151, 158,    160,    174,    185,   245,   284,   293,   294, 303,  330,   355,  370]
            )
        case .Brazil10:
            return MTModel(
                M: [0, 0.19, 0.19, 0.22, 0.25, 0.3444, 0.5515, 0.7, 0.7044, 0.5074, 0.50296, 0.5, 0.04815, 0.0504, 0.112, 0.2,0.338, 0.35, 0.32, 0.585, 0.6,    0, 0.6],
                TRANSITIONS: [1,  56,  58,   59,   63,     73,    77,    90,    118,    132,    151, 158,    160,    174,     185, 210,  230,   264,  280,    303, 330,  355, 370]
            )
        case .CTC100:
            return MTModel(
                M: [0, 0.45, 0.7,  0.7, 0.65, 0.63, 0.5, 0.355, 0.6, 0.7, 0.7, 0.71, 0.73, 0.73, 0.6, 0.35, 0.6],
                TRANSITIONS: [1,   58,  77,  118,  132,  151, 174,   245, 284, 303, 320,  330,  356,  387, 425,  475,  505]
            )
        case .CTC50:
            return MTModel(
                M: [0, 0.35, 0.66,  0.7, 0.65, 0.63, 0.5, 0.35, 0.5, 0.65, 0.68, 0.69, 0.69, 0.35, 0.7, 0.7],
                TRANSITIONS: [1,   58,   76,  100,  132,  151, 174,  235,  274,  303,  320,  330,  356, 387, 420, 450]
            )
        case .CTC50_notemp:
            return MTModel(
                M: [0, 0.13, 0.6,  0.7, 0.65, 0.63, 0.6, 0.6, 0.45, 0.57, 0.59, 0.58, 0.55, 0.13, 0.55, 0.55],
                TRANSITIONS: [1,   58, 76,  100,  132,  151, 174,  235,  274,  303,  320,  330,  356, 387, 420, 450]
            )
        case .CTC10:
            return MTModel(
                M: [0, 0.27, 0.585, 0.7, 0.4, 0.2, 0.55, 0.55, 0.44, 0.44, 0.42, 0.3, 0.2],
                TRANSITIONS: [1,   63,    77,  90, 188, 235, 293,  303, 330,  356,  387, 420, 450,9999]
            )
        case .CRW100:
            return MTModel(
                M: [0, 0.45, 0.7,  0.7, 0.65, 0.63, 0.5, 0.36, 0.37, 0.6, 0.71,  0.71, 0.71, 0.73,  0.35, 0.73, 0.73],
                TRANSITIONS: [1,   58,  77,  118,  132,  151, 174,  245, 260, 284, 303,  320, 330,  356,  387, 420,  450, 9999]
            )
        case .CRW50:
            return MTModel(
                M: [0, 0.35, 0.7,  0.71, 0.65, 0.63, 0.5, 0.35, 0.5, 0.68, 0.7, 0.71, 0.71, 0.35, 0.71, 0.71],
                TRANSITIONS: [1,   58,   76,  100,  132,  151, 174,  235,  274,  303,  320,  330,  356, 387, 420, 450, 9999]
            )
        case .CRW10:
            return MTModel(
                M: [0, 0.27, 0.485, 0.7, 0.4, 0.2, 0.7, 0.5,  0.6, 0.58, 0.2],
                TRANSITIONS: [1,   63,    77,  90, 188, 245,  293,  303,  330, 356, 387, 9999]
            )
        case .Wang100:
            return MTModel(
                M: [0, 0.3, 0.45, 0.54, 0.7, 0.3, 0.37, 0.45, 0.57, 0.72, 0.8, 0.57],
                TRANSITIONS: [1,   56,   63,  77,  90,  245, 284,   293, 303,  330,  355,  380, 9999]
            )
        case .Wang10:
            return MTModel(
                M: [0, 0.27, 0.4, 0.7, 0.4, 0.2, 0.3, 0.4, 0.4, 0.2, 0.4],
                TRANSITIONS: [1,   63,  77,  90, 188, 245, 293, 303,  330, 355,  380]
            )
        }
    }
}
