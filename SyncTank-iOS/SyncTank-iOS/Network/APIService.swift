//
//  APIService.swift
//  SyncTank-iOS
//
//  Created by Demian Yoo on 8/23/25.
//

import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}
    
    func saveDocs(_ item: DashItemRequest) async -> Result<SaveDocsResModel, APIError> {
        let url = API.baseURL.appendingPathComponent(API.Path.saveDocs)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        guard let body = try? encoder.encode(item) else {
            return .failure(.encoding)
        }
        
        request.httpBody = body
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            return .failure(.networkError)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        switch httpResponse.statusCode {
        case 200:
            guard let decodedResponse = try? JSONDecoder().decode(BaseModel<SaveDocsResModel>.self, from: data) else {
                return .failure(.decoding)
            }
            return .success(decodedResponse.data)
        case 422:
            return .failure(.validation("Validation failed: \(String(data: data, encoding: .utf8) ?? "")"))
        case 500:
            guard let errorMessage = try? JSONDecoder().decode(BaseModel<ErrorResModel>.self, from: data) else {
                return .failure(.decoding)
            }
            return .failure(.serverError(errorMessage.detail))
        default:
            return .failure(.unknown)
        }
    }
    
    func fetchDocs() async -> Result<[DashItem], APIError> {
        let url = API.baseURL.appendingPathComponent(API.Path.fetchDocs)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        guard let (data, response) = try? await session.data(for: request) else {
            return .failure(.networkError)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let model = try decoder.decode(BaseModel<[DashItem]>.self, from: data)
                return .success(model.data)
            } catch {
                return .failure(.decoding)
            }
            
        case 422:
            return .failure(.validation("Validation failed"))
        case 500:
            guard let errorMessage = try? JSONDecoder().decode(BaseModel<ErrorResModel>.self, from: data) else {
                return .failure(.decoding)
            }
            return .failure(.serverError(errorMessage.detail))
        default:
            return .failure(.unknown)
        }
    }
}
