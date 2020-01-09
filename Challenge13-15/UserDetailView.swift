//
//  UserDetailView.swift
//  Challenge13-15
//
//  Created by Thai Nguyen on 12/31/19.
//  Copyright © 2019 Thai Nguyen. All rights reserved.
//

import SwiftUI
import CoreLocation

struct UserDetailView: View {
    
    var location: CLLocationCoordinate2D?
    
    var selectedImage: UIImage?
    
    @State private var image: Image?
    
    @State private var photoName = ""
    
    var user: User?
    
    @Binding var users: [User]
    
    //@Binding var annotations: [CodableMKPointAnnotation]
    
    @Environment(\.presentationMode) var presentationMode
    
    let locationFetcher = LocationFetcher()
    
    
    func saveToDisk() {
        do {
            let fileName = FileManager.getDocumentDirectory().appendingPathComponent("UserFaces")
            let data = try JSONEncoder().encode(self.users)
            try data.write(to: fileName, options: [.atomic, .completeFileProtection])
            
            print("Saved!")
        } catch {
            print("Unable to save data...")
        }
        
//        do {
//            let filename = FileManager.getDocumentDirectory().appendingPathComponent("SavedPlaces")
//            let data = try JSONEncoder().encode(self.annotations)
//            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
//            print("Saved Locations!")
//        } catch {
//            print("Unable to save data.")
//        }
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            // display the image
            if self.selectedImage != nil {
                Image(uiImage: selectedImage!)
                .resizable()
                .scaledToFit()
            } else {
                image?
                .resizable()
                .scaledToFit()
            }
            
            
            TextField("Enter name", text: $photoName)
                .padding()
            
            Button(action: {
                // Save user data
                
                // Create user if needed
                self.createOrUpdateUser()
                
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Text("Save")
            }
            
            Spacer()
        }
        .onAppear(perform: loadData)
    }
    
    
    func createOrUpdateUser() {
        
        // If updating a user
        if let user = self.user {
           
            let urls = users.map { $0.imageUrl }
            
            if let index = urls.firstIndex(of: user.imageUrl) {
                let annotation = user.annotation
                annotation.title = photoName
                
                users[index] = User(id: user.id, name: photoName, imageUrl: user.imageUrl, annotation: annotation)
                
                self.saveToDisk()
                
                return
            }
            
        }
        
        
        // Create a new user
        guard let image = self.selectedImage else { return }
        
        guard let location = self.locationFetcher.lastKnownLocation else { return }
        
        if photoName.isEmpty {
            photoName = "Unknown"
        }
        
        let fileName = UUID().uuidString
        
        let path = FileManager.getDocumentDirectory().appendingPathComponent(fileName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: path, options: [.atomic, .completeFileProtection])
            
            let annotation = CodableMKPointAnnotation()
            annotation.coordinate = location 
            annotation.title = photoName
            annotation.subtitle = "Some Comment here..."
            
            //self.annotations.append(annotation)
            
            self.users.append(User(name: photoName, imageUrl: path.absoluteString, annotation: annotation))
            
            self.saveToDisk()
        }
    }
    
    func loadData() {
        // start monitoring location
        self.locationFetcher.start()
        
        guard let user = self.user else { return }
        guard let url = URL(string: user.imageUrl) else { return }
        guard let imageData = try? Data(contentsOf: url) else { return }
        guard let image = UIImage(data: imageData) else { return }
    
        
        self.image = Image(uiImage: image)
        self.photoName = user.name
        
    }
}


