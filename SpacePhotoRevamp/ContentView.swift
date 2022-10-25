//
//  ContentView.swift
//  SpacePhotoRevamp
//
//  Created by Aguirre, Brian P. on 10/23/22.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

struct ContentView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel = PhotoInfoViewModel()
    @State private var opacity = 0.0
    
    // MARK: - Main view
    
    var body: some View {
        
        // Embed in navigation view to provide a navigation title
        NavigationView {
            
            // Check if data was received
            if viewModel.didReceiveData {
                VStack {
                    
                    // Create Web View if media type is video
                    if viewModel.mediaType == "video" {
                        VStack {
                            WebView(url: viewModel.videoURL!)
                            Text(viewModel.copyright)
                        }
                    } else if viewModel.mediaType == "image" {
                        
                        // Display image and copyright
                        ZStack(alignment: .bottomLeading) {
                            Image(uiImage: viewModel.photo!)
                                .resizable()
                                .scaledToFit()
                            Text(viewModel.copyright)
                                .font(.caption)
                                .padding(4)
                                .foregroundColor(.white)
                                .background(.black)
                        }
                    }
                    
                    // Display description header and text
                    VStack(alignment: .leading) {
                        Text("Description:")
                            .font(.headline)
                        ScrollView(.vertical) {
                            Text(viewModel.description)
                        }
                    }
                    .padding()
                }
                
                // Fade in animation
                .onAppear() {
                    withAnimation(.linear(duration: 0.3)) {
                        opacity = 1.0
                    }
                }
                .opacity(opacity)
                .padding()
                .navigationTitle(viewModel.title)
                .navigationBarTitleDisplayMode(.inline)
                
            // Check if error was received
            } else if viewModel.didReceiveError {
                
                // Display error image and text
                VStack {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .padding(50)
                    Text("Error fetching data. Please try again later.")
                }
                
            // Display progress indicator until a network response is received
            } else {
                ProgressView("Loading...")
            }
        }
    }
}

// MARK: - Preview view

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
