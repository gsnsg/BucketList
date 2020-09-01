//
//  EditView.swift
//  BucketList
//
//  Created by Nikhi on 31/08/20.
//  Copyright © 2020 nikhit. All rights reserved.
//

import SwiftUI
import MapKit

struct EditView: View {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var currentLocation: MKPointAnnotation
    
    @State private var loadingState: LoadingState = .loading
    
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Location Name", text: $currentLocation.wrappedTitle)
                    TextField("Description", text: $currentLocation.wrappedDescription)
                }
                
                Section(header: Text("Nearby...")) {
                    if loadingState == .loading {
                        Text("Loading")
                    } else if loadingState == .loaded {
                       List(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                             + Text(": ") +
                                Text(page.description)
                            .italic()
                        }
                    } else {
                        Text("Error. Please try again after some time")
                    }
                }
            }
            .navigationBarTitle("Edit Location")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
                .onAppear(perform: fetchNearbyPlaces)
        }
    }
    
    
    func fetchNearbyPlaces() {
        let urlString =  "https://en.wikipedia.org/w/api.php?ggscoord=\(currentLocation.coordinate.latitude)%7C\(currentLocation.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            self.loadingState = .failed
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(Result.self, from: data) {
                    self.pages = Array(items.query.pages.values).sorted()
                    self.loadingState = .loaded
                    return
                }
            }
            self.loadingState = .failed
        }.resume()
    }
}

