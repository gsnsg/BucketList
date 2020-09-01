//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Nikhi on 01/09/20.
//  Copyright © 2020 nikhit. All rights reserved.
//

import Foundation
import MapKit

extension MKPointAnnotation: ObservableObject {
    
    var wrappedTitle: String {
        get {
            title ?? "Unknown Title"
        }
        
        set {
            title = newValue
        }
    }
    
    var wrappedDescription: String {
        get {
            subtitle ?? "Unknown Description"
        }
        
        set {
            subtitle = newValue
        }
    }
}
