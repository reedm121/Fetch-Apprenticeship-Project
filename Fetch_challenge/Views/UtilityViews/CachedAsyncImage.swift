//
//  CacheAsyncImage.swift
//  Fetch_challenge
//
//  Created by Reed Gantz on 7/19/24.
//

import Foundation
import SwiftUI
import Combine

class CachedImageLoader: ObservableObject {
    @Published var image: UIImage?
    private static let imageCache = NSCache<NSString, UIImage>()
    private var cancellable: AnyCancellable?
    
    func loadImage(from url: URL) {
        let urlString = url.absoluteString as NSString
        
        // Check if the image is already cached
        if let cachedImage = CachedImageLoader.imageCache.object(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        // Otherwise, load the image from the network
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadedImage in
                guard let self = self, let loadedImage = loadedImage else { return }
                // Cache the loaded image
                CachedImageLoader.imageCache.setObject(loadedImage, forKey: urlString)
                self.image = loadedImage
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

struct CachedAsyncImage: View {
    @StateObject private var imageLoader = CachedImageLoader()
    let url: URL
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            imageLoader.loadImage(from: url)
        }
    }
}
