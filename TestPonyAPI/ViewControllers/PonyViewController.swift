//
//  PonyViewController.swift
//  TestPonyAPI
//
//  Created by Vasiliy on 15.04.2025.
//

import UIKit

private let reuseIdentifier = "Cell"

class PonyViewController: UICollectionViewController {
    
    var ponys: [Character] = []
    private var networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showUnavailableMessage(
            "Waiting for responce",
            withConfig: .loading(),
            andcolor: .blue
        )
        fetchPonys()
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ponys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "character", for: indexPath) as! PonyCollectionViewCell
        let pony = ponys[indexPath.row]
        cell.configure(with: pony)
        return cell
    }
    
    @IBAction func clearCache(_ sender: UIBarButtonItem) {
        URLCache.shared.removeAllCachedResponses()
        ImageCache.shared.removeAllObjects()
        showAlert(withTitle: "Cache Cleared", andMessage: "The cache has been successfully cleared")
    }
    
    private func fetchPonys() {
        networkManager.fetchData(from: Link.allPony.url) { [unowned self] result in
            switch result {
            case .success(let characters):
                self.ponys = characters
                collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}
