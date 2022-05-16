//
//  Endpoint.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/08.
//

import Foundation
import Moya

enum Endpoint {
    case fetchMovieList(String, Int)
    case download(url: String)
}

extension Endpoint: TargetType {
    var baseURL: URL {
        switch self {
        case .download(_):
            return URL(string: "https://image.tmdb.org/t/p/w500")!
        default:
            return URL(string: "http://api.themoviedb.org")!
        }
    }
    
    var path: String {
        switch self {
        case .fetchMovieList:
            return "/3/search/movie"
        case .download(let url):
            return url
        }
    }
    
    var parameters: [String: Any] {
        var parameter: [String: Any] = ["api_key" : "2696829a81b1b5827d515ff121700838"]
        
        switch self {
        case .fetchMovieList(let query, let page):
            return parameter.append(["query" : query, "page" : page])
        default:
            return [:]
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
