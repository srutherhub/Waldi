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
                    HStack {
                        VStack {
                            Text(POI?.mapItem.name ?? "").font(.title2).fontWeight(.bold).foregroundStyle(.black).frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(POI?.mapItem.pointOfInterestCategory?.rawValue.replacingOccurrences(of: "MKPOICategory", with: "") ?? "") · \(POI?.mapItem.placemark.locality ?? "") \(POI?.mapItem.placemark.administrativeArea ?? "")").font(.caption).foregroundStyle(.black).frame(maxWidth: .infinity, alignment: .leading)

                        }
                        Spacer()
                        Button("",systemImage: "xmark.circle.fill") {
                            POI = nil
                            isOpenDrawer = false
                        }.imageScale(.large)
                    }
                    HStack {
                        if (POI?.distance != nil) {
                            Image(systemName: "figure.walk").foregroundStyle(Color.black).imageScale(.large)
                            Text(" · \(Utils.distToKmMiles(distance: POI?.distance)) · ")
                            Text("\(Utils.secondsToMinutes(time: POI?.time))")
                            Button("Apple") {
                                POI?.mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
                            }.buttonStyle(.bordered)
                        }else {
                            HStack{
                                Spacer()
                                ProgressView().padding(8)
                                Spacer()
                            }
                        }
                    }.foregroundStyle(.black).frame(maxWidth: .infinity, alignment: .leading)
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: isOpenDrawer ? .infinity : 0)
                            .animation(.smooth(duration: 0.1), value: isOpenDrawer)
                    Divider()
                    VStack{
                        if let poi = POI {
                            Text("Website").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).foregroundStyle(.black)
                            if let url = poi.mapItem.url {
                                Link(destination: url) {
                                    Text(poi.mapItem.url?.absoluteString ?? "").foregroundStyle(.blue).font(.subheadline)
                                }.frame(maxWidth: .infinity, alignment: .leading)}
                            Text("Phone number").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).foregroundStyle(.black)
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
                    }
                }
                .padding(8)
                    .frame(maxWidth:.infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal,4)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }else {
                EmptyView()
            }
        }.animation(.smooth(duration: 0.1), value: POI != nil)
        .gesture(
                DragGesture().onEnded { value in
                    withAnimation{
                    if (value.translation.height < -50) {
                        isOpenDrawer = true
                    } else if (value.translation.height > 50) {
                        isOpenDrawer = false
                    }
                }})
    }
}

