//
//  MapModel.swift
//  IOS Project
//
//  Created by Samuel Rutherford on 5/4/25.
//

import Foundation
import MapKit

struct CustomMapItem: Identifiable, Equatable {
    var id = UUID()
    var mapItem:MKMapItem
    var distance:CLLocationDistance?
    var time:TimeInterval
}

class MapModel:ObservableObject {
    @Published var UserCoords:CLLocationCoordinate2D?
    @Published var SelectedMenuItem:String?
    @Published var Minutes:ETimeOptions
    @Published var DisplayMapItems:[CustomMapItem]
    private var MapItemsCache: [String:[CustomMapItem]]
    
    init(UserCoords:CLLocationCoordinate2D?=nil, SelectedMenuItem:String? = EMenuOptions.coffee.rawValue,Minutes:ETimeOptions = .fifteen,MapItemsCache:[String:[CustomMapItem]] = [:], DisplayMapItems:[CustomMapItem] = []) {
        self.UserCoords = UserCoords
        self.SelectedMenuItem = SelectedMenuItem
        self.Minutes = Minutes
        self.MapItemsCache = MapItemsCache
        self.DisplayMapItems = DisplayMapItems
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
    func getNearbyLocations(for query: String) async {
        var queryResults:[MKMapItem] = []
        
        guard let userCoords = self.UserCoords else {
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: userCoords, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        let search = MKLocalSearch(request: request)
        let response = try? await search.start()
        queryResults = response?.mapItems ?? []
        if (isNewQuery(query: query)) {
            self.MapItemsCache[query] = await getLocationsWalkingDistance(mapItems:queryResults)
        }
        setDisplayMapItems(cat: query)
    }
    
    //Get walking distance and times of locations
    private func getLocationsWalkingDistance(mapItems: [MKMapItem]) async ->[CustomMapItem] {
        var output:[CustomMapItem]? = []
        
        let delayBetweenRequests: TimeInterval = 0.15
        guard let userCoords = self.UserCoords else {
            return []
        }
        let userLocation = CLLocation(latitude: userCoords.latitude, longitude: userCoords.longitude)
        
        let sortedMapItems = mapItems.sorted { item1, item2 in
            guard let location1 = item1.placemark.location, let location2 = item2.placemark.location else {
                return false
            }
            let dist1 = userLocation.distance(from: location1)
            let dist2 = userLocation.distance(from: location2)
            return dist1 < dist2
        }
        var count = 0
        for item in sortedMapItems {
            count+=1
            if (count>15) {break}
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate:userCoords))
            request.destination = item
            request.transportType = .walking
            request.requestsAlternateRoutes = false
            let directions = MKDirections(request:request)
            directions.calculate {response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let route = response?.routes.first else {
                    print("No routes found.")
                    return
                }
                output?.append(CustomMapItem(mapItem:item,distance: route.distance,time:route.expectedTravelTime/60))
                
            }
            try? await Task.sleep(nanoseconds: UInt64(delayBetweenRequests * 1_000_000_000))
        }
        return output ?? []
    }
    
    func isNewQuery(query:String) ->Bool {
        if (self.MapItemsCache[query] == nil) {
            return true
        }
        return false
    }
    
    func setDisplayMapItems(cat:String) {
        self.DisplayMapItems = []
        var output:[CustomMapItem] = []
        guard self.MapItemsCache[cat] != nil else {
            return
        }
        for (item) in self.MapItemsCache {
            if (item.key == cat) {
                for (mapItem) in item.value {
                    if (mapItem.time <= TimeInterval(self.Minutes.rawValue)) {
                        output.append(mapItem)
                    }}
                }
            }
        self.DisplayMapItems = output
        }
}

