//
//  RecipeService.swift
//  RecipeFinder
//
//  Created by Smith Dias on 2024-12-05.
//

import Foundation

protocol NetworkingDelegate{
    func networkDataReceived(categoryInfo: Category)
      func networkError()
//    func networkingDidFinishWithImageObj(io: ImageModel)
}

class RecipeService {
    
    var delegate : NetworkingDelegate?
    static var shared = RecipeService()
    
    
    func getDataFromURL(){
        var urlString = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?c=list")
        
        
        var dataTask = URLSession.shared.dataTask(with: urlString!){data,response,error in
            
            if let error = error{
                print("Error: \(error)")
                self.delegate?.networkError()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)
            else{
                self.delegate?.networkError()
                return
            }
            
            
            if let goodData = data{
                var decoder = JSONDecoder()
                
                do {
                    let categoryInfoFromAPI = try decoder.decode(Category.self, from: goodData)
                    
                    self.delegate?.networkDataReceived(categoryInfo: categoryInfoFromAPI)
                }catch{
                    print(error)
                }
                
                
            }
            
            
            
            
            
        }
        
        
        dataTask.resume()
        
        
        
        
        
        
        
        
        
        //    private let apiKey = "24b9d17358124147bd581c870062efe5"
        //
        //        func fetchRecipes(query: String, completion: @escaping ([Recipe]?) -> Void) {
        //            let urlString = "https://api.spoonacular.com/recipes/complexSearch?query=\(query)&apiKey=\(apiKey)"
        //            guard let url = URL(string: urlString) else {
        //                print("Invalid API")
        //                completion(nil)
        //                return
        //            }
        //
        //            let task = URLSession.shared.dataTask(with: url) { data, response, error in
        //                guard let data = data, error == nil else {
        //                    completion(nil)
        //                    return
        //                }
        //
        //                // Log the raw response (JSON)
        //                if let jsonString = String(data: data, encoding: .utf8) {
        //                print("API Response: \(jsonString)")
        //                }
        //
        //                do {
        //                    let decoder = JSONDecoder()
        //                    // Decode the top-level response, which contains the results array
        //                    let response = try decoder.decode(RecipeSearchResponse.self, from: data)
        //                    completion(response.results)  // Return the recipes
        //                } catch {
        //                    print("Error decoding data: \(error)")
        //                    completion(nil)
        //                }
        //            }
        //
        //            task.resume()
        //        }
    }
    
    
}
