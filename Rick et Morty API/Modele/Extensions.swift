//
//  Extensions.swift
//  Rick et Morty API
//
//  Created by Benoit Cauchy on 2019-06-03.
//  Copyright © 2019 Benoit Cauchy. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func download(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, reponse, error) in
            guard let imageData = data, let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
            
        }.resume()
    }
    
    
}
