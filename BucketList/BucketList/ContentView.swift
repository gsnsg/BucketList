//
//  ContentView.swift
//  BucketList
//
//  Created by Nikhi on 31/08/20.
//  Copyright © 2020 nikhit. All rights reserved.
//

import SwiftUI
import MapKit




struct ContentView: View {
    
    
    @State private var selectedLocation: MKPointAnnotation?
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var showingEditSheet = false
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate, selectedLocation: $selectedLocation, showingEditSheet: $showingEditSheet ,annotations: locations)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 32, height: 32)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Add new point
                        
                        let newLocation = CodableMKPointAnnotation()
                        newLocation.title = "Example Location " + String(self.locations.count)
                        newLocation.subtitle = "Dummy Demo"
                        newLocation.coordinate = self.centerCoordinate
                        self.locations.append(newLocation)
                        self.selectedLocation = newLocation
                        self.showingEditSheet = true
                        
                        
                    }) {
                        Image(systemName: "plus")
                        .padding()
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.75))
                        .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }
        }.sheet(isPresented: $showingEditSheet, onDismiss: saveData) {
            if self.selectedLocation != nil {
                EditView(currentLocation: self.selectedLocation!)
            }
        }
        .onAppear(perform: loadData)

        
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveData() {
        do {
            let fileName = getDocumentDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func loadData() {
        let filePath = getDocumentDirectory().appendingPathComponent("SavedPlaces")
        do {
            let data = try Data(contentsOf: filePath)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
            print("Data Loaded!")
        } catch {
            print(error.localizedDescription)
        }
    
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
