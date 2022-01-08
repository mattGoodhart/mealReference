//
//  MealsByCategoryViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/5/22.
//

import UIKit


class MealsByCategoryViewController: UICollectionViewController {
    
    let mealsByCategoryBaseURLString = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    var thisCategory: String = ""
    var mealsInThisCategory : [MealResults] = []
    var mealImageData : [Data?] = []
    var numberOfMeals: Int = 1
    var chosenMealID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataForMealCollection()
    
        //show activity indcator


    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if  !mealsInThisCategory.isEmpty {
            numberOfMeals = mealsInThisCategory.count
            collectionView.reloadData()
        
            for meal in mealsInThisCategory {
                LoadPhotosForMeals(meal: meal)
            }
        }
    }
    
    func LoadPhotosForMeals(meal: MealResults) {
        //activity indicator
        
        print("fetching meal Photo data")
        
        guard let url = URL(string: meal.mealImageString) else {
            print("couldn't create URL from mealImageURLString")
            return
        }
        
        guard let imageData = try? Data(contentsOf: url) else {
            print("Photo Download Failure")
            return
        }
        
        DispatchQueue.main.async {
            self.mealImageData.append(imageData)
            self.collectionView.reloadData()
        }
        
        
    }
    
    func fetchDataForMealCollection() {
        
        guard let url = URL(string: mealsByCategoryBaseURLString + thisCategory) else {
            print("Couldnt create URL from mealsByCategoryBaseURLString")
            return
        }
        
        print("fetching meals")
        Networking.shared.taskForJSON(url: url, responseType: MealsByCategoryResponse.self) { response, error in
            
            guard let response = response else {
                print("Error fetching Meals by Categories Response from theMealDB")
                print(error as Any)
              //  self.handleActivityIndicator(indicator: self.activityIndicator, viewController: self, isActive: true)
                return // add alert message?
            }
            
            for meal in response.meals {
               
                self.mealsInThisCategory.append(meal)
               // collectionView.reloadData()
            }
        }
      //  handleActivityIndicator(indicator: activityIndicator, viewController: self, isActive: false)
      //  handleButton(button: getStartedButton, isEnabled: true)
    }


    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfMeals
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        if mealsInThisCategory.indices.contains(indexPath.item) {
            cell.textView.text = mealsInThisCategory[indexPath.item].mealName
        }
        
        if  mealImageData.indices.contains(indexPath.item) {
           if let data = mealImageData[indexPath.item], let image = UIImage(data: data) {
                cell.imageView.image = image
            }
        }
        return cell
    }
}


