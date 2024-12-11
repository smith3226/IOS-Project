import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NetworkingDelegate {
    func networkDataReceived(categoryInfo: Category) {
        DispatchQueue.main.async {
            
            self.categories = categoryInfo.meals.map { $0.strCategory }
            print("Categories loaded: \(self.categories)")
            self.tableView.reloadData()
        }
    }

    func networkError() {
        DispatchQueue.main.async {
            print("Failed to fetch data from the server.")
            let alert = UIAlertController(title: "Error", message: "Unable to fetch categories. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    var selectedCategory = ""
    var categories: [String] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Inside app")

        guard let tableView = tableView else {
            print("TableView is nil")
            return
        }

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")

        // Set up networking delegate and fetch data
        RecipeService.shared.delegate = self
        RecipeService.shared.getDataFromURL()
    }

    // MARK: - TableView Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }

    // Handle category selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: "toRecipeList", sender: selectedCategory)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeList" {
            if let recipeVC = segue.destination as? FindRecipeTableViewController {
                recipeVC.category = selectedCategory
            }
        }
    }
}
