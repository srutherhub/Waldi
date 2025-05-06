//
//  MenuView.swift
//  IOS Project
//
//  Created by Samuel Rutherford on 5/4/25.
//

import SwiftUI
import MapKit


struct SFilterButton:Identifiable {
    let id = UUID()
    let label:String
    let icon:String
}

let AMenuItems: [SFilterButton] = [
    SFilterButton(label:"Coffee", icon:"cup.and.saucer"),
    SFilterButton(label:"Restaurants", icon:"fork.knife"),
    SFilterButton(label:"Takeout", icon:"takeoutbag.and.cup.and.straw"),
    SFilterButton(label:"Shopping", icon:"bag"),
    SFilterButton(label:"Groceries", icon:"cart"),
    SFilterButton(label:"Parks", icon:"tree"),
    SFilterButton(label:"Museums", icon:"paintpalette"),

]

struct SelectedButtonStyle:ButtonStyle {
    var isSelected:Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .foregroundColor(Color.black)
            .background(isSelected ? Color.yellow : Color.white)
            .clipShape(.capsule)
    }
}

enum ETimeOptions:NSInteger, CaseIterable, Identifiable {
    case fifteen = 15
    case thirty = 30
    case fortyfive=45
    case sixty=60
    
    var id: Int { rawValue }
    
    var desc: String {
        switch self {
        case .fifteen: return "15 min"
        case .thirty: return "30 min"
        case .fortyfive: return "45 min"
        case .sixty: return "60 min"
        }
    }}

struct MenuView: View {
    @Binding var SelectedMenuItem:String?
    @Binding var SelectedTime:ETimeOptions
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing:4){
                    ForEach(AMenuItems) { option in
                        Button(action:{
                            if (SelectedMenuItem == option.label) {
                                SelectedMenuItem = nil
                            }else {
                                SelectedMenuItem = option.label
                            }
                        }){
                            Label(option.label, systemImage: option.icon)
                        }.buttonStyle(SelectedButtonStyle(isSelected: SelectedMenuItem == option.label))
                        
                    }
                }.padding(.horizontal)
            }
            HStack{
                Spacer()
                Picker("Minutes", selection: $SelectedTime) {
                    ForEach(ETimeOptions.allCases) {option in
                        Text(option.desc).tag(option)
                    }
                }.padding(2).accentColor(Color.black)
                    .background(Color.yellow)
                    .clipShape(.capsule)
                
            }}

    }
}


