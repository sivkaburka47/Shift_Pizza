//
//  PayOrderEndPoint.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 31.01.2025.
//

import Alamofire

struct PayOrderEndPoint: APIEndpoint {
    
    var path: String {
        return "/pizza/payment"
    }
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
}


