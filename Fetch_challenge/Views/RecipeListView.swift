//
//  RecipeListView.swift
//  Fetch_challenge
//
//  Created by Reed Gantz on 7/16/24.
//

import SwiftUI

struct RecipeListView: View {
    var mealCategory: MealCategory
    @ObservedObject var mealsAPI = MealsAPI()
    @State var searchQuery: String = ""
    @State var meals = [Meal]()
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(filteredMeals) { meal in
                    NavigationLink(value: meal){
                        HStack {
                            if let url = URL(string: meal.strMealThumb) {
                                CachedAsyncImage(url: url)
                                    .frame(width: 125, height: 125)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            
                            Text(meal.strMeal)
                            
                            Spacer()
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.secondarySystemGroupedBackground)))
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2))
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always))
            .navigationDestination(for: Meal.self){ meal in
                RecipeView(recipeItem: meal)
            }
            .task {
                do{
                    self.meals = try await mealsAPI.fetchMealsByCategory(mealCategory: mealCategory)
                }
                catch{
                    print("error while fetching list of meals: \(error)")
                }
            }
            
        }
    }
    
    var filteredMeals: [Meal]{
        if searchQuery.isEmpty{
            return meals
        }
        else{
            return meals.filter { $0.strMeal.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
}

#Preview {
    NavigationStack{
        RecipeListView(mealCategory: .dessert).navigationTitle("Desserts")
    }
}
