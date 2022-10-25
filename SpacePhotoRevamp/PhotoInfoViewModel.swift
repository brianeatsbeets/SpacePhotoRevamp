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
    
    var photo = UIImage(systemName: "photo.on.rectangle")
    var title = "Loading..."
    var copyright = "Loading..."
    var description = "Loading..."
    var mediaType = "image"
    var videoURL = URL(string: "")
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
        
            // Transform the above AnyPublisher<PhotoInfoResponse, PhotoInfoError> publisher into a AnyPublisher<UIImage?, PhotoInfoError> publisher to fetch the photo image
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
                title = metadata.title
                copyright = metadata.copyright != nil ? "© \(metadata.copyright!)" : "No Copyright"
                description = metadata.description
                mediaType = metadata.mediaType
                
                // Check if the media type is image or video
                if metadata.mediaType == "image" {
                    photo = image
                } else if metadata.mediaType == "video"{
                    
                    // Set the video URL and query for inline playback for YouTube videos
                    let urlString = metadata.url.absoluteString
                    let inlineQuery = "playsinline=1"
                    let separator = urlString.contains("?") ? "&" : "?"
                    
                    videoURL = URL(string: urlString + separator + inlineQuery)
                }
                
                didReceiveData = true
            }

            // Store the subscriber
            .store(in: &subscriptions)
    }
}
