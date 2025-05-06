//
//  MapView.swift
//  IOS Project
//
//  Created by Samuel Rutherford on 5/4/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var AppMapData = MapModel()
    @State private var Position: MapCameraPosition = .userLocation(fallback: .automatic)
    let LocationManager = CLLocationManager()
    var body: some View {
        VStack{
            Map(position: $Position){
                UserAnnotation()
            }.tint(Color.black)
                .mapStyle(.standard(elevation: .realistic))
                .mapControls{MapUserLocationButton()
                    MapPitchToggle()
                }
                .onAppear{
                    LocationManager.requestWhenInUseAuthorization()
                    Task {
                        AppMapData.UserCoords = await AppMapData.getUserLocation()
                    }
                }
                .safeAreaInset(edge: .top){
                    MenuView(SelectedMenuItem:$AppMapData.SelectedMenuItem, SelectedTime: $AppMapData.Minutes)
                }

        }}

}


#Preview {
    MapView()
}
