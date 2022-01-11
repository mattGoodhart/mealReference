//
//  WelcomeViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/5/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoButon: UIButton!
    
    let categoriesURLString = "https://www.themealdb.com/api/json/v1/1/categories.php"
    let model = MealReferenceModel.shared
    
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoriesFromAPIifNeeded()
    }
    
    private func fetchCategoriesFromAPIifNeeded() {
      
        guard model.allCategories.isEmpty else {
            return
        }
        
        var allCategories: [MealCategory] = []
        guard let url = URL(string: categoriesURLString) else {
            print("couldn't create URL from categoriesURLString")
            return
        }

        print("fetching categories")
        Networking.shared.taskForJSON(url: url, responseType: CategoriesResponse.self) { response, error in
            
            guard let response = response else {
                self.showAlert(message: "Error fetching CategoriesResponse from theMealDB", title: "Whoops")
                print(error as Any)
                self.handleActivityIndicator(indicator: self.activityIndicator, isActive: false)
                return
            }
            
            for mealCategory in response.categories {
                allCategories.append(mealCategory)
            }
            
            allCategories.sort { $0.category < $1.category }
            self.model.allCategories = allCategories
            self.handleActivityIndicator(indicator: self.activityIndicator, isActive: false)
            self.handleButton(button: self.getStartedButton, isEnabled: true)
        }
    }
    
    @IBAction func infoButtonTapped(sender: UIButton) {
        let popOverViewController = storyboard!.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        present(popOverViewController, animated: true, completion: nil)
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToCategories", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCategories" {
            let categoriesViewController = segue.destination as! CategoriesCollectionViewController
            categoriesViewController.allCategories = model.allCategories
        }
    }
}

    

