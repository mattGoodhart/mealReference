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
    var mealImageData : [Data] = []
    var numberOfMeals: Int = 1
    var chosenMealID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  numberOfMeals = mealsInThisCategory.count
        fetchDataForMealCollection()
        
        //show activity indcator
        
       // getPhotosFromTheMealDB()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        if  !mealsInThisCategory.isEmpty {
        //            numberOfMeals = mealsInThisCategory.count
        //            collectionView.reloadData()
        //
        //            for meal in mealsInThisCategory {
        //                LoadPhotosForMeals(meal: meal)
        //            }
        //        }
    }
    
    func getPhotosFromTheMealDB() -> Void {
        for meal in mealsInThisCategory {
            if let photoURL = URL(string: meal.mealImageString + "/preview") {
                self.loadPhotoFromURL(url: photoURL)
            }
        }
    }
    func loadPhotoFromURL(url: URL) {
        
        guard let imageData = try? Data(contentsOf: url) else {
            print("Photo Download Failure")
            return
        }
        
        DispatchQueue.main.async {
            self.mealImageData.append(imageData)
            self.collectionView.reloadData()
        }
        
    }
    
    //
    //    func LoadPhotosForMeals() {
    //        //activity indicator
    //
    //        print("fetching meal Photo data")
    //
    //        for meal in mealsInThisCategory {
    //
    //            guard let url = URL(string: meal.mealImageString) else {
    //                print("couldn't create URL from mealImageURLString")
    //                return
    //            }
    //
    //            guard let imageData = try? Data(contentsOf: url) else {
    //                print("Photo Download Failure")
    //                return
    //            }
    //
    //            DispatchQueue.main.async {
    //                self.mealImageData.append(imageData)
    //                self.collectionView.reloadData()
    //            }
    //        }
    //    }
    
    func fetchDataForMealCollection() { // not currently used
        
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
            
            self.numberOfMeals = self.mealsInThisCategory.count
            self.collectionView.reloadData()
            self.getPhotosFromTheMealDB()
        }
        //  handleActivityIndicator(indicator: activityIndicator, viewController: self, isActive: false)
        
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfMeals
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionCell", for: indexPath) as! MealCollectionCell

    
        if mealImageData.indices.contains(indexPath.item), let image = UIImage(data: mealImageData[indexPath.item]) {
            
            cell.imageView.image = image
            handleActivityIndicator(indicator: cell.activityIndicator, viewController: self, isActive: false)
            
        }
        if mealsInThisCategory.indices.contains(indexPath.item) {
            cell.textView.text = mealsInThisCategory[indexPath.item].mealName
        }
        
        return cell
    }
    //  cell.textView.text = mealsInThisCategory[indexPath.item].mealName
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.chosenMealID = mealsInThisCategory[indexPath.item].mealID
        
        performSegue(withIdentifier: "SegueToDetailViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDetailViewController" {
            let detailsViewController = segue.destination as! MealDetailsViewController
            
            detailsViewController.mealID = self.chosenMealID
        }
    }
    
    
    
}



