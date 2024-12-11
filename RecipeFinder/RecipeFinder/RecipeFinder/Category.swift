import Foundation


struct Category: Decodable {
    let meals: [StrCategory]
}

class StrCategory: Decodable {
    let strCategory: String
    
    init(strCategory: String) {
        self.strCategory = strCategory
    }
}
