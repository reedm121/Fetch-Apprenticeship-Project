//
//  ContentView.swift
//  Fetch_challenge
//
//  Created by Reed Gantz on 7/16/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            RecipeListView(mealCategory: .dessert)
            .navigationTitle("Desserts")
        }
    }
}

#Preview {
    ContentView()
}
