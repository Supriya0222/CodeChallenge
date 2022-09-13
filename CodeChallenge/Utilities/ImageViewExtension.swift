//
//  ImageViewExtension.swift
//  CodeChallenge
//
//  Created by Supriya Rajkoomar on 13/09/2022.
//

import Foundation
import UIKit

//ImageView extension to display image from URL obtained

extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}

