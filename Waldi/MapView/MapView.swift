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
                ForEach(AppMapData.DisplayMapItems) { mapItem in
                    Marker(item:mapItem.mapItem)
                }
            }.onChange(of: AppMapData.DisplayMapItems){
                withAnimation(){
                    Position = .automatic
                }
            }
            }.tint(Color.black)
                .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
                .preferredColorScheme(.light)
                .mapControls{
                    MapUserLocationButton()
                    MapPitchToggle()
                    MapCompass()
                }
                .onAppear{
                    LocationManager.requestWhenInUseAuthorization()
                    Task {
                        AppMapData.UserCoords = await AppMapData.getUserLocation()
                        await AppMapData.getNearbyLocations(for:EMenuOptions.coffee)
                    }
                }
                .safeAreaInset(edge: .top){
                    MenuView(AppMapData:AppMapData)
                }

        }}

}


#Preview {
    MapView()
}
