//
//  ProductViewModel.swift
//  Prueba-Search-API
//
//  Created by Javier Cueto on 11/01/21.
//  Copyright © 2021 Osvaldo. All rights reserved.
//

import UIKit

class ProductCellViewModel {
    
    private let product: Product
    
    
    var title: String {
        return product.title
    }
    
    init (product: Product){
        self.product = product
    }
}
