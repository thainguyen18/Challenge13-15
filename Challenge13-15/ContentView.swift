//
//  ContentView.swift
//  Challenge13-15
//
//  Created by Thai Nguyen on 12/31/19.
//  Copyright © 2019 Thai Nguyen. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var image: UIImage?
    
    @State private var users = [User]()
    
    @State private var annotations = [CodableMKPointAnnotation]()
    
    @State private var showingImagePicker = false
    
    @State private var showingUserDetail = false
    
    @State private var selectedPlace: MKPointAnnotation?
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    @State private var showingPlaceDetails = false
    
    let viewChoices = ["List", "Map"]
    
    @State private var viewChoice = 0
    
    //let locationFetcher = LocationFetcher()
    
    
    func askForPhotoName() {
        if let _ = self.image {
            showingUserDetail = true
        }
    }
    
    
    func finishSavingUser() {
        
        // Reset
        self.image = nil
        
    }
    
    
    func loadData() {
        let fileName = FileManager.getDocumentDirectory().appendingPathComponent("UserFaces")
        
        do {
            let data = try Data(contentsOf: fileName)
            self.users = try JSONDecoder().decode([User].self, from: data)
            
        } catch {
            print("Unable to load data...")
        }
        
        
       
    }
    
//    func loadLocations() {
//        let locationsFilename = FileManager.getDocumentDirectory().appendingPathComponent("SavedPlaces")
//
//        do {
//            let data = try Data(contentsOf: locationsFilename)
//            self.annotations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
//        } catch {
//            print("Unable to load saved locations data.")
//        }
//    }
    
    
    var body: some View {
        
        let listView = List(users.sorted()) { user in
            NavigationLink(destination: UserDetailView(user: user, users: self.$users)) {
                    if user.userImage() != nil {
                        Image(uiImage: user.userImage()!)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    Text("\(user.name)")

                }
                .frame(height: 50)
            }
        .navigationBarTitle("Faces")
        .navigationBarItems(
            leading: Picker("View Choices", selection: $viewChoice) {
                ForEach(0..<self.viewChoices.count) { index in
                    Text(self.viewChoices[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle()),
            
            trailing: Button(action: {
                self.showingImagePicker = true
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .padding()
            }
        )
        
        
        let mapView = MapView(centerCoordinate: self.$centerCoordinate, selectedPlace: self.$selectedPlace, showingPlaceDetails: self.$showingPlaceDetails, annotations: self.users.map {$0.annotation})
            .navigationBarTitle("Faces")
            .navigationBarItems(
                leading: Picker("View Choices", selection: $viewChoice) {
                    ForEach(0..<self.viewChoices.count) { index in
                        Text(self.viewChoices[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle()),
                
                trailing: Button(action: {
                    self.showingImagePicker = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding()
                }
        )
        
        
        return NavigationView {
            
            if viewChoice == 1 {
                mapView
                .sheet(isPresented: $showingUserDetail, onDismiss: finishSavingUser) {
                    UserDetailView(selectedImage: self.image, users: self.$users)
                }
            } else {
                listView
                .sheet(isPresented: $showingUserDetail, onDismiss: finishSavingUser) {
                    UserDetailView(selectedImage: self.image, users: self.$users)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: askForPhotoName) {
            ImagePicker(image: self.$image)
        }
    .onAppear(perform: {

        // Load data
        self.loadData()
        //self.loadLocations()
        
        // Start monitoring location
        //self.locationFetcher.start()
    })
    }
}

