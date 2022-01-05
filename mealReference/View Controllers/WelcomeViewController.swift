//
//  WelcomeViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/5/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let categoriesURLString = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoriesFromAPI()
    }
    
    
    
    private func fetchCategoriesFromAPI() {
      
        let url = URL(string: categoriesURLString)
        
        // handle Activity Indicator and categories button
        
        Networking.shared.taskForJSON(url: url, responseType: CategoriesResponse.self) { response, error in
            
            guard let response = response else {
                print(error)
                
                //stop activity indicator
                return // add alert message?
            }
            
            for item in response.result {
                
            }
            
            
            
        }
    }
}
