//
//  GetPizzasCatalogUseCase.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

protocol GetPizzasCatalogUseCase {
    func execute() async throws -> PizzasResponse
}

class GetPizzasCatalogUseCaseImpl: GetPizzasCatalogUseCase {
    private let repository: GetPizzasCatalogRepository
    
    init(repository: GetPizzasCatalogRepository) {
        self.repository = repository
    }
    
    static func create() -> GetPizzasCatalogUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .shift)
        let repository = GetPizzasCatalogRepositoryImpl(httpClient: httpClient)
        return GetPizzasCatalogUseCaseImpl(repository: repository)
    }
    
    func execute() async throws -> PizzasResponse {
        return try await repository.getPizzas()
    }
}

