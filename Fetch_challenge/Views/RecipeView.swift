//
//  RecipeView.swift
//  Fetch_challenge
//
//  Created by Reed Gantz on 7/16/24.
//

import SwiftUI

struct RecipeView: View {
    var recipeItem: Meal
    @State var recipe: Recipe?
    
    @ObservedObject var mealsAPI = MealsAPI()
    @State private var checkedIngredients: [Bool] = []
    @State private var isVideoAvailable: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                if let recipe = recipe{
                    if let url = URL(string: recipe.strMealThumb){
                        CachedAsyncImage(url: url)
                            .clipped()
                            .clipShape(.rect(cornerRadius: 20))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, minHeight: 100)
                    }
                    
                    VStack (alignment: .leading){
                        Text("Ingredients").font(.headline).padding(.bottom, 2)
                        ForEach(recipe.ingredients.indices, id: \.self){ index in
                            HStack(alignment: .top) {
                                Button(action: {
                                    checkedIngredients[index].toggle()
                                }) {
                                    let config = UIImage.SymbolConfiguration(scale: .small)
                                    Image(systemName: checkedIngredients[index] ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(checkedIngredients[index] ? .secondary : .secondary)
                                        .font(.system(size: 20))
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Text(recipe.ingredients[index])
                            }.padding(.vertical, 0.1)
                        }
                        
                        Spacer().frame(height: 20)
                        
                        Text("Instructions").font(.headline).padding(.bottom, 2)
                        Text(recipe.strInstructions)
                        
                        // YouTube Video Section
                        if isVideoAvailable {
                            Text("Watch on YouTube")
                                .font(.headline)
                                .padding(.top, 20)
                            
                            WebView(url: URL(string: recipe.strYoutube)!)
                                .frame(height: 300) // Adjust height as needed
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        } else {
                            //yt video unavailable
                        }
                    }.padding()
                    
                }
                else{
                    Text("sorry, that recipe couldn't be found :(")
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .navigationTitle(recipeItem.strMeal)
            .task {
                do{
                    self.recipe = try await mealsAPI.fetchRecipeByMealId(mealId: recipeItem.idMeal)
                    if let recipe = self.recipe {
                        self.checkedIngredients = Array(repeating: false, count: recipe.ingredients.count)
                        self.isVideoAvailable = await isYouTubeVideoAvailable(urlString: recipe.strYoutube)
                    }

                }
                catch{
                    print("Failed to fetch recipe: \(error)")
                }
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        RecipeView(recipeItem: Meal(strMeal: "Banana Pancakes", strMealThumb: "https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg", idMeal: "52855"))
    }
}
