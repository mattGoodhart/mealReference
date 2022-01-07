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
    
    let categoriesURLString = "https://www.themealdb.com/api/json/v1/1/categories.php"
    var allCategories: [MealCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        
        // stop activity indicator if needed
        
      //  getStartedButton.isEnabled = false
        fetchCategoriesFromAPI() // if needed?
    }
    
    private func fetchCategoriesFromAPI() {
      
        guard let url = URL(string: categoriesURLString) else {
            print("couldn't create URL from categoriesURLString")
            return
        }
        
        // handle Activity Indicator and categories button
        
        Networking.shared.taskForJSON(url: url, responseType: CategoriesResponse.self) { response, error in
            
            guard let response = response else {
                print("Error fetching CategoriesResponse from theMealDB")
                print(error as Any)
                //stop activity indicator
                return // add alert message?
            }
            
            for mealCategory in response.categories {
                self.allCategories.append(mealCategory)
            }
        }
        handleActivityIndicator(indicator: activityIndicator, viewController: self, isActive: false)
        handleButton(button: getStartedButton, isEnabled: true)
    }
    
    func handleButton(button: UIButton, isEnabled: Bool) {
        if isEnabled {
            DispatchQueue.main.async {
                button.isEnabled = true
                button.alpha = 1.0
            }
        } else {
            DispatchQueue.main.async {
                button.isEnabled = false
                button.alpha = 0.5
            }
        }
    }
    
    func handleActivityIndicator(indicator: UIActivityIndicatorView, viewController: UIViewController, isActive: Bool) {
        if isActive {  DispatchQueue.main.async {
            indicator.bringSubviewToFront(viewController.view)
            indicator.startAnimating()
        }
        } else {
            DispatchQueue.main.async {
                indicator.sendSubviewToBack(viewController.view)
                indicator.stopAnimating()
            }
        }
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToCategories", sender: sender)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCategories" {
            
            let categoriesViewController = segue.destination as! CategoriesCollectionViewController
            categoriesViewController.allCategories = allCategories
        }
    }
    
    
}

    

