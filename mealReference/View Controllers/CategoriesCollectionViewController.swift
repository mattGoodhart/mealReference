//
//  ViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/4/22.
//

import UIKit

class CategoriesCollectionViewController: UICollectionViewController {
    
    var allCategories : [MealCategory]!
    var categoryImageData: [Data] = []
    var numberOfCategories: Int = 0
    var chosenCategory: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfCategories = allCategories.count
        
         getPhotosFromTheMealDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // getPhotosFromTheMealDB()
    }
    
    
    
//    if let url = URL(string: allCategories.categoryImageString) {
        
        //handleActivityIndicator(indicator: cell.activityIndicator, viewController: self, isActive: true)
       // loadPhotoFromURL(url: url)
        
        
        func getPhotosFromTheMealDB() -> Void {
            for category in allCategories {
                if let photoURL = URL(string: category.categoryImageString) {
                    self.loadPhotoFromURL(url: photoURL)
                }
            }
        }
    
    func fetchMealsByCategory(category: String) {
        
    }
    
    
    func loadPhotoFromURL(url: URL) {
        
        guard let imageData = try? Data(contentsOf: url) else {
            print("Photo Download Failure")
            return
        }
        
        DispatchQueue.main.async {
            self.categoryImageData.append(imageData)
            self.collectionView.reloadData()
        }
    }
    
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCategories
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
      //  if categoryImageData.indices.contains(indexPath.item) {
        
        
      
        
        //   if let imageURL = URL(string: allCategories[indexPath.item].categoryImageString) {
        
        //   handleActivityIndicator(indicator: cell.activityIndicator, viewController: self, isActive: true)
        
        //  let imageData = loadPhotoFromURL(url: imageURL)
        //   handleActivityIndicator(indicator: cell.activityIndicator, viewController: self, isActive: false)
        
        if categoryImageData.indices.contains(indexPath.item), let image = UIImage(data: categoryImageData[indexPath.item]) {
            cell.imageView.image = image
        }
        cell.textView.text = allCategories[indexPath.item].category
        
        handleActivityIndicator(indicator: cell.activityIndicator, viewController: self, isActive: false)
            
      //  }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        chosenCategory = allCategories[indexPath.item].category
        // handleActivityIndicator(indicator:, viewController: <#T##UIViewController#>, isActive: <#T##Bool#>)
        
      //  fetchMealsByCategory(category: )
        
        performSegue(withIdentifier: "SegueToMealsByCategoryView", sender: self)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToMealsByCategoryView" {
            let mealsByCategoryViewController = segue.destination as! MealsByCategoryViewController
            mealsByCategoryViewController.thisCategory = chosenCategory
        }
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













