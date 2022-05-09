//
//  Movie.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/09.
//

import Foundation

typealias MovieId = Int

struct MoviesPage: Codable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
        self.movies = try container.decode([Movie].self, forKey: .movies)
    }
}

struct Movie: Codable {
    let id: MovieId
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: Date?
    
    private enum CodingKeys: String, CodingKey {        
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.overview = try container.decode(String.self, forKey: .overview)
        let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
        releaseDate = DateFormatter.yyyyMMdd.date(from: releaseDateString)
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return (lhs.id == rhs.id)
    }
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

fileprivate extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
