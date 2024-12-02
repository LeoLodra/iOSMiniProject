//
//  Model.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 02/12/24.
//

struct Meal: Decodable {
    let meals: [Menu]
}

struct Menu: Decodable {
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String?
    let strYoutube: String
}
