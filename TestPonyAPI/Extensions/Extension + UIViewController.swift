//
//  Extension + UIViewController.swift
//  TestPonyAPI
//
//  Created by Vasiliy on 20.04.2025.
//

import UIKit

extension PonyViewController {
    func showUnavailableMessage(
        _ message: String,
        withConfig config: UIContentUnavailableConfiguration,
        image: String? = nil,
        andcolor color: UIColor = .red
    ) {
        var config = config
        config.text = message
        config.textProperties.color = color
        config.textProperties.font = .boldSystemFont(ofSize: 20)
        if let image {
            config.image = UIImage(systemName: image)
            config.imageProperties.tintColor = color
        }
        contentUnavailableConfiguration = config
    }
}

extension UICollectionView {
    func addVerticalGradientLayer() {
        let primaryColor = UIColor(
            red: 210/255,
            green: 109/255,
            blue: 128/255,
            alpha: 1
        )
        
        let secondaryColor = UIColor(
            red: 107/255,
            green: 148/255,
            blue: 230/255,
            alpha: 1
        )
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [primaryColor.cgColor, secondaryColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        
    }
}
