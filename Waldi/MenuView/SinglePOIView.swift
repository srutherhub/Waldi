//
//  SinglePOIView.swift
//  Waldi
//
//  Created by Samuel Rutherford on 5/7/25.
//book.closed

import SwiftUI

struct SinglePOIView: View {
    @Binding var POI:CustomMapItem?
    
    var body: some View {
        if POI != nil {
            VStack {
                HStack{
                    Spacer()
                    Button("",systemImage: "xmark.circle.fill") {
                        POI = nil
                    }
                }.padding(4)
                    Text(POI?.mapItem.name ?? "error")
                    Text("\(POI?.time)")
                    Text(Utils.distToKmMiles(distance: POI?.distance))
            }
            .frame(maxWidth:.infinity)
            .background(Color.white)
            .padding(8)
            .cornerRadius(16)
            
            
        }else {
            EmptyView()
        }
    }
}

