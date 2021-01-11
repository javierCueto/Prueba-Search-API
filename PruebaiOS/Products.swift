//
//  Products.swift
//  PruebaiOS
//
//  Created by Osvaldo González on 10/01/21.
//  Copyright © 2021 Osvaldo. All rights reserved.
//

import Foundation

///MODELO PARA PARSEAR DATOS DEL JSON DE RESPUESTA DE LOS PRODUCTOS
struct Resp: Codable {
    let totalResults: Int
    let page: Int
    let items: [DataProducts]
}

struct DataProducts: Codable {
    let price: Double
    let image: String
    let title: String
}
