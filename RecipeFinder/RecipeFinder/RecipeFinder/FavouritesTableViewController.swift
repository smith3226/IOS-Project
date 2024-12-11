import UIKit
import CoreData

class FavouritesTableViewController: UITableViewController {
    
    // Array to store fetched favorite recipes
    var favouriteRecipes: [RecipeCoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        loadFavouriteRecipes()
    }
    
    // Fetch all favorite recipes from Core Data
    func loadFavouriteRecipes() {
        // Get the favorite recipes from CoreDataManager
        self.favouriteRecipes = CoreDataManager.shared.getAllRecipeFromDB()
        
        // Reload the table view to display the data
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Only one section to display the recipes
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of favorite recipes
        return favouriteRecipes.count
    }
    
    // Configure the cells with the recipe data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuse a cell for better performance
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteRecipeCell", for: indexPath)
        
        // get the favorite recipe for the current row
        let recipe = favouriteRecipes[indexPath.row]
        
      
        cell.textLabel?.text = recipe.name
        
       
        if let imageData = recipe.image {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    // MARK: - Editing the table (optional)
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Delete  recipe from the favorites list
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // get the recipe to delete
            let recipeToDelete = favouriteRecipes[indexPath.row]
            
            
            CoreDataManager.shared.deleteOneRecipe(todelete: recipeToDelete)
            
            // remove the recipe from the data source
            favouriteRecipes.remove(at: indexPath.row)
            
            // delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? FavouriteDetailsViewController {
            // pass the selected recipe to the next view controller
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRecipe = favouriteRecipes[indexPath.row]
                destinationVC.recipe = selectedRecipe
            }
        }
    }
}

