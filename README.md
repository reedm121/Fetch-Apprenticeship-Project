# Dessert Recipes App

Dessert Recipes App is a native iOS application that allows users to browse dessert recipes using the MealDB API. Users can view a list of dessert recipes, sorted alphabetically, and see detailed information about each recipe including meal name, instructions, and ingredients/measurements.

## Features

- Browse a list of dessert recipes sorted alphabetically.
- View detailed recipe information including meal name, instructions, and ingredients/measurements.
    - also includes a checklist for ingredients, and a YouTube video if it's available for the recipe

## API Endpoints

This app utilizes the following API endpoints from [TheMealDB](https://themealdb.com/api.php):

1. **List of Dessert Meals**: [https://themealdb.com/api/json/v1/1/filter.php?c=Dessert](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert)
   - The app is actually more extensible if need be, under the hood **RecipeListView** can display recipes from any category from the TheMealDB if the category is passed as a parameter to the view
2. **Meal Details by ID**: [https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID](https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID)


## Code Structure

### Models

- **Meal**: Represents a meal with basic details (name, thumbnail, ID).
- **Recipe**: Represents detailed recipe information including ingredients and instructions.
- **MealsData**: Represents the response structure for fetching meals.
- **RecipeData**: Represents the response structure for fetching a recipe.

### Views

- **ContentView**: The main entry point of your SwiftUI views.
  
- **RecipeListView**: Displays a list of meals in the Dessert category, sorted alphabetically. *(Note: This view is made modular and can be used with any meal category from TheMealDB.)*
  - **Parameters**:
    - `mealCategory`: A `MealCategory` enum value representing the meal category to fetch and display.
- **RecipeView**: Displays detailed recipe information including meal name, instructions, and ingredients/measurements.
  - **Parameters**:
    - `recipeItem`: A `Meal` object representing the selected meal for which the details are to be displayed.
      
- **UtilityViews**: Contains utility views that support other views.
  - **CachedAsyncImage**: A custom view that asynchronously loads an image from a URL and caches it to improve performance and reduce network usage when the image is requested multiple times.
  - **WebView**: A custom view for displaying YouTube videos.

### View Models

- **MealsAPI**: Handles fetching meals and recipes from the API using Swift Concurrency (async/await).
- **APIHelpers**: Contains helper functions, including `isYouTubeVideoAvailable` to check YouTube video availability.

### Utilities

- **String Extensions**:
  - `trimWhitespace()`: Trims leading and trailing whitespace from a string.
  - `normalizeNewlines()`: Removes carriage return characters and ensures only double newlines are used.

 ## Author

Developed by Reed Gantz
