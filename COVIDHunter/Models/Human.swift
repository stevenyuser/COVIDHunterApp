//
//  Human.swift
//  COVIDHunter
//
//  Created by Steven Yu on 1/29/22.
//

import Foundation

enum HealthState {
    case HEALTHY
    case INFECTED
    case INFECTED_ASYMPTOMATIC
    case ASYMPTOMATIC
    case CONTAGIOUS
    case IMMUNE
    case VACCINATED
}

struct Person {
    var state = HealthState.HEALTHY            // healthy,  uninfected
    var day_infected = -1    // unassigned as no infection
    var day_infectious = -1  // unassigned as not yet infectious
    var variant = false          // variant of virus with which person is infected
    var traveler = false     // returning travellers are allowed to violate r value level
}
