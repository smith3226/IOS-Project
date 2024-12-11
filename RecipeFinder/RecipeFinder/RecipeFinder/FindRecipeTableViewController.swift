import UIKit

class FindRecipeTableViewController: UITableViewController {

    var category = ""
    var meals: [Meal] = []
    var selectedMealID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMeals(byCategory: category)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)
        let meal = meals[indexPath.row]
        cell.textLabel?.text = meal.strMeal
        return cell
    }

    // MARK: - API Fetch

    func fetchMeals(byCategory category: String) {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching meals: \(error)")
                return
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode(MealResponse.self, from: data)
                    self.meals = response.meals
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding meals: \(error)")
                }
            }
        }.resume()
    }

    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        selectedMealID = meals[indexPath.row].idMeal
        performSegue(withIdentifier: "todesc", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todesc" {
           
            if let recipeVC = segue.destination as? RecipeDetailsViewController {
                recipeVC.mealId = selectedMealID
            }
        }
    }
}

