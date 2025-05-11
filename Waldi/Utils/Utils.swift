//
//  Utils.swift
//  Waldi
//
//  Created by Samuel Rutherford on 5/7/25.
//

import Foundation
import MapKit

final class Utils {
    static var isMetric = getLocale()
    
    //Return formatted string of distance, convert to miles if necessary
    public static func distToKmMiles(distance:CLLocationDistance?) -> String {
        guard let dist = distance else {
            return ""
        }
        if (!self.isMetric) {
            return String(format: "%.2f", dist / 1609 ) + " mi"
        } else {
            return String(format: "%.0f", dist) + " m"
        }
    }
    
    //Return true for metric, false for anything else
    public static func getLocale() -> Bool{
        let locale = Locale.current
        if (locale.measurementSystem == .us) {
            return false
        }else {
            return true
        }
    }
    
    public static func secondsToMinutes(time:TimeInterval?) -> String {
        
        guard let input = time else {
            return ""
        }
            
        let minutes = Int(input)/60
        let seconds = Int(input) % 60
        
        return "\(minutes) min \(seconds) sec"
        
    }
}
