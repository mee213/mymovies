//
//  MovieDetailsView.swift
//  MyMovies
//
//  Created by Marlo Wendell on 5/16/21.
//

import SDWebImageSwiftUI
import SwiftUI

struct MovieDetailsView: View {
    let movie: Movie
    
    @State private var details = Bundle.main.decode(MovieDetails.self, from: "details.json")
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 0) {
                    if let path = movie.backdropPath {
                        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w1280\(path)"))
                            .placeholder {
                                Color.gray.frame(maxHeight: 200) }
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 200)
                    }
                    
                    HStack(spacing: 20) {
                        Text("Revenue: $\(details.revenue)")
                        Text("\(details.runtime) minutes")
                    }
                    .foregroundColor(.white)
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(Color.black)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing:  3) {
                        ForEach(movie.genres) { genre in
                            Text(genre.name)
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 2)
                                .background(Color(genre.color))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 10)
                }
                
                Text(movie.overview)
                    .padding([.horizontal, .bottom])
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Movie.example)
    }
}
