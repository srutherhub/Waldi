//
//  MapModel.swift
//  IOS Project
//
//  Created by Samuel Rutherford on 5/4/25.
//

import Foundation
import MapKit

class MapModel:ObservableObject {
    @Published var UserCoords:CLLocationCoordinate2D?
    @Published var SelectedMenuItem:String?
    @Published var MapItems:[MKMapItem]
    @Published var Minutes:ETimeOptions
    
    init(UserCoords:CLLocationCoordinate2D?=nil, SelectedMenuItem:String?=nil, MapItems:[MKMapItem]=[],Minutes:ETimeOptions = .fifteen) {
        self.UserCoords = UserCoords
        self.SelectedMenuItem = SelectedMenuItem
        self.MapItems = MapItems
        self.Minutes = Minutes
    }
    
    //Retrieves users current location
    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        do {
            let update = try await updates.first{$0.location?.coordinate != nil}
            return update?.location?.coordinate
        } catch {
            return nil
        }
    }

    //Search for nearby point of interest using natural language
    func getNearbyLocations(for query: String) async -> [MKMapItem] {
        guard let userCoords = self.UserCoords else {
            return []
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: userCoords, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        )
        let search = MKLocalSearch(request: request)
        let response = try? await search.start()
        return response?.mapItems ?? []
    }
}

