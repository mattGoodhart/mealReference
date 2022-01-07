//
//  ViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/4/22.
//

import UIKit

class CategoriesCollectionViewController: UICollectionViewController {
    
    var allCategories : [MealCategory]!
    var numberOfCategories: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfCategories = allCategories.count
        getPhotosFromTheMealDB()
    }
    
    
    
    func getPhotosFromTheMealDB() -> Void {
        for category in allCategories {
            if let photoURL = URL(string: category.categoryImageString) {
                self.loadPhotoFromURL(url: photoURL)
            }
        }
    }
    
    func loadPhotoFromURL(url: URL) -> Data {
        
        guard let imageData = try? Data(contentsOf: url) else {
            print("Photo Download Failure")
            return Data()
        }
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
        return imageData
    }
    
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCategories
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        if let imageURL = URL(string: allCategories[indexPath.item].categoryImageString) {
            
        let imageData = loadPhotoFromURL(url: imageURL)
        let image = UIImage(data: imageData)
        cell.imageView.image = image
            cell.textView.text = allCategories[indexPath.item].category
        }
        return cell
    }
}
    
    
    
//    private func parseCategories(jsonData: Data) {
//        do {
//            let decodedData = try JSONDecoder().decode(CategoriesResponse.self, from: jsonData)
//
//            for category in decodedData.result {
//                allCategories.append(category)
//            }
//        } catch {
//            print("category JSON decoding error")
//        }
//    }
    

    
    
    
    
    
    

    



