//
//  OpenWeatherManagerAF.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 29/3/26.
//
import Alamofire
import Foundation

final class OpenWeatherManagerAF: NetworkingManager {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func fetch<T>(with request: URLRequest) async throws -> T where T : Decodable, T : Encodable {
        let dataRequest = session.request(request)
        
        let response = await dataRequest
            .validate()
            .serializingDecodable(T.self)
            .response
        
        return try handleResponse(response)
    }
    
    func fetchImage(with request: URLRequest) async throws -> Data {
        let imageRequest = session.request(request)
        let imageResponse = await imageRequest.serializingData().response
        return try handleResponse(imageResponse)
    }
}

//MARK: - Private methods
private extension OpenWeatherManagerAF {
    func handleResponse<T>(_ response: DataResponse<T, AFError>) throws -> T {
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw mapError(error, statusCode: error.responseCode)
        }
    }

    func mapError(_ error: AFError, statusCode: Int?) -> NetworkError {
        if let code = statusCode, !(200...299).contains(code) {
            return .invalidResponse(statusCode: code)
        }
        
        if error.isSessionTaskError,
           let urlError = error.underlyingError as? URLError,
           urlError.code == .notConnectedToInternet {
            return .noInternet
        }
        
        if error.isResponseSerializationError {
            return .decodingError(error)
        }
        
        return .requestFailed(error)
    }
}
