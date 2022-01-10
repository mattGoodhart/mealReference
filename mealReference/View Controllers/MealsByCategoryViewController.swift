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
    var chosenMealName: String = ""
    var previewURL: URL!
    var mainImageURL: URL!
    var upperCasedMealNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataForMealCollection()
    }
    
    func getPhotosFromTheMealDB() -> Void {

        for meal in mealsInThisCategory {
            self.previewURL = URL(string: meal.mealImageString + "/preview")
            self.mainImageURL = URL(string: meal.mealImageString)
            
            
            if let previewImageData = try? Data(contentsOf: previewURL)  {
                DispatchQueue.main.async {
                    self.mealImageData.append(previewImageData)
                    self.collectionView.reloadData()
                }
            }
            else {
                print("Preview Photo Download Failure for \(previewURL.path), Grabbing the Main Photo Instead")
                
                guard let mainImageData = try? Data(contentsOf: self.mainImageURL) else {
                    print("Main Photo Download Also Failed")
                    return
                }
                DispatchQueue.main.async {
                    self.mealImageData.append(mainImageData)
                    self.collectionView.reloadData()
                }
            }
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
                
                return // add alert message?
            }
            
            for meal in response.meals {
                self.mealsInThisCategory.append(meal)
                self.upperCasedMealNames.append(meal.mealName.capitalized)
            }
            
            self.numberOfMeals = self.mealsInThisCategory.count
            self.mealsInThisCategory.sort { $0.mealName < $1.mealName } // this isnt working when secondary image is used?
            self.upperCasedMealNames.sort { $0 < $1 }
            self.getPhotosFromTheMealDB()
        }
     
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDetailViewController" {
            let detailsViewController = segue.destination as! MealDetailsViewController
            
            detailsViewController.mealID = self.chosenMealID
            detailsViewController.mealName = self.chosenMealName
        }
    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfMeals
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionCell", for: indexPath) as! MealCollectionCell
        
        
        if mealImageData.indices.contains(indexPath.item), let image = UIImage(data: mealImageData[indexPath.item]) {
            cell.imageView.image = image
            handleActivityIndicator(indicator: cell.activityIndicator, viewController: self, isActive: false)
        }
        
        if upperCasedMealNames.indices.contains(indexPath.item) {
            cell.label.text = upperCasedMealNames[indexPath.item]
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.chosenMealID = mealsInThisCategory[indexPath.item].mealID
        performSegue(withIdentifier: "SegueToDetailViewController", sender: self)
    }
}



