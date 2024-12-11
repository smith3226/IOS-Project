import UIKit

class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    
    
    var mealId: String?
    var ingredientsText: String = ""
    var instructionsText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let mealId = mealId {
            fetchMealDetails(byId: mealId)
        }
    }
    
  
    
    @IBAction func saveRecipeInfo(_ sender: Any) {
        print("Inside button")
    
        
        let context = CoreDataManager.shared.persistentContainer.viewContext

        let recipeEntity = RecipeCoreData(context: context)
        
        // Ensure all required fields are not empty
        guard let title = titleLabel.text, !title.isEmpty,
              !ingredientsText.isEmpty,
//              let description = descriptionTextView.text, !description.isEmpty,
              let image = imageView.image, let imageData = image.pngData() else {
            print("Missing data to save recipe")
            return
        }
        
        // Set the properties of the new recipe entity
        recipeEntity.name = titleLabel.text
//        recipeEntity.ingredients = ingredientsText
//        recipeEntity.recipe_description = descriptionTextView.text
        recipeEntity.image = imageData

        
        // Save to Core Data using the context
        do {
            try context.save()
            
           
            let alert = UIAlertController(title: "Success", message: "Recipe saved successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } catch {
            
            print("Error saving recipe: \(error.localizedDescription)")
        }
    }

    // Method to load image asynchronously
    func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            self.imageView.image = image
                        }
                    }
                }
            }.resume()
        }
    }
    
    // Method to fetch meal details from API
    func fetchMealDetails(byId id: String) {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            print("Error: Unable to create URL with ID \(id)")
            return
        }
        
        print("Fetching meal details with ID: \(id)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching meal details: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(IngredientResponse.self, from: data)
                    if let meal = response.meals.first {
                        DispatchQueue.main.async {
                            self.displayMealDetails(meal: meal)
                        }
                    } else {
                        print("No meal found for ID \(id)")
                    }
                } catch {
                    print("Error decoding meal details: \(error)")
                }
            } else {
                print("No data received from API")
            }
        }.resume()
    }

    // Method to display meal details
    func displayMealDetails(meal: Ingredients) {
        titleLabel.text = meal.strMeal
        loadImage(from: meal.strMealThumb)
        
        var ingredientsText = "Ingredients:\n\n"
        
      
        let ingredientSymbol = "🍴 "
        // Loop through ingredients and measure values
        let ingredientKeys = [
            meal.strIngredient1, meal.strIngredient2, meal.strIngredient3, meal.strIngredient4, meal.strIngredient5,
            meal.strIngredient6, meal.strIngredient7, meal.strIngredient8, meal.strIngredient9, meal.strIngredient10
        ]
        let measureKeys = [
            meal.strMeasure1, meal.strMeasure2, meal.strMeasure3, meal.strMeasure4, meal.strMeasure5,
            meal.strMeasure6, meal.strMeasure7, meal.strMeasure8, meal.strMeasure9, meal.strMeasure10
        ]
        
        // Create the ingredients text
        for (ingredient, measure) in zip(ingredientKeys, measureKeys) {
            if let ingredient = ingredient, !ingredient.isEmpty, let measure = measure, !measure.isEmpty {
               
                ingredientsText += "\(ingredientSymbol)\(ingredient): \(measure)\n\n"
            }
        }
        
        // Store the ingredients text
        self.ingredientsText = ingredientsText
        self.instructionsText = "Instructions:\n\n\(meal.strInstructions)"
        
        descriptionTextView.text = instructionsText
    }

    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            descriptionTextView.text = ingredientsText
        } else {
            descriptionTextView.text = instructionsText
        }
    }
}

