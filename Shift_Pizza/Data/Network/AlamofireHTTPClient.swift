//
//  AlamofireHTTPClient.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

import Alamofire
import Foundation

// MARK: - AlamofireHTTPClient
final class AlamofireHTTPClient: HTTPClient {
    private let baseURL: BaseURL
    
    init(baseURL: BaseURL) {
        self.baseURL = baseURL
    }
    
    func sendRequest<T: Decodable, U: Encodable>(endpoint: APIEndpoint, requestBody: U? = nil) async throws -> T {
        let url = baseURL.baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .response() { response in
                    self.log(response)
                }
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        continuation.resume(returning: decodedData)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    
    func sendRequestWithoutResponse<U: Encodable>(endpoint: APIEndpoint, requestBody: U? = nil) async throws {
        let url = baseURL.baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}

// MARK: - Requests Logging
private extension AlamofireHTTPClient {
    func log(_ response: AFDataResponse<Data?>) {
        print("---------------------------------------------------------------------------------------")
        
        let method = response.request?.method?.rawValue ?? "UNKNOWN"
        let url = response.request?.url?.absoluteString ?? "UNKNOWN URL"
        let statusCode = response.response?.statusCode ?? 0
        let dateString = ISO8601DateFormatter().string(from: Date())
        
        print("[\(dateString)] \(method) \(url)")
        print("Status Code: \(statusCode)")
        
        if let requestHeaders = response.request?.headers {
            print("Request Headers: \(requestHeaders)")
        }
        if let responseHeaders = response.response?.headers {
            print("Response Headers: \(responseHeaders)")
        }
        
        print("---------------------------------------------------------------------------------------")
        
        switch response.result {
        case let .success(responseData):
            if let data = responseData, !data.isEmpty {
                if let object = try? JSONSerialization.jsonObject(with: data),
                   let formattedData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
                   let jsonString = String(data: formattedData, encoding: .utf8) {
                    print("Response JSON:\n\(jsonString)")
                }
            } else {
                print("Response JSON: {} (empty)")
            }
        case let .failure(error):
            print("Request Failed: \(error.localizedDescription)")
        }
        
        print("---------------------------------------------------------------------------------------")
    }
}
