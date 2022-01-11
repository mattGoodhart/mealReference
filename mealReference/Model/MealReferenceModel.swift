//
//  MealReferenceModel.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/10/22.
//

import Foundation

class MealReferenceModel {
    
    static let shared = MealReferenceModel()
    private init() {}
    
    var allCategories: [MealCategory] = []
    var mealsByCategoryDictionary: [String : [MealResults] ] = [:]
    var categoryImageData: [Data] = []
    var mealImageDataByCategory: [String: [Data]] = [:]
    var mealImageDataByID: [String : Data] = [:]
    var mealDetailInfoByID: [String : MealDetailResults] = [:]
    var cleanTextByMealID: [String : String] = [:]
    
}


