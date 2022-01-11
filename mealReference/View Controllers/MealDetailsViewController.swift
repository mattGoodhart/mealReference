//
//  MealDetailsViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/5/22.
//

import UIKit

class MealDetailsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var allTextLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    let model = MealReferenceModel.shared
    var mealDetailsBaseURLString: String = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    var mealID: String = ""
    var mealName: String = ""
    var chosenMealDetails: MealDetailResults!
    var newIngredientsAndMeasures: [String] = []
    var formattedInstructions: String = ""
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = mealName.capitalized
        fetchMealDetailsIfNeeded()
    }
    
    func loadDetailPhotoFromURL(url: URL) {
        
        Networking.shared.fetchData(at: url) { data in
            
            guard let data = data else {
                print("Photo Download Failure")
                return
            }
            let image = UIImage(data: data)
            self.model.mealImageDataByID[self.mealID] = data
            self.imageView.image = image
            self.handleActivityIndicator(indicator: self.activityIndicator, isActive: false)
        }
    }
   
    func setUpView() {
        makeCleanLabelText()
        let urlString = self.chosenMealDetails.mealImageURL
        
        if let url = URL(string: urlString) {
            self.loadDetailPhotoFromURL(url: url)
        }
    }
    
    func parseMealDetails() {
        
        var cleanIngredientsStringArray: [String] = []
        var cleanMeasuresStringArray: [String] = []
        let mirror = Mirror(reflecting: self.chosenMealDetails!)
        
        for child in mirror.children {
            
            if let label = child.label, let value = child.value as? String {
                
                if (value != "" && value != " " && value != "  ")  {
                    
                    if label.prefix(10) == "ingredient" {
                        cleanIngredientsStringArray.append(value + " - ")
                        
                    } else if label.prefix(7) == "measure" {
                        cleanMeasuresStringArray.append(value + "\n")
                    }
                }
                formattedInstructions = chosenMealDetails.instructions.replacingOccurrences(of: "\n", with: "\n\n")
                newIngredientsAndMeasures = zip(cleanIngredientsStringArray, cleanMeasuresStringArray).map(+)
            }
            makeCleanLabelText()
        }
        setUpView()
    }
    
    func makeCleanLabelText() {
        var newIngredientsText: String = ""
        
        for item in newIngredientsAndMeasures {
            newIngredientsText += item
        }
        
        allTextLabel.text = newIngredientsText + "\n\n\n ------==============------ \n\n\n\n" + formattedInstructions
        model.cleanTextByMealID[mealID] = allTextLabel.text
    }
    
    func fetchMealDetailsIfNeeded() {
        
        guard model.mealImageDataByID[mealID] == nil, model.mealDetailInfoByID[mealID] == nil else {
            
            chosenMealDetails = model.mealDetailInfoByID[mealID]
            navigationItem.title = chosenMealDetails.mealName.capitalized
            allTextLabel.text = model.cleanTextByMealID[mealID]
            
            if let image = UIImage(data: model.mealImageDataByID[mealID]!) {
                imageView.image = image
            }
            
            handleActivityIndicator(indicator: activityIndicator, isActive: false)
            return
        }
        
        guard let url = URL(string: mealDetailsBaseURLString + mealID) else {
            print("Couldnt Create URL for Meal Details")
            return
        }
        
        print("fetching meal details")
        Networking.shared.taskForJSON(url: url, responseType: MealDetailsResponse.self) { response, error in
            
            guard let response = response else {
                self.handleActivityIndicator(indicator: self.activityIndicator, isActive: false)
                self.showAlert(message: "Error fetching Meal Details Response from theMealDB", title: "oops")
                print(error as Any)
                return
            }
            self.chosenMealDetails = response.meals.first
            self.model.mealDetailInfoByID[self.mealID] = self.chosenMealDetails
            self.parseMealDetails()
        }
    }
}







