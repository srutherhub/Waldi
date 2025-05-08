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

enum EMenuOptions:String,CaseIterable {
    case coffee = "Coffee"
    case restaurants = "Restaurants"
    case shopping = "Shopping"
    case groceries = "Groceries"
    case parks = "Parks"
    case museums = "Museums"
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
        case .coffee: return [MKPointOfInterestCategory.cafe,MKPointOfInterestCategory.bakery]
        case .restaurants: return [MKPointOfInterestCategory.restaurant]
        case .shopping: return [MKPointOfInterestCategory.store]
        case .groceries: return [MKPointOfInterestCategory.foodMarket]
        case .parks: return [MKPointOfInterestCategory.park,MKPointOfInterestCategory.beach,MKPointOfInterestCategory.marina]
        case .museums: return [MKPointOfInterestCategory.museum]
        case .atm: return [MKPointOfInterestCategory.bank,MKPointOfInterestCategory.atm]
        }
    }
}

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
    }
    
}

struct MenuView: View {
    @ObservedObject var AppMapData:MapModel
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing:4){
                    ForEach(EMenuOptions.allCases,id:\.self) { option in
                        Button(action:{
                            AppMapData.SelectedMenuItem = option.rawValue
                            Task {
                                await AppMapData.getNearbyLocations(for:option)
                            }
                        }){
                            Label(option.rawValue, systemImage: option.icon)
                        }.buttonStyle(SelectedButtonStyle(isSelected: AppMapData.SelectedMenuItem == option.rawValue))
                        
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
                    AppMapData.setDisplayMapItems(cat: AppMapData.SelectedMenuItem)
                }.padding(2).accentColor(Color.black)
                    .background(Color.yellow)
                    .clipShape(.capsule)
                
            }
        }

    }
}


