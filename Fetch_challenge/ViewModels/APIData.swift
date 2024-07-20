//
//  APIData.swift
//  Fetch_challenge
//
//  Created by Reed Gantz on 7/16/24.
//

import Foundation

//var DESSERTS_ENDPOINT: String = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
var MEALCATEGORY_BASE_ENDPOINT = "https://themealdb.com/api/json/v1/1/filter.php?c="
var MEALRECIPE_BASE_ENDPOINT = "https://themealdb.com/api/json/v1/1/lookup.php?i="

/// This class should be used anywhere data is needed from TheMealDB
class MealsAPI: ObservableObject {
    /**
     Fetches a list of meals for a given meal category.
     
     - Parameter mealCategory: The category of meals to fetch.
     - Returns: An array of `Meal` objects.
     - Throws: An `apiError.invalidURL` if the URL is invalid.
     
     This method constructs a URL from the meal category endpoint and the provided meal category, sends a network request to fetch the data, and decodes the response into an array of `Meal` objects.
     */
    func fetchMealsByCategory(mealCategory: MealCategory) async throws -> [Meal]{
        guard let url = URL(string: MEALCATEGORY_BASE_ENDPOINT + mealCategory.rawValue)
        else{
            print("invalid url")
            throw apiError.invalidURL
        }
        
        print("trying to load data from \(mealCategory)..." )
        
        let request = URLRequest(url: url)
        
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            let mealsData = try JSONDecoder().decode(MealsData.self, from: data)
            
            return mealsData.meals
        }
        catch{
            print("an error occurred")
            print("\(error)")
        }
        
        return [Meal]()
    }
    
    /**
     Fetches the recipe for a given meal ID.
     
     - Parameter mealId: The ID of the meal to fetch the recipe for.
     - Returns: A `Recipe` object if the fetch is successful, otherwise returns a default "dud" recipe.
     - Throws: An `apiError.invalidURL` if the URL is invalid.
     
     This method constructs a URL from the meal lookup endpoint and the provided meal ID, sends a network request to fetch the data, and decodes the response into a `Recipe` object.
     */
    func fetchRecipeByMealId(mealId: String) async throws -> Recipe? {
        guard let url = URL(string: MEALRECIPE_BASE_ENDPOINT + mealId)
        else{
            print("invalid url")
            throw apiError.invalidURL
        }
        
        print("trying to load recipe for mealId: \(mealId)..." )
        
        let request = URLRequest(url: url)
        
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            let recipeData = try JSONDecoder().decode(RecipeData.self, from: data)
            
            return recipeData.meals[0]
        }
        catch{
            print("an error occurred")
            print("\(error)")
        }
        
        //if we get here, an error occured or a request was made to a bad endpoint so returns a dud recipe for now
        return Recipe(idMeal: "", strMeal: "error", strCategory: "", strArea: "", strInstructions: "", strMealThumb: "https://www.themealdb.com/images/category/dessert.png", strYoutube: "", strSource: "")
    }
    
}
