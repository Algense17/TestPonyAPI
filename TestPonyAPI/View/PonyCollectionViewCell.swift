//
//  PonyCollectionViewCell.swift
//  TestPonyAPI
//
//  Created by Vasiliy on 15.04.2025.
//

import UIKit

final class PonyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var ponyTtileLabel: UILabel!
    
    @IBOutlet var ponyImageView: UIImageView! {
        didSet {
            ponyImageView.layer.cornerRadius = 5
            activityIndicator = showSpinner(in: ponyImageView)
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView?
    private let networkManager = NetworkManager.shared
    private var currentImageTask: URLSessionTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageTask?.cancel()
        currentImageTask = nil
        ponyImageView.image = nil
        activityIndicator?.startAnimating()
    }
    
    func configure(with pony: Character) {
            ponyTtileLabel.text = pony.name

            guard let imageURLString = pony.image.first, let imageURL = URL(string: imageURLString) else { return }
            if let cachedImage = ImageCache.shared.object(forKey: NSString(string: imageURLString)) {
                ponyImageView.image = cachedImage
                activityIndicator?.stopAnimating()
                return
            }

            currentImageTask = networkManager.fetchImage(from: imageURL) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let imageData):
                    guard let image = UIImage(data: imageData) else { return }
                    self.ponyImageView.image = image
                    self.activityIndicator?.stopAnimating()
                    ImageCache.shared.setObject(image, forKey: NSString(string: imageURLString))
                case .failure(let error):
                    print(error)
                }
            }
        }

    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
}
