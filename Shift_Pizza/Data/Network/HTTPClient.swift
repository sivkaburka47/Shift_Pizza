//
//  HTTPClient.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

protocol HTTPClient {
    func sendRequest<T: Decodable, U: Encodable>(endpoint: APIEndpoint, requestBody: U?) async throws -> T
    func sendRequestWithoutResponse<U: Encodable>(endpoint: APIEndpoint, requestBody: U?) async throws
}
