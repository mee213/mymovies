//
//  MovieRow.swift
//  MyMovies
//
//  Created by Marlo Wendell on 5/16/21.
//

import SwiftUI

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        NavigationLink(destination: Color.red) {
            HStack {
                Image(systemName: "video")
                
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.title2)
                    
                    HStack {
                        Text("Rating: \(movie.voteAverage, specifier: "%g")/10")
                        Text(movie.releaseDate)
                    }
                    .font(.subheadline)
                    
                    Text(movie.overview)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .font(.body.italic())
                }
            }
        }
    }
}

struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        MovieRow(movie: Movie.example)
    }
}
