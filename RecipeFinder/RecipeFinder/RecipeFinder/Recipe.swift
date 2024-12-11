
// Recipe.swift
import Foundation

struct Meal: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
  
}

struct MealResponse: Codable {
    let meals: [Meal]
}
