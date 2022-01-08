//
//  CategoriesResponse.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/4/22.
//

import Foundation

struct CategoriesResponse: Codable {
    let categories: [MealCategory]
}

struct MealCategory: Codable {
    let categoryID: String
    let category: String
    let categoryImageString: String
    let categoryDescription: String
    let imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "idCategory"
        case category = "strCategory"
        case categoryImageString = "strCategoryThumb"
        case categoryDescription = "strCategoryDescription"
        case imageData
    }
}
