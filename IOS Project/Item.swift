//
//  Item.swift
//  IOS Project
//
//  Created by Samuel Rutherford on 5/4/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
