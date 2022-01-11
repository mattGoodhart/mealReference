//
//  MealsByCategoryViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/5/22.
//

import UIKit

class MealsByCategoryViewController: UICollectionViewController {
    
    let model = MealReferenceModel.shared
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
    var mealNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataForMealCollectionIfNeeded()
    }
    
    func getPhotosFromTheMealDB() -> Void {
        
        for meal in mealsInThisCategory {
            self.previewURL = URL(string: meal.mealImageString + "/preview")
            self.mainImageURL = URL(string: meal.mealImageString)
            
            
            if let previewImageData = try? Data(contentsOf: previewURL)  {
                DispatchQueue.main.async {
                    self.mealImageData.append(previewImageData)
                    self.model.mealImageDataByCategory[self.thisCategory] = self.mealImageData
                    self.collectionView.reloadData()
                }
            } else {
                print("Preview photo download failure for \(previewURL.path), Grabbing the larger photo instead")
                
                guard let mainImageData = try? Data(contentsOf: self.mainImageURL) else {
                    print("Main photo download also failed")
                    return
                }
                DispatchQueue.main.async {
                    self.mealImageData.append(mainImageData)
                    self.model.mealImageDataByCategory[self.thisCategory] = self.mealImageData
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func fetchDataForMealCollectionIfNeeded() {
        
        guard model.mealsByCategoryDictionary[thisCategory] == nil else {
            mealsInThisCategory = model.mealsByCategoryDictionary[thisCategory]!
            numberOfMeals = mealsInThisCategory.count
            mealImageData = model.mealImageDataByCategory[thisCategory]!
            collectionView.reloadData()
            return
        }
        
        guard let url = URL(string: mealsByCategoryBaseURLString + thisCategory) else {
            print("Couldnt create URL from mealsByCategoryBaseURLString")
            return
        }
        
        print("fetching meals")
        Networking.shared.taskForJSON(url: url, responseType: MealsByCategoryResponse.self) { response, error in
            
            guard let response = response else {
                self.showAlert(message: "Error fetching Meals by Categories Response from theMealDB", title: "Sorry")
                print(error as Any)
                return
            }
            
            for meal in response.meals {
                self.mealsInThisCategory.append(meal)
                self.mealNames.append(meal.mealName)
            }
            
            self.numberOfMeals = self.mealsInThisCategory.count
            self.mealsInThisCategory.sort { $0.mealName < $1.mealName }
            self.model.mealsByCategoryDictionary[self.thisCategory] = self.mealsInThisCategory
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
            handleActivityIndicator(indicator: cell.activityIndicator, isActive: false)
        }
        if mealsInThisCategory.indices.contains(indexPath.item) {
            cell.label.text = mealsInThisCategory[indexPath.item].mealName.capitalized
        }

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.chosenMealID = mealsInThisCategory[indexPath.item].mealID
        self.chosenMealName = mealsInThisCategory[indexPath.item].mealName
        performSegue(withIdentifier: "SegueToDetailViewController", sender: self)
    }
}




