//
//  SinglePOIView.swift
//  Waldi
//
//  Created by Samuel Rutherford on 5/7/25.
//book.closed

import SwiftUI
import MapKit

struct PointOfInterestView: View {
    @Binding var POI:CustomMapItem?
    @State var isOpenDrawer:Bool = false 
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            if POI != nil {
                VStack {
                    Group {
                        HStack {
                            VStack {
                                Text(POI?.mapItem.name ?? "").font(.title2).fontWeight(.bold).foregroundStyle(Color.black).frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(POI?.mapItem.pointOfInterestCategory?.rawValue.replacingOccurrences(of: "MKPOICategory", with: "") ?? "") · \(POI?.mapItem.placemark.locality ?? "") \(POI?.mapItem.placemark.administrativeArea ?? "")").font(.caption).foregroundStyle(Color.black).frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            Spacer()
                            Button("",systemImage: "xmark.circle.fill") {
                                POI = nil
                                isOpenDrawer = false
                            }.imageScale(.large).foregroundStyle(Color.black)
                        }
                        HStack {
                            if (POI?.distance != nil) {
                                Image(systemName: "figure.walk").foregroundStyle(Color.black).imageScale(.large)
                                Spacer()
                                Image(systemName: "point.topleft.down.to.point.bottomright.curvepath.fill")
                                Text("\(Utils.distToKmMiles(distance: POI?.distance))")
                                Image(systemName: "clock.fill")
                                Text("\(Utils.secondsToMinutes(time: POI?.time))")
                            }else {
                                HStack{
                                    Spacer()
                                    ProgressView().padding(2)
                                    Spacer()
                                }
                            }
                        }.foregroundStyle(Color.black).frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        HStack{
                            Image(systemName: "arrow.trianglehead.turn.up.right.circle.fill").foregroundStyle(Color.black).imageScale(.large)
                            Spacer()
                            Button {
                                handleGoogleMaps(mapItem: POI)
                                
                            }label:{
                                Image("GoogleIcon").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                            }.buttonStyle(NavButtonStyle())
                            Button {
                                POI?.mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
                            }label:{
                                Image(systemName:"apple.logo").imageScale(.large)
                            }.buttonStyle(NavButtonStyle())
                        }}
                    if (isOpenDrawer) {
                        Divider()
                        VStack{
                            if let poi = POI {
                                Text("Website").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).foregroundStyle(Color.black)
                                if let url = poi.mapItem.url {
                                    Link(destination: url) {
                                        Text(poi.mapItem.url?.absoluteString ?? "").foregroundStyle(.blue).font(.subheadline)
                                    }.frame(maxWidth: .infinity, alignment: .leading)}
                                Text("Phone number").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).foregroundStyle(Color.black)
                                if let phone = poi.mapItem.phoneNumber {
                                    Link(destination: URL(string: "tel:\(phone)")!) {
                                        Text(phone)
                                            .foregroundStyle(.blue).font(.subheadline)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("")
                                        .frame(maxWidth: .infinity, alignment: .leading).font(.subheadline)
                                }
                            }
                        }}
                }
                .padding(12)
                    .frame(maxWidth:.infinity)
                    .background(Color.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal,4)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }else {
                EmptyView()
            }
        }.animation(.smooth(duration: 0.1), value: POI)
            .gesture(
                DragGesture().onEnded { value in
                        withAnimation{
                        if (value.translation.height < -50) {
                            isOpenDrawer = true
                        } else if (value.translation.height > 50) {
                            if isOpenDrawer {
                                isOpenDrawer = false
                            } else{
                                POI = nil
                            }
                        }
                    }})
    }
}

struct NavButtonStyle:ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width:96)
            .padding(4)
            .foregroundColor(Color.black)
            .background(Capsule().fill(Color("PrimaryColorDark")))
            .opacity(configuration.isPressed ? 0.8 : 1)
            
    }
}

func handleGoogleMaps(mapItem:CustomMapItem?) {
    guard let POI = mapItem else {
        return
    }
    let lat = Double(POI.mapItem.placemark.coordinate.latitude)
    let lon = Double(POI.mapItem.placemark.coordinate.longitude)
    let name = POI.mapItem.name ?? ""
    
    let URLGoogleMaps = URL(string:"comgooglemaps://?q=\(name)&center=\(lat),\(lon)&zoom=14&directionsmode=walking")
    guard let URLGuard = URLGoogleMaps else {
        return
    }
    if UIApplication.shared.canOpenURL(URLGuard) {
        UIApplication.shared.open(URLGuard)
    }else {
        if let webURL = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(lat),\(lon)&travelmode=walking") {
                    UIApplication.shared.open(webURL)
                }
    }
}
