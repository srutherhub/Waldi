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

enum EMenuOptions:String, RawRepresentable {
    case coffee = "Coffee"
    case restaurants = "Restaurants"
    case takeout = "Takeout"
    case shopping = "Shopping"
    case groceries = "Groceries"
    case parks = "Parks"
    case museums = "Museums"
}

let AMenuItems: [SFilterButton] = [
    SFilterButton(label:EMenuOptions.coffee.rawValue, icon:"cup.and.saucer"),
    SFilterButton(label:EMenuOptions.restaurants.rawValue, icon:"fork.knife"),
    SFilterButton(label:EMenuOptions.takeout.rawValue, icon:"takeoutbag.and.cup.and.straw"),
    SFilterButton(label:EMenuOptions.shopping.rawValue, icon:"bag"),
    SFilterButton(label:EMenuOptions.groceries.rawValue, icon:"cart"),
    SFilterButton(label:EMenuOptions.parks.rawValue, icon:"tree"),
    SFilterButton(label:EMenuOptions.museums.rawValue, icon:"paintpalette"),
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
    @ObservedObject var AppMapData:MapModel
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing:4){
                    ForEach(AMenuItems) { option in
                        Button(action:{
                            if (AppMapData.SelectedMenuItem == option.label) {
                                AppMapData.SelectedMenuItem = nil
                            }else {
                                AppMapData.SelectedMenuItem = option.label
                            }
                            Task {
                               await AppMapData.getNearbyLocations(for:option.label)
                            }
                        }){
                            Label(option.label, systemImage: option.icon)
                        }.buttonStyle(SelectedButtonStyle(isSelected: AppMapData.SelectedMenuItem == option.label))
                        
                    }
                }.padding(.horizontal)
            }
            HStack{
                Spacer()
                Picker("Minutes", selection: $AppMapData.Minutes) {
                    ForEach(ETimeOptions.allCases) {option in
                        Text(option.desc).tag(option)
                    }
                }.onChange(of:AppMapData.Minutes){
                    AppMapData.setDisplayMapItems(cat: String(AppMapData.SelectedMenuItem!))
                }.padding(2).accentColor(Color.black)
                    .background(Color.yellow)
                    .clipShape(.capsule)
                
            }}

    }
}


