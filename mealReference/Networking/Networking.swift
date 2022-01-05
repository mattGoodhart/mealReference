//
//  Networking.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/4/22.
//

import Foundation

//
//enum EndPoints {
//
//    static let base = "https://www.themealdb.com/api/json/v1/1"
//
//    case categories
//    case filterByCategory
//    case mealDetails
//
//    var stringValue: String {
//        switch self {
//        case .categories: return: EndPoints.base + "categories.php"
//        case .
//
//        }
//    }
//}



class Networking {
    
    static let shared = Networking()
    private init() {}
    
    func taskForJSON<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            guard error == nil, let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                    print(error!)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                    print(error)
                }
            }
        }
        task.resume()
    }
}
