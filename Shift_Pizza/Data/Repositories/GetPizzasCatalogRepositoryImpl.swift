//
//  GetPizzasCatalogRepositoryImpl.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

class GetPizzasCatalogRepositoryImpl: GetPizzasCatalogRepository {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getPizzas() async throws -> PizzasResponse {
        let endpoint = GetPizzasCatalogEndpoint()
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
    
}
