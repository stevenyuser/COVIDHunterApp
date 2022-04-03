//
//  SimulationViewModel.swift
//  COVIDHunter
//
//  Created by Steven Yu on 1/29/22.
//

import Foundation
import GameplayKit

// contains the variables needed to run the simulation
class SimulationViewModel: ObservableObject {
    
    // USER EDITABLE PARAMS
    
    // general params
    @Published var START_MONTH = 1 // Start simulation on January 1st (use normal 1-12 representation for month here)
    @Published var NUM_DAYS = 730 // maximum number of days simulated (2 years)
    @Published var FIRST_INFECTION_DAY = 45 // Day first infection is imported into population.
    @Published var POPULATION = 8654622 // Population size to simulate (in this case Swiss population in 2020)
    @Published var MIN_INCUBATION_DAYS = 1 // minimum number of days from being infected to being contagious
    @Published var MAX_INCUBATION_DAYS = 5 // maximum number of days from being infected to being contagious
    @Published var MAX_VICTIMS = 25 // maximum number of folks one person can infect (minimum is always 0). Assumes a normal distribution
    @Published var TRAVEL_SICK_RATE = 15 // percent chance a traveler returning from a trip abroad is contagious and undetected
    @Published var TRAVELERS_PER_DAY = 100 // Number of travelers entering country from abroad every day as of first travel day
    @Published var FIRST_TRAVEL_DAY = 45 // Point at which potentially infected travelers (some of whom are contagious) start entering country
    @Published var LAST_TRAVEL_DAY = 9999 // Point at which borders are closed/all travelers placed in strict quarantine
    // Intrinsic r value excluding immunity at 15 degree C for a given population -- average number of folks an infected person gives the virus to (but some may already be immune). This is a function of the infectiousnessof the virus given normal (unaware of virus) population behavior and 15 degree C temp.
    @Published var X = 0.02780 //the hospitalizations-to-cases ratio, for CRW-100% = 4.288% for CTC-100% = 2.780%
    @Published var Y = 0.01739 //the deaths-to-cases ratio, for CRW-100% = 2.730% for CTC-100% = 1.739%
    
    // delta/omnicron, first variant probably disappears afterwards
    @Published var R0_INTRINSIC = 2.7 //https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1008031#pcbi.1008031.s001 // first variant
    @Published var R0_INTRINSIC_VARIANT1 = 6.0 // second variant
    @Published var ASYMPTOMATIC_PERCENTAGE = 0  // Percentage of infections that are asymptomatic relative to symptomatic.  Asymptomatic folks gain immunity but are less contagious
    
    @Published var IMPORTED_MUTATION_RATE = 0    // Percentage of imported cases that are of mutated variant 1 (as of FIRST_VARIANT_DAY).  Set to 0 to disable mutations
    @Published var FIRST_VARIANT_DAY = 345  // First day a traveller can bring in the mutated virus, activates variant on this day
    
    // two different variants (3rd and 4th variant) cases you cannot capture or see
    @Published var R0_ASYMPTOMATIC = 2.0
    @Published var R0_ASYMPTOMATIC_VARIANT1 = 3.0
    
    // vaccine params
    @Published var ENABLE_VACCINATIONS = true
    @Published var FIRST_VACCINATION_DAY = 380 // note:  the model assumes that you gain immunity immediately after vaccination.   Starting 2 weeks later accounts for the fact that in reality you need to wait 2 weeks for partial immunity.
    @Published var VACCINATION_RATE = 0.3     // Percentage of population vaccinated per day
    
    
    
    // model choice
    @Published var selectedModel: ModelEnum = ModelEnum.CTC
    
