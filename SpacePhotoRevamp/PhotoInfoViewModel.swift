//
//  PhotoInfoViewModel.swift
//  SpacePhotoRevamp
//
//  Created by Aguirre, Brian P. on 10/23/22.
//

// MARK: - Imported libraries

import UIKit
import Combine

// MARK: - Main class

class PhotoInfoViewModel: ObservableObject, Identifiable {
    
    // MARK: - Properties
    
    @Published var photo = UIImage(systemName: "photo.on.rectangle")
    @Published var title = "Loading..."
    @Published var copyright = "Loading..."
    @Published var description = "Loading..."
    @Published var didReceiveData = false
    @Published var didReceiveError = false
    
    private var photoInfoFetcher = PhotoInfoFetcher()
    private var subscriptions = [AnyCancellable]()
    
    // MARK: - Initializer
    
    init() {
        fetchData()
    }
    
    // MARK: - Functions
    
    // Fetch the data, decode it, and update the observed properties with the results
    func fetchData() {
        
        // Fetch the photo info
        let photoDetails = photoInfoFetcher.fetchPhotoInfo()
        
        // Fetch the photo image
        let photoImage = photoInfoFetcher.fetchPhotoInfo()
            .flatMap { photoInfoResponse in
                self.photoInfoFetcher.fetchImage(from: photoInfoResponse.url)
            }
        
        // Combine the two publishers
        photoDetails.zip(photoImage)
        
            // Receive on the main queue to update the UI
            .receive(on: DispatchQueue.main)
        
            // Create a subscriber
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self.didReceiveError = true
                }
            } receiveValue: { [unowned self] metadata, image in // Using unowned self because we're on the root view controller, which will always be in memory so no possibility for a retain cycle
                
                // Update the observed properties with the received data
                photo = image
                title = metadata.title
                copyright = metadata.copyright != nil ? "© \(metadata.copyright!)" : "No Copyright"
                description = metadata.description
                didReceiveData = true
            }
        
            // Store the subscriber
            .store(in: &subscriptions)
    }
}
