import UIKit

class FavouriteDetailsViewController: UIViewController {
    
    // Recipe passed from the table view
    var recipe: RecipeCoreData?
    
    @IBOutlet weak var recipe_title: UILabel!
    @IBOutlet weak var image: UIImageView!
 
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Display the recipe details if available
        if let recipe = recipe {
            recipe_title.text = recipe.name
            if let imageData = recipe.image {
                image.image = UIImage(data: imageData)
            }
           
        }
        
       
    }

   
    
}

