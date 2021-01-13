//
//  ProductsService.swift
//  Prueba-Search-API
//
//  Created by Javier Cueto on 11/01/21.
//  Copyright © 2021 Osvaldo. All rights reserved.
//

import Foundation

class ProductsService{
    
    static func getProductHistory(completion: @escaping([String]) -> Void){
        let defaults = UserDefaults.standard
        let data = defaults.stringArray(forKey: "historyArray") ?? [String]()
        completion(data)
    }
    
    static func setProductHistory(history: [String]  , completion: @escaping(Bool) -> Void){
  
        let defaults = UserDefaults.standard
        defaults.set(history, forKey: "historyArray")
        completion(true)
    }
    

    static func fetchProducts(toSearch: String,completion: @escaping(Result,_ error:String?) -> Void){
        
        var results: Result?
        guard let urlString = "\(API_PRODUCTS)\(toSearch)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        let url = URL(string: urlString)
 
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue(TOKEN, forHTTPHeaderField:"X-IBM-Client-Id")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data{
                
                do {
                    
                    results = try JSONDecoder().decode(Result.self, from: data)
                    guard let saveResults = results else {return}
                    DispatchQueue.main.async {
                        completion(saveResults, nil)
                    }
                    
                    
                    
                }catch(let error){
                    let results = Result(totalResults: 1, page: 1, items: [Product(price: 1, image: "", title: "")])
                    completion(results, error.localizedDescription)
                }
                
            }
            
        }.resume()
        
    }
}
