//
//  MenuModel.swift
//  Waldi
//
//  Created by Samuel Rutherford on 5/10/25.
//

import Foundation
import MapKit

struct SFilterButton:Identifiable {
    let id = UUID()
    let label:String
    let icon:String
}

enum EMenuOptions:String,CaseIterable {
    case coffee = "Coffee"
    case restaurants = "Restaurants"
    case parks = "Parks"
    case museums = "Museums"
    case shopping = "Shopping"
    case groceries = "Groceries"
    case atm = "ATM"
    
    var icon: String {
        switch self {
        case .coffee: return "cup.and.saucer"
        case .restaurants: return "fork.knife"
        case .shopping: return "bag"
        case .groceries: return "cart"
        case .parks: return "tree"
        case .museums: return "paintpalette"
            case .atm: return "dollarsign.bank.building"        }
    }
    
    var query:[MKPointOfInterestCategory] {
        switch self {
        case .coffee: return [.cafe,.bakery]
        case .restaurants: return [.restaurant]
        case .shopping: return [.store]
        case .groceries: return [.foodMarket]
        case .parks: return [.park,.beach,.nationalPark,.hiking]
        case .museums: return [.museum,.nationalMonument]
        case .atm: return [.bank,.atm]
        }
    }
}

enum EDistOptions:NSInteger, CaseIterable, Identifiable {
    case m500=500
    case m1000=1000
    case m2000=2000
    case m3000=3000
    case m5000=5000
    case miQuarter=25
    case miHalf=50
    case mi1=100
    case mi2=200
    case mi3=300
    
    var id: Int { rawValue }
    
    var desc: String {
        switch self {
        case .m500: return "500m"
        case .m1000: return "1000m"
        case .m2000: return "2000m"
        case .m3000: return "3000m"
        case .m5000: return "5000m"
        case .miQuarter: return "1/4 mi"
        case .miHalf: return "1/2 mi"
        case .mi1: return "1 mi"
        case .mi2: return "2 mi"
        case .mi3: return "3 mi"
        }
    }
    
    var distInM: NSInteger {
        switch self {
        case .m500: return 500
        case .m1000: return 1000
        case .m2000: return 2000
        case .m3000: return 3000
        case .m5000: return 5000
        case .miQuarter: return 402 
        case .miHalf: return 804
        case .mi1: return 1609
        case .mi2: return 3218
        case .mi3: return 4828
        }
    }
    
    static func getOptions() -> [EDistOptions] {
        if (Utils.isMetric) {
            return [.m500,.m1000,.m2000,.m3000,.m5000]
        } else {
            return [.miQuarter,.miHalf,.mi1,.mi2,.mi3]
        }
    }
}
