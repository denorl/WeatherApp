//
//  AlamofireInterceptorAdapter.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 29/3/26.
//

import Foundation
import Alamofire

final class AlamofireInterceptorAdapter: Alamofire.RequestInterceptor {
    
    private let baseInterceptor: RequestInterceptor
    
    init(baseInterceptor: RequestInterceptor) {
        self.baseInterceptor = baseInterceptor
    }
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        do {
            let adaptedRequest = try baseInterceptor.adapt(urlRequest)
            completion(.success(adaptedRequest))
        } catch {
            completion(.failure(error))
        }
    }
}
