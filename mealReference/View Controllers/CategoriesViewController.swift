//
//  ViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/4/22.
//

import UIKit

class ViewController: UIViewController {
    
    var allCategories : [CategoryResults] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoriesFromAPI()
    }
    
//    private func parseCategories(jsonData: Data) {
//        do {
//            let decodedData = try JSONDecoder().decode(CategoriesResponse.self, from: jsonData)
//
//            for category in decodedData.result {
//                allCategories.append(category)
//            }
//        } catch {
//            print("category JSON decoding error")
//        }
//    }
    

    
    
    
    
    
    
}
    



