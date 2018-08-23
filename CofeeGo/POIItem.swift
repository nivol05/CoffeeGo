//
//  File.swift
//  CofeeGo
//
//  Created by Ni VoL on 06.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//
/// Point of Interest Item which implements the GMUClusterItem protocol


import GoogleMaps

class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var index : Int!
    var marker = GMSMarker()
    
    init(position: CLLocationCoordinate2D, index : Int , marker : GMSMarker ) {
        self.position = position
        self.index = index
        self.marker = marker
    }
}
