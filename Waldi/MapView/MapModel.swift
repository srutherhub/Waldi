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
    var time:TimeInterval?
    var route:MKPolyline?
    var steps:[MKRoute.Step]?
    
    //Get walking distance and times of locations
    mutating func getLocationsWalkingDistance(POI:MKMapItem) async -> CustomMapItem {
        guard let userCoords = MapModel.UserCoords else {
            return self
        }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate:userCoords))
        request.destination = POI
        request.transportType = .walking
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request:request)
        do {
            let response = try await directions.calculate()
            if let route = response.routes.first {
                self.distance = route.distance
                self.time = route.expectedTravelTime
                self.route = route.polyline
                self.steps = route.steps
                return self
            }
        }catch{
            print(error.localizedDescription)
            return self
        }
        return self
    }
        
}

final class MapModel:ObservableObject {
    @Published var SelectedMenuItem:EMenuOptions
    @Published var SelectedDistance:EDistOptions
    @Published var DisplayMapItems:[CustomMapItem]
    static var UserCoords:CLLocationCoordinate2D?
    private var MapItemsCache: [String:[CustomMapItem]]
    
    init(UserCoords:CLLocationCoordinate2D? = nil, SelectedMenuItem:EMenuOptions  = EMenuOptions.coffee, SelectedDistance:EDistOptions = Utils.isMetric ? .m500 : .miQuarter,MapItemsCache:[String:[CustomMapItem]] = [:], DisplayMapItems:[CustomMapItem] = []) {
        MapModel.UserCoords = UserCoords
        self.SelectedMenuItem = SelectedMenuItem
        self.SelectedDistance = SelectedDistance
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
    func getNearbyLocations() async {
        let menuItem = self.SelectedMenuItem
        
        guard let userCoords = MapModel.UserCoords else {
            return
        }
        let region = MKCoordinateRegion(center:userCoords,span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        await getLocationsInRegion(region: region, menuItem: menuItem)

    }
    
    func getLocationsInRegion(region:MKCoordinateRegion, menuItem:EMenuOptions) async {
        var queryResults:[MKMapItem] = []
        let request = MKLocalSearch.Request()
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: menuItem.query)
        request.naturalLanguageQuery = menuItem.rawValue
        request.resultTypes = .pointOfInterest
        request.region = region
        let search = MKLocalSearch(request: request)
        do {
            let response = try await search.start()
            queryResults = response.mapItems
        }catch{
            print(error.localizedDescription)
        }
        if (isNewQuery(query: menuItem.rawValue)) {
            self.MapItemsCache[menuItem.rawValue] = queryResults.map {CustomMapItem(mapItem: $0, time: 0)}
        }
        setDisplayMapItems(cat: menuItem.rawValue)
    }
    
    //Is category location data in the cache?
    func isNewQuery(query:String) ->Bool {
        if (self.MapItemsCache[query] == nil) {
            return true
        }
        return false
    }
    
    //Populate array with map items to display on the map
    func setDisplayMapItems(cat: String) {
        guard let items = self.MapItemsCache[cat] else {
            return
        }
        
        guard let userCoords = MapModel.UserCoords else {
            return
        }
        
        let userLocation = CLLocation(latitude: userCoords.latitude, longitude: userCoords.longitude)
        
        let output = items.filter {mapItem in
            let mapItemLocation = CLLocation(latitude: mapItem.mapItem.placemark.coordinate.latitude,longitude: mapItem.mapItem.placemark.coordinate.longitude)
            if (userLocation.distance(from: mapItemLocation) < CLLocationDistance(self.SelectedDistance.distInM)) {
                return true
            } else {
                return false
            }
        }
        

        DispatchQueue.main.async {
            self.DisplayMapItems = output
        }
    }
    
    //Get the region for all POIs that should display on the screen
    func getBoundingRegion() -> MKCoordinateRegion? {
        var allCoords:[CLLocationCoordinate2D] = DisplayMapItems.map {$0.mapItem.placemark.coordinate}
        guard !allCoords.isEmpty else { return nil }

        
        if let userCoord = MapModel.UserCoords {
            allCoords.append(userCoord)
        }

        let minLat = allCoords.map { $0.latitude }.min()!
        let maxLat = allCoords.map { $0.latitude }.max()!
        let minLon = allCoords.map { $0.longitude }.min()!
        let maxLon = allCoords.map { $0.longitude }.max()!

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,
            longitudeDelta: (maxLon - minLon) * 1.5
        )

        return MKCoordinateRegion(center: center, span: span)
    }
    
}

