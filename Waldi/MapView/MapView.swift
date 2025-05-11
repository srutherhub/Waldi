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
    @State private var SelectedPOI:CustomMapItem?
    
    let LocationManager = CLLocationManager()
    var body: some View {
        ZStack{
            Map(position: $Position){
                UserAnnotation()
                ForEach(AppMapData.DisplayMapItems) { annoMapItem in
                    Annotation(annoMapItem.mapItem.name ?? AppMapData.SelectedMenuItem.rawValue,coordinate: annoMapItem.mapItem.placemark.coordinate){
                        Image(systemName:"mappin.circle.fill").imageScale(.large)
                            .scaleEffect(SelectedPOI?.id == annoMapItem.id ? 1.5 : 1).animation(.smooth(duration: 0.1), value: SelectedPOI)
                            .foregroundStyle(SelectedPOI?.id == annoMapItem.id  ? Color.yellow : Color.black)
                            .onTapGesture {
                                SelectedPOI = annoMapItem
                                Task {
                                    if var poi = SelectedPOI {
                                        SelectedPOI = await poi.getLocationsWalkingDistance(POI: poi.mapItem)
                                    }
                                }
                            }

                    }
                }
            }.onChange(of: AppMapData.DisplayMapItems){
                if let region = AppMapData.getBoundingRegion() {
                    withAnimation {
                        Position = .region(region)
                    }
                }
            }
            VStack {
                Spacer()
                PointOfInterestView(POI:$SelectedPOI)
            }.padding(.bottom,4)
        }.tint(Color.black)
                .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
                .mapControls{
                    MapUserLocationButton()
                    MapPitchToggle()
                }
                .onAppear{
                    LocationManager.requestWhenInUseAuthorization()
                    Task {
                        MapModel.UserCoords = await AppMapData.getUserLocation()
                        await AppMapData.getNearbyLocations()
                    }
                }
                .safeAreaInset(edge: .top){
                    MenuView(AppMapData:AppMapData)
                }

        }

}

#Preview {
    MapView()
}
