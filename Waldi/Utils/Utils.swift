//
//  Utils.swift
//  Waldi
//
//  Created by Samuel Rutherford on 5/7/25.
//

import Foundation
import MapKit

class Utils {
    
    public static func distToKmMiles(distance:CLLocationDistance?, isMiles:Bool = false) -> String {
        guard let dist = distance else {
            return ""
        }
        if (isMiles) {
            if (dist < 1609){
                return String(dist * 3.281 ) + " ft"
            }
            return String(dist / 1609 ) + " mi"
        }
        if (dist < 1000){
            return String(dist) + " m"
        } else {
            return String(dist/1000) + " km"
        }
    }
}