    // all models require m and transition
    // M and transitions are linked together, each index represents a pair example: (0, 1) (0.45, 58)
    let M =           [0, 0.45, 0.7,  0.7, 0.65, 0.63, 0.5, 0.355, 0.6, 0.7, 0.7, 0.71, 0.73, 0.73, 0.6, 0.35, 0.6]
    let TRANSITIONS = [1,   58,  77,  118,  132,  151, 174, 245, 284, 303, 320,  330,  356,  387, 425,  475,  505, 9999] // Day
    // add the 9999 at the end of the code, after the user adds params
    
    
    // brazil model
    @Published var brazilModel: BrazilModel?
    @Published var harvardModel: HarvardModel?
    @Published var ctcModel: CTCModel?
    @Published var wangModel: WangModel?
    // ADD OTHER MODELS
    
    // weather stuff - change later
    let TEMP_MONTHLY_HIGH = [4, 6, 11, 15, 19, 23, 25, 24, 20, 15, 9, 5]
    let TEMP_November_HIGH = [13, 15, 12, 12, 8, 8, 8, 3, 6, 6, 9, 6, 5, 6, 4, 5, 2, 4, 3, 6, 7, 7, 8, 9, 9, 10, 9, 7, 4, 5]
    let TEMP_MONTHLY_LOW = [-1, 0, 3,  6, 10, 13,  15, 15, 12, 8,  3, 0]
    // Relative humidity https://www.worlddata.info/europe/switzerland/climate.php
    let Humidity_MONTHLY_HIGH = [80, 77, 71, 69, 71, 70, 68, 72, 76, 80, 80, 80]
    
    @Published var resultModel: ResultModel?
    
    func run() async  {
        runSimulation()
    }
    
