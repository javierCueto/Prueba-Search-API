//
//  Product.swift
//  Prueba-Search-API
//
//  Created by Javier Cueto on 11/01/21.
//  Copyright © 2021 Osvaldo. All rights reserved.
//


struct Result: Codable {
    let totalResults: Int
    let page: Int
    let items: [Product]
    
    
}

