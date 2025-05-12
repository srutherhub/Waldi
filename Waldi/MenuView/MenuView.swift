//
//  MenuView.swift
//  IOS Project
//
//  Created by Samuel Rutherford on 5/4/25.
//

import SwiftUI
import MapKit

struct MenuView: View {
    @ObservedObject var AppMapData:MapModel
    let DistanceMenuOptions = EDistOptions.getOptions()
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing:4){
                    ForEach(EMenuOptions.allCases,id:\.self) { option in
                        Button(action:{
                            AppMapData.SelectedMenuItem = option
                            Task {
                                await AppMapData.getNearbyLocations()
                            }
                        }){
                            Label(option.rawValue, systemImage: option.icon)
                        }.buttonStyle(SelectedButtonStyle(isSelected: AppMapData.SelectedMenuItem == option))
                        
                    }
                }
            }
            HStack{
                Spacer()
                Picker("Distance", selection: $AppMapData.SelectedDistance) {
                    ForEach(DistanceMenuOptions) {option in
                        Text(option.desc).tag(option)
                    }
                }.pickerStyle(.menu)
                    .padding(2)
                    .background(Color("PrimaryColor"))
                    .tint(Color.black)
                    .clipShape(.capsule)
                    .onChange(of:AppMapData.SelectedDistance){
                    AppMapData.setDisplayMapItems(cat: AppMapData.SelectedMenuItem.rawValue)
                }
                
            }
        }.padding(.horizontal,4)

    }
}

struct SelectedButtonStyle:ButtonStyle {
    var isSelected:Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .foregroundColor(isSelected ?  Color.black : Color("PrimaryFontColor"))
            .background(isSelected ? Color("PrimaryColor") : Color("PrimaryBackgroundColor"))
            .clipShape(.capsule)
    }
}
