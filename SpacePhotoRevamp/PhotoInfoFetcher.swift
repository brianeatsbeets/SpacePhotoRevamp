//
//  PhotoInfoFetcher.swift
//  SpacePhotoRevamp
//
//  Created by Aguirre, Brian P. on 10/23/22.
//

// MARK: - Imported libraries

import UIKit
import Combine

// MARK: - Main class

class PhotoInfoFetcher {
    
    // MARK: - Functions
    
    // Fetch the photo metadata
    func fetchPhotoInfo() -> AnyPublisher<PhotoInfoResponse, PhotoInfoError> {
        
        // Create the URL to query
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [ "api_key": "DEMO_KEY", ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // Return a publisher for the photo metadata
        return URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
        
            // Check that we received a valid HTTP response code, and if so, pass the data downstream
            .tryMap { response in
                guard let httpResponse = response.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { throw PhotoInfoError.httpStatusCode }
                
                return response.data
            }
        
            // Attempt to decode the response data and map potential errors to PhotoInfoErrors
            .decode(type: PhotoInfoResponse.self, decoder: JSONDecoder())
            .mapError { PhotoInfoError.map($0) }
        
            // "Erase" the extraneous types applied by the operators to the return value throughout the stream and revert it back to type AnyPublisher<PhotoInfo, PhotoInfoError> so we can return it
            .eraseToAnyPublisher()
    }
    
    // Fetch the photo
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, PhotoInfoError> {
        
        // Return a publisher for the photo
        return URLSession.shared.dataTaskPublisher(for: url)
            
            // Check that we received a valid HTTP response code, and if so, pass the data downstream
            .tryMap { response in
                guard let httpResponse = response.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { throw PhotoInfoError.httpStatusCode }
                
                return response.data
            }
        
            // Map the response data to the desired data type and map potential errors to PhotoInfoErrors
            .map { data in
                return UIImage(data: data)
            }
            .mapError { PhotoInfoError.map($0) }
        
            // "Erase" the extraneous types applied by the operators to the return value throughout the stream and revert it back to type AnyPublisher<PhotoInfo, PhotoInfoError> so we can return it
            .eraseToAnyPublisher()
    }
}

// MARK: - Enums

// This enum contains cases for photo info fetching errors
enum PhotoInfoError: Error, LocalizedError {
    case httpStatusCode
    case imageData
    case decoding
    case other(Error)
    
    // Cast errors as PhotoInfoError
    static func map(_ error: Error) -> PhotoInfoError {
        return (error as? PhotoInfoError) ?? .other(error)
    }
}
