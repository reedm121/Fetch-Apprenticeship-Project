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

enum MealCategory: String {
    case beef = "Beef"
    case chicken = "Chicken"
    case dessert = "Dessert"
    case lamb = "Lamb"
    case misc = "Miscellaneous"
    case pasta = "Pasta"
    case pork = "Pork"
    case seafood = "Seafood"
    case side = "Side"
    case starter = "Starter"
    case vegan = "Vegan"
    case vegetarian = "Vegetarian"
    case breakfast = "Breakfast"
    case goat = "Goat"
}

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

enum apiError: Error {
    case invalidURL
}

struct Meal: Codable, Identifiable, Hashable {
    let id: UUID = UUID()
    
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}

struct MealsData: Codable {
    var meals: [Meal]
}

struct Recipe: Codable, Identifiable {
    let id: UUID = UUID()
    
    var ingredients: [String] = [String]()
    
    var idMeal: String
    var strMeal: String
    var strDrinkAlternate: String?
    var strCategory: String
    var strArea: String
    var strInstructions: String
    var strMealThumb: String
    var strTags: String?
    var strYoutube: String
    var strSource: String?
    
    private enum ingredient: String, CodingKey, CaseIterable, Codable {
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
    }
    
    private enum measurement: String, CodingKey, CaseIterable, Codable {
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    private enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strDrinkAlternate
        case strCategory
        case strArea
        case strInstructions
        case strMealThumb
        case strTags
        case strYoutube
        case strSource
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idMeal = try container.decode(String.self, forKey: .idMeal)
        self.strMeal = try container.decode(String.self, forKey: .strMeal)
        self.strDrinkAlternate = try container.decodeIfPresent(String.self, forKey: .strDrinkAlternate)
        self.strCategory = try container.decode(String.self, forKey: .strCategory)
        self.strArea = try container.decode(String.self, forKey: .strArea)
        self.strInstructions = try container.decode(String.self, forKey: .strInstructions).normalizeNewlines()
        self.strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        self.strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        self.strYoutube = try container.decode(String.self, forKey: .strYoutube)
        self.strSource = try container.decodeIfPresent(String.self, forKey: .strSource)
        
        let ingredientsContainer = try decoder.container(keyedBy: ingredient.self)
        let measurementsContainer = try decoder.container(keyedBy: measurement.self)
        
        var tmpIngredients = [String]()
        var tmpMeasurements = [String]()
            
        for ingredientKey in ingredient.allCases {
            if let ingredient = try? ingredientsContainer.decode(String.self, forKey: ingredientKey) {
                tmpIngredients.append(ingredient)
            }
        }
        
        for measurementKey in measurement.allCases {
            if let measurement = try? measurementsContainer.decode(String.self, forKey: measurementKey) {
                tmpMeasurements.append(measurement)
            }
        }
        
        for (i, ingredient) in tmpIngredients.enumerated() {
            if(!ingredient.isEmpty){
                self.ingredients.append(tmpMeasurements[i].trimWhitespace() + " " + ingredient.trimWhitespace())
            }
        }
    }
    
    internal init(ingredients: [String] = [String](), measurements: [String] = [String](), idMeal: String, strMeal: String, strDrinkAlternate: String? = nil, strCategory: String, strArea: String, strInstructions: String, strMealThumb: String, strTags: String? = nil, strYoutube: String, strSource: String) {
        self.ingredients = ingredients
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strDrinkAlternate = strDrinkAlternate
        self.strCategory = strCategory
        self.strArea = strArea
        self.strInstructions = strInstructions
        self.strMealThumb = strMealThumb
        self.strTags = strTags
        self.strYoutube = strYoutube
        self.strSource = strSource
    }
}

struct RecipeData: Decodable {
    let meals: [Recipe]
}

public func isYouTubeVideoAvailable(urlString: String) async -> Bool {
    guard let url = URL(string: "https://www.youtube.com/oembed?url=\(urlString)&format=json") else {
        return false
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    do {
        let (_, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            return true
        } else {
            return false
        }
    } catch {
        return false
    }
}
