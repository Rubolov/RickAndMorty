//
//  ImageCache.swift
//  RickAndMortyApp
//
//  Created by Yuriy Yakimenko on 18.12.2022.
//

import Foundation
import UIKit

class ImageCache {
    
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
