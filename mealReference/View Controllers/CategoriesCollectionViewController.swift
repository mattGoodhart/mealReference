//
//  ViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/4/22.
//

import UIKit

class CategoriesCollectionViewController: UICollectionViewController {
    
    let model = MealReferenceModel.shared
    var mealsInChosenCategory: [MealResults]!
    var allCategories : [MealCategory]! // sent with segue
    var categoryImageData: [Data] = []
    var numberOfCategories: Int = 0
    var chosenCategory: String = ""

    
    
    //MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCategoriesCollection()
      
        collectionView.reloadData()
        getPhotosFromTheMealDB()
    }

    func initializeCategoriesCollection() {
        allCategories = model.allCategories
        numberOfCategories = allCategories.count
        categoryImageData = model.categoryImageData
    }
    
    func getPhotosFromTheMealDB() -> Void {
        guard categoryImageData.isEmpty  else {
            return
        }

        print("getting category photos")
        for category in allCategories {
            if let photoURL = URL(string: category.categoryImageString) {
                self.loadPhotoFromURL(url: photoURL)
            }
        }
    }
    
    func loadPhotoFromURL(url: URL) {
        
       // Networking.shared.fetchData(at: url) { data in
            
            //            guard let data = data else {
            //                print("Photo Download Failure")
            //                return
            //            }
            guard let data = try? Data(contentsOf: url) else {
                print("Photo Download Failure")
                return
            }
            
            
            
            self.model.categoryImageData.append(data)
            self.collectionView.reloadData()
        }
    
    

    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCategories
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        if model.categoryImageData.indices.contains(indexPath.item), let image = UIImage(data: model.categoryImageData[indexPath.item]) {
            cell.imageView.image = image
            handleActivityIndicator(indicator: cell.activityIndicator, isActive: false)
        }
        cell.label.text = allCategories[indexPath.item].category
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenCategory = allCategories[indexPath.item].category
        performSegue(withIdentifier: "SegueToMealsByCategoryView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToMealsByCategoryView" {
            let mealsByCategoryViewController = segue.destination as! MealsByCategoryViewController
            mealsByCategoryViewController.thisCategory = chosenCategory
        }
    }
}














