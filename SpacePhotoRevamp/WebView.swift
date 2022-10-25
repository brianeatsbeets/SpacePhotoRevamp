//
//  WebView.swift
//  SpacePhotoRevamp
//
//  Created by Aguirre, Brian P. on 10/25/22.
//

// MARK: - Imported libraries

import SwiftUI
import WebKit

// MARK: - Main class

// This struct creates a SwiftUI-compatible WKWebView
struct WebView: UIViewRepresentable {
    
    // MARK: - Properties
    
    var url: URL
    
    // MARK: - Functions
    
    // Create the view
    func makeUIView(context: Context) -> WKWebView {
        
        // Set the webview to allow inline media playback
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        
        // Creta the webview with an arbitrary frame and the WKWebViewConfiguration we created above
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 200, height: 100), configuration: webConfiguration)
        
        return webView
    }
    
    // Update the view
    func updateUIView(_ webView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
