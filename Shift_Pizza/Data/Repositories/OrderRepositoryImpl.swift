//
//  OrderRepositoryImpl.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 31.01.2025.
//

class OrderRepositoryImpl: OrderRepository {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func payOrder(request: CreatePizzaPaymentDto) async throws -> PizzaPaymentResponse {
        let endpoint = PayOrderEndPoint()
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: request)
    }

}

