//
//  Movie.swift
//  MyMovies
//
//  Created by Marlo Wendell on 5/16/21.
//

import Foundation

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let posterPath: String?
    let backdropPath: String?
    let genreIds:  Set<Int>
}
