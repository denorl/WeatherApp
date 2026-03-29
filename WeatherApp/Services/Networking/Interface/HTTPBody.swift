//
//  HTTPBody.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 29/3/26.
//
import Foundation

enum HTTPBody {
    case json(Encodable)
    case plainText(String)
    case raw(Data, contentType: String)
}
