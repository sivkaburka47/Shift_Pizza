//
//  PayForOrderUseCase.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 31.01.2025.
//

protocol PayForOrderUseCase {
    func execute(request: CreatePizzaPaymentDto) async throws -> PizzaPaymentResponse
}

class PayForOrderUseCaseImpl: PayForOrderUseCase {
    private let repository: OrderRepository
    
    init(repository: OrderRepository) {
        self.repository = repository
    }
    
    static func create() -> PayForOrderUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .shift)
        let repository = OrderRepositoryImpl(httpClient: httpClient)
        return PayForOrderUseCaseImpl(repository: repository)
    }
    
    
    func execute(request: CreatePizzaPaymentDto) async throws -> PizzaPaymentResponse {
        return try await repository.payOrder(request: request)
    }
}
