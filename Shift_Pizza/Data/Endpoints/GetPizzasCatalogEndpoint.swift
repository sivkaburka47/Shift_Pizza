//
//  GetPizzasCatalogEndpoint.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

import Alamofire

struct GetPizzasCatalogEndpoint: APIEndpoint {
    
    var path: String {
        return "/pizza/catalog"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
}

