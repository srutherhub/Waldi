//
//  POIListView.swift
//  Waldi
//
//  Created by Samuel Rutherford on 5/7/25.
//

import SwiftUI

struct POIListView: View {
    @Binding var POIList: [CustomMapItem]
    
    var body: some View {
        ForEach(POIList) {item in
            Text(item.mapItem.description)
        }
    }
}

