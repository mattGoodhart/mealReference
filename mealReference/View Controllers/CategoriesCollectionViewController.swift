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
    let mealsByCategoryBaseURLString = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    
    
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
        
//        guard categoryImageData.isEmpty else {// bah
//            return
//        }
        print("getting category photos")
        for category in allCategories {
            if let photoURL = URL(string: category.categoryImageString) {
                self.loadPhotoFromURL(url: photoURL)
            }
        }
        
    }
    
    func fetchMealsByCategory() {
        guard let url = URL(string: mealsByCategoryBaseURLString + chosenCategory) else {
            print("Couldnt create URL from mealsByCategoryBaseURLString")
            return
        }
        
        print("fetching meals")
        Networking.shared.taskForJSON(url: url, responseType: MealsByCategoryResponse.self) { response, error in
            
            guard let response = response else {
                print("Error fetching Meals by Categories Response from theMealDB")
                print(error as Any)
                return // add alert message?
            }
            
            for meal in response.meals {
                self.mealsInChosenCategory.append(meal)
            }
        }
    }
    
    
    func loadPhotoFromURL(url: URL) {
        
        guard let imageData = try? Data(contentsOf: url) else {
            print("Photo Download Failure")
            return
        }
        
        DispatchQueue.main.async {
            self.model.categoryImageData.append(imageData)
          //  self.categoryImageData.append(imageData)
            self.collectionView.reloadData()
        }
        
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
        //activity indicator
     //   fetchMealsByCategory()
        performSegue(withIdentifier: "SegueToMealsByCategoryView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToMealsByCategoryView" {
            let mealsByCategoryViewController = segue.destination as! MealsByCategoryViewController
            mealsByCategoryViewController.thisCategory = chosenCategory
        //    mealsByCategoryViewController.mealsInThisCategory = mealsInChosenCategory // not there yet...
        }
    }
}














