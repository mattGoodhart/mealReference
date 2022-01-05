//
//  MealsByCategoryResponse.swift
//  mealReference
//
//  Created by Alicia Goodhart on 1/4/22.
//

import Foundation

struct MealsByCategoryResponse: Codable {
    let result: [MealResults]
}

struct MealResults: Codable {
    let mealName: String
    let mealImageString: String
    let mealID: Int
    
    enum CodingKeys: String, CodingKey {
        case mealName = "strMeal"
        case mealImageString = "strMealThumb"
        case mealID = "idMeal"
    }
}
