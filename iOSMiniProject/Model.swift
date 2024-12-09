//
//  Model.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 02/12/24.
//

struct Meal: Codable {
    let meals: [Menu]
}

struct Menu: Codable, Equatable {
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String?
    let strYoutube: String
    
    let strIngredient1: String?
    
    let strMeasure1: String?
}