    // simulation code
    func runSimulation() {
        DispatchQueue.global().async { [self] in
            
        // denominator for calculated actual and intrinsic R value
        var people = [Person]()
        var victims = [Int](repeating: 0, count: NUM_DAYS)
        var infections = [Int](repeating: 0, count: NUM_DAYS)
        var spreaders = [Int](repeating: 0, count: NUM_DAYS)
        
        var total_infections = 0                                   // total infections across the pandemic
        var total_infections_variant = 0
        var total_travelers = 0
        var total_vaccinated = 0
        
        // results arrays
        var newlyInfected0: [Int] = [0]
        var newlyInfected1: [Int] = [0]
        var hospitalizationsNumber: [Double] = [0]
        var deathsNumber: [Double] = [0]
        
        
        init_people(count: POPULATION)
        people[0].state = HealthState.INFECTED  // infect a person
        people[0].day_infected = FIRST_INFECTION_DAY      // first day of simulation
        people[0].day_infectious = FIRST_INFECTION_DAY+5  // start from day first person is infectious
        
        var free_person_ptr = 1  // pointer to first healthy person in array of people (runtime optimization)
        var sick_person_ptr = 0  // pointer to last still sick person in array of people (runtime optimization)
        var done = false
        
        var weekly_spreaders = 0
        var weekly_victims = 0
        var weekly_infections = 0
        
        var vaccinations_per_day = Int(Double(POPULATION) * VACCINATION_RATE/100)
        var vaccinations_done = false
        
        var phase = 0 // current phase of pandemic
        var CRWphase = 0
        var VariationInCRW = 0.0
        var CRWfactor = 0.0
        var day = 0 // current day
        var dayInYear=0
        
        var month = START_MONTH-1 // convert month to a 0-11 representation for internal use
        // for inputs, the user should check off the plots the user wants (have default plots)
        // legend, have variants seperate
        print("Day, Uninfected, Daily Cases (Variant 1), Daily Cases (Variant 2), Daily Hospitalizations, Daily Deaths, Active Cases, Contagious, Immune, Total Vaccinated, asymptomatic Cases, Travelers, R0, Ce(t), M(t), R0*(1-M(t)), R0*Ce(t), R(t)=R0*Ce(t)*(1-M(t)), Observed R(t)")
        
        // main execution unit
        
        while (!done && day<NUM_DAYS) {
            // Check for a transition to a new phase of behavior
            if (day==TRANSITIONS[phase+1]) {
                phase+=1
            }
            // Check for a transition to a new CRW
            if (day%365 == 0) {
                dayInYear=0 // start new year
            } else {
                dayInYear+=1
            }
            
            // default is harvard, calculated and ignored in other models
            if let safeHarvardModel = harvardModel {
                if (dayInYear==safeHarvardModel.CRW_Harvard_TRANSITIONS[CRWphase+1]) {
                    if ((CRWphase+1) % (safeHarvardModel.CRW_Harvard.count-1) == 0) {
                        CRWphase = 0;
                        VariationInCRW = safeHarvardModel.CRW_Harvard[CRWphase] - safeHarvardModel.CRW_Harvard[safeHarvardModel.CRW_Harvard.count-1];
                    } else {
                        CRWphase+=1;
                        VariationInCRW = safeHarvardModel.CRW_Harvard[CRWphase] - safeHarvardModel.CRW_Harvard[CRWphase-1];
                    }
                }
            }
            CRWfactor = 1+VariationInCRW
            //print("\(day), \(dayInYear), \(CRWphase), \(VariationInCRW), \(CRW_Harvard[CRWphase]), \(CRWfactor)")
            done = process_people(day: day, phase: phase, CRWfactor: CRWfactor) // main functions
            day+=1
            if (day%30 == 0) {
                month+=1 // start new month (note approximates all months as having 30 days)
                if (month%12 == 0) {
                    month=0; // start new year
                }
            }
        }
        
        if (!done) {
            print("COVIDHunter completes after \(NUM_DAYS) days. STOP Reason = Completed requested number of days (disease is still active)")
        } else {
            print("COVIDHunter completes after \(day) days. STOP Reason = No more active disease in population.")
        }
        
        let infected = String(format: "%2.3f", (Double(total_infections))/Double(POPULATION)*100.0)
        let infected_variant = String(format: "%2.3f", (Double(total_infections_variant))/Double(POPULATION)*100.0)
        let immune   = String(format: "%2.3f", Double(sick_person_ptr)/Double(POPULATION)*100.0)
        let vaccinated = String(format: "%2.3f", Double(total_vaccinated)/Double(POPULATION)*100.0)
        print("total infected_base=\(infected)% total_infected_variant=\(infected_variant) total immune=\(immune)%  total vaccinated=\(vaccinated)%")
        
        // initializing resultsModel
            DispatchQueue.main.async {
        resultModel = ResultModel(newlyInfected0: newlyInfected0, newlyInfected1: newlyInfected1, hospitalizationsNumber: hospitalizationsNumber, deathsNumber: deathsNumber, totalInfections: total_infections)
        }
            
        
        // nested functions
        
        func pick_victim(spreader: Int) -> Int {
            var person = 0
            repeat {
                person = Int.random(in: 0..<POPULATION)
            } while person == spreader
            return person
        }
        
        func pick_number_of_victims(traveler: Bool, day: Int, symptomatic: Bool, R0Mt: Double) -> Int {
            
            let random = GKRandomSource()
            let result = GKGaussianDistribution(randomSource: random, lowestValue: 0, highestValue : MAX_VICTIMS)
            
            if (symptomatic) {
                spreaders[day]+=1
                var new_symptomatic_victims = result.nextInt()
                
                if (traveler==false && Double(victims[day]+new_symptomatic_victims)/(Double(spreaders[day]+1)) > R0Mt) {
                    new_symptomatic_victims = 0;   // our R0 value is currently too high so done infecting for the day (except for travelers)
                } else {
                    victims[day]+=new_symptomatic_victims
                }
                return new_symptomatic_victims
            } else {
                var new_asymptomatic_victims = (result.nextInt() * ASYMPTOMATIC_PERCENTAGE)/100
                if (traveler==false && Double(victims[day]+new_asymptomatic_victims)/(Double(spreaders[day]+1)) > R0Mt) {
                    new_asymptomatic_victims = 0;   // our R0 value is currently too high so done infecting for the day (except for travelers)
                }
                
                return new_asymptomatic_victims
            }
        }
        
        func incubation_period() -> Int {
            let random = GKRandomSource()
            let result = GKGaussianDistribution(randomSource: random, lowestValue: MIN_INCUBATION_DAYS, highestValue : MAX_INCUBATION_DAYS)
            return result.nextInt()
        }
        
        func compute_temperature_scaling(month: Int, model: BrazilModel) -> Double {
            var temp = Double(TEMP_MONTHLY_HIGH[month])
            temp = temp > model.TEMP_SCALING_CEILING ? model.TEMP_SCALING_CEILING : temp
            temp = temp < model.TEMP_SCALING_FLOOR ? model.TEMP_SCALING_FLOOR : temp
            var Ct = 1 + ((15 - temp)*model.TEMP_SCALING_FACTOR) // 10 < temp < 26
            Ct = Ct >= 0.0 ? Ct : 0.0 // negative temperature coefficient does not make sense.
            return Ct
        }
        
        func compute_temperature_scaling_CTC(month: Int, day: Int, model: CTCModel) -> Double {
            /*if ((day >= 305) && (day <= 334)) {
             var temp = Double(TEMP_November_HIGH[day-305])
             temp = temp > TEMP_SCALING_CEILING_CTC ? TEMP_SCALING_CEILING_CTC : temp
             temp = temp < TEMP_SCALING_FLOOR_CTC ? TEMP_SCALING_FLOOR_CTC : temp
             var Ct = 1 + ((15 - temp)*TEMP_SCALING_FACTOR_CTC) // 10 < temp < 26
             Ct = Ct >= 0.0 ? Ct : 0.0 // negative temperature coefficient does not make sense.
             return Ct
             } else {*/
            var temp = Double(TEMP_MONTHLY_HIGH[month])
            temp = temp > model.TEMP_SCALING_CEILING_CTC ? model.TEMP_SCALING_CEILING_CTC : temp // coarsely grained
            temp = temp < model.TEMP_SCALING_FLOOR_CTC ? model.TEMP_SCALING_FLOOR_CTC : temp
            var Ct = 1 + ((15 - temp)*model.TEMP_SCALING_FACTOR_CTC) // 10 < temp < 26
            Ct = Ct >= 0.0 ? Ct : 0.0 // negative temperature coefficient does not make sense.
            return Ct
            //}
            
        }
        
        func compute_Wang_scaling_daily(month: Int, day: Int, model: WangModel) -> Double {
            if ((day >= 305) && (day <= 334)) {
                let temp = Double(TEMP_November_HIGH[day-305])
                let hum = Double(Humidity_MONTHLY_HIGH[month])
                var Ct = 1 + ((15 - temp)*model.Wang_TEMP_SCALING_FACTOR) + ((70 - hum)*model.Wang_TEMP_SCALING_FACTOR)
                Ct = Ct >= 0.0 ? Ct : 0.0 // negative temperature coefficient does not make sense.
                //print("\(temp)")
                return Ct
            } else {
                let temp = Double(TEMP_MONTHLY_HIGH[month])
                let hum = Double(Humidity_MONTHLY_HIGH[month])
                var Ct = 1 + ((15 - temp)*model.Wang_TEMP_SCALING_FACTOR) + ((70 - hum)*model.Wang_TEMP_SCALING_FACTOR)
                Ct = Ct >= 0.0 ? Ct : 0.0 // negative temperature coefficient does not make sense.
                //print("\(temp)")
                return Ct
            }
            
        }
        
        func compute_Wang_scaling(month: Int, model: WangModel) -> Double {
            let temp = Double(TEMP_MONTHLY_HIGH[month])
            let hum = Double(Humidity_MONTHLY_HIGH[month])
            var Ct = 1 + ((15 - temp)*model.Wang_TEMP_SCALING_FACTOR) + ((70 - hum)*model.Wang_TEMP_SCALING_FACTOR)
            Ct = Ct >= 0.0 ? Ct : 0.0 // negative temperature coefficient does not make sense.
            return Ct
        }
        
        func process_people(day: Int, phase: Int, CRWfactor: Double) -> Bool {
            var infected_original = 0
            var infected_variant1 = 0
            var infected_asymptomatic = 0
            var contagious = 0
            var asymptomatic = 0
            var illegal = 0
            var immune = 0
            var newly_infected = [0, 0] // WHICH ONE?
            var first_sick_person = POPULATION
            
            let Ct: Double
            let R0Mt: Double
            
            // switch based on model
            // probably don't force unwrap
            switch selectedModel {
            case ModelEnum.Brazil:
                Ct = compute_temperature_scaling(month: month, model: brazilModel ?? BrazilModel())
                R0Mt = (day >= FIRST_INFECTION_DAY) ? R0_INTRINSIC * (1.0-M[phase]) * Ct : 0.0    //print("\(M[phase])")

            case ModelEnum.Wang:
                Ct = compute_Wang_scaling(month: month, model: wangModel ?? WangModel())
                R0Mt = (day >= FIRST_INFECTION_DAY) ? R0_INTRINSIC * (1.0-M[phase]) * Ct : 0.0    //print("\(M[phase])")

            case ModelEnum.CTC:
                Ct = compute_temperature_scaling_CTC(month: month, day: day, model: ctcModel ?? CTCModel())
                R0Mt = (day >= FIRST_INFECTION_DAY) ? R0_INTRINSIC * (1.0-M[phase]) * Ct : 0.0    //print("\(M[phase])")

            case ModelEnum.Harvard:
                // ct is optional
                Ct = 0.0
                R0Mt = (day >= FIRST_INFECTION_DAY) ? Double(R0_INTRINSIC) * (1.0-M[phase]) * CRWfactor : 0.0
            }
            
            // switch based on model
            
            // Compute R0Mt which is R0 including both mitigation measures (1-M) and the temperature coefficient (Ct)
            // this is for Swiss, won't change based on Model, static
            let R0Mt_asymptomatic = (day >= FIRST_INFECTION_DAY) ? R0_ASYMPTOMATIC * (1.0-M[phase]) * Ct : 0.0
            let R0Mt_variant1 = (day >= FIRST_VARIANT_DAY) ? R0_INTRINSIC_VARIANT1 * (1.0-M[phase]) * Ct : 0.0
            let R0Mt_asymptomatic_variant1 = (day >= FIRST_VARIANT_DAY) ? R0_ASYMPTOMATIC_VARIANT1 * (1.0-M[phase]) * Ct : 0.0
            
            // compute weekly victims and spreaders based on last 7 days
            weekly_victims=0
            weekly_spreaders=0
            weekly_infections=0
            for i in day-7..<day-1 {
                if (i>=0) {
                    weekly_victims += victims[i]
                    weekly_spreaders += spreaders[i]
                    weekly_infections += infections[i]
                }
            }
            
            // EVERYTHING DOWN HERE IS OKAY, DON'T DEPEND ON MODEL
            
            // compute true R value based on the new infections and spreaders in the past week.  This value is for informative purposes only (does not impact sim)
            let Rt:Double = weekly_spreaders != 0 ? Double(weekly_infections)/Double(weekly_spreaders) : 0.0
            
            // clustering of population, mantain status of each individual
            // iterate though all sick folks in the population and update their state
            for i in sick_person_ptr..<free_person_ptr {
                switch people[i].state {
                
                case HealthState.INFECTED_ASYMPTOMATIC:
                    if (i < first_sick_person) {
                        first_sick_person = i
                    }
                    infected_asymptomatic+=1
                    if (day >= people[i].day_infectious) {
                        people[i].state = .ASYMPTOMATIC;  // person is infected but asymptomatic
                    }
                case HealthState.INFECTED:
                    if (i < first_sick_person) {
                        first_sick_person = i
                    }
                    if (people[i].variant==true) {
                        infected_variant1+=1
                    } else {
                        infected_original+=1
                    }
                    if (day >= people[i].day_infectious) {
                        people[i].state = .CONTAGIOUS;   // person is now infectious
                    }
                case HealthState.ASYMPTOMATIC:
                    if (i < first_sick_person) {
                        first_sick_person = i
                    }
                    asymptomatic+=1
                    // determine number of people to spreaad the virus to
                    let victim_count = pick_number_of_victims(traveler: people[i].traveler, day: day, symptomatic: false, R0Mt: people[i].variant ? R0Mt_asymptomatic_variant1 : R0Mt_asymptomatic)
                    for _ in 0..<victim_count {
                        let victim = pick_victim(spreader: i)
                        if (people[victim].state == .HEALTHY) {
                            if (Int.random(in: 0..<100) < ASYMPTOMATIC_PERCENTAGE) {
                                newly_infected[people[i].variant==true ? 1 : 0] += infect_person(day: day, state: HealthState.INFECTED_ASYMPTOMATIC, variant: people[i].variant)
                            } else {
                                newly_infected[people[i].variant==true ? 1 : 0] += infect_person(day: day, state: HealthState.INFECTED, variant: people[i].variant)
                            }
                        }
                    }
                    
                    people[i].state = .IMMUNE    // this person is done being asymptomatic and is now immune
                case HealthState.CONTAGIOUS:
                    if (i < first_sick_person) {
                        first_sick_person = i
                    }
                    contagious+=1
                    // determine number of people to spreaad the virus to
                    let victim_count = pick_number_of_victims(traveler: people[i].traveler,  day: day, symptomatic: true, R0Mt: people[i].variant ? R0Mt_variant1 : R0Mt)
                    for _ in 0..<victim_count {
                        let victim = pick_victim(spreader: i)
                        if (people[victim].state == .HEALTHY) {
                            if (Int.random(in: 0..<100) < ASYMPTOMATIC_PERCENTAGE) {
                                newly_infected[people[i].variant==true ? 1 : 0] += infect_person(day: day, state: HealthState.INFECTED_ASYMPTOMATIC, variant: people[i].variant)
                            } else {
                                newly_infected[people[i].variant==true ? 1 : 0] += infect_person(day: day, state: HealthState.INFECTED, variant: people[i].variant)
                            }
                        }
                    }
                    
                    people[i].state = .IMMUNE   // this person is done infecting people and is now immune
                case HealthState.IMMUNE:
                    immune+=1
                case HealthState.VACCINATED:
                    break;
                default:
                    if (i < first_sick_person) {
                        first_sick_person = i
                    }
                    illegal+=1
                }
            }
            
            // bump sick_person_ptr (runtime optimiztion to avoid scanning from start of array)
            sick_person_ptr = first_sick_person==POPULATION ? sick_person_ptr : first_sick_person
            
            // Handle travelers who randomly return to population (if r value is 0.0 then no travellers either => disease not present anywhere)
            if (day>=FIRST_TRAVEL_DAY && day <= LAST_TRAVEL_DAY) {
                for _ in 0..<TRAVELERS_PER_DAY {
                    if (Int.random(in: 0..<100) < TRAVEL_SICK_RATE) {
                        let person = pick_victim(spreader: 0)
                        let virus_variant = day>=FIRST_VARIANT_DAY ? (Int.random(in: 0..<100) < IMPORTED_MUTATION_RATE) ? true : false : false
                        if (people[person].state == .HEALTHY) {
                            newly_infected[virus_variant==true ? 1 : 0] += infect_person(day: day, state: .INFECTED, variant:virus_variant)  // Assumes travellers are always contagious
                            total_travelers+=1
                        }
                    }
                }
            }
            
            // handle vaccinations. Once vaccinations start, vaccinated folks become immune
            if (ENABLE_VACCINATIONS==true && day>=FIRST_VACCINATION_DAY && !vaccinations_done) {
                var last_count = 0
                for _ in 0..<vaccinations_per_day  {
                    var person = pick_victim(spreader:0)
                    var count = 0
                    while people[person].state == .VACCINATED && count < 20 {   // pick a new person if already vaccinated
                        person = pick_victim(spreader:0)
                        count+=1
                    }
                    if (count==10 && last_count==20) {
                        vaccinations_done = true
                    } else {
                        if (people[person].state == .HEALTHY || people[person].state == .IMMUNE) {
                            people[person].state = .VACCINATED
                            total_vaccinated += 1
                        }
                    }
                    last_count = count
                }
            }
            
            let hospitalizations_number = String(format: "%2.3f", X * Double(newly_infected[0]+newly_infected[1]))
            let deaths_number = String(format: "%2.3f", Y * Double(newly_infected[0]+newly_infected[1]))
            let intrinsic_r_string = String(format: "%2.3f", R0_INTRINSIC)
            let phase_string = String(format: "%2.3f", R0_INTRINSIC*(1.0-M[phase]))
            let phase_temp_r_string = String(format: "%2.3f", R0Mt)
            let temp_r_string = String(format: "%2.3", R0_INTRINSIC*Ct)
            let actual_r_string = String(format: "%2.3f", Rt)
            let M_string = String(format: "%2.3f", M[phase])
            let C_string = String(format: "%2.3f", Ct)
            
            // print output per day in a graph, plot in a graph, values changed based on model
            // do multiple different plots (cases [], )
            newlyInfected0.append(newly_infected[0])
            newlyInfected1.append(newly_infected[1])
            hospitalizationsNumber.append((X * Double(newly_infected[0]+newly_infected[1])))
            deathsNumber.append((Y * Double(newly_infected[0]+newly_infected[1])))
            
            print("\(day+1), \(POPULATION-free_person_ptr), \(newly_infected[0]), \(newly_infected[1]), \(hospitalizations_number), \(deaths_number), \(infected_original), \(contagious), \(sick_person_ptr+immune), \(total_vaccinated),  \(asymptomatic), \(total_travelers), \(intrinsic_r_string), \(C_string), \(M_string), \(phase_string), \(temp_r_string), \(phase_temp_r_string), \(actual_r_string)")
            
            //print("Day, Uninfected, new infections base, active infections, contagious, asymptomatic, immune, travelers, R0i (intrinsic R0), R0i*Ct (intrinsic including migitation), R0i*Ct (temperature adjusted R0), R0i*Ct*(1-M) (temp adjusted R0 including mitigation), Rt (observed R number), new infections variant, vaccations")
            //print("\(day), \(POPULATION-free_person_ptr), \(newly_infected[0]), \(infected_original), \(contagious), \(asymptomatic), \(sick_person_ptr+immune), \(total_travelers), \(intrinsic_r_string), \(phase_string), \(temp_r_string), \(phase_temp_r_string), \(actual_r_string), \(newly_infected[1]), \(total_vaccinated)")
            
            return contagious+infected_original+infected_variant1+asymptomatic==0 && TRAVEL_SICK_RATE==0
        }
        
        func infect_person(day: Int,  state: HealthState, variant: Bool) -> Int {
            // note:  use 'free person pointer' vs 'victim' as a runtime optimization.  This prevents having to scan entire population for sick people.
            people[free_person_ptr].state = state // infect the victim if the person is not already infected
            people[free_person_ptr].day_infected = day  // infection date is today
            people[free_person_ptr].day_infectious = day + incubation_period()
            people[free_person_ptr].variant = variant
            if (state == .INFECTED) {
                infections[day] += 1   //   count as an actual infection
                if (variant) {
                    total_infections_variant += 1
                } else {
                    total_infections += 1
                }
            }
            free_person_ptr+=1
            return 1
        }
        
        func init_people(count: Int) {
            for  _ in 0..<count {
                people.append(Person())
            }
        }
            
        }
    }
}
