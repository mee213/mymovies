//
//  MovieDetailsView.swift
//  MyMovies
//
//  Created by Marlo Wendell on 5/16/21.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI

struct MovieDetailsView: View {
    let movie: Movie
   
    @EnvironmentObject var dataController: DataController
  
    @State private var details: MovieDetails?
    @State private var credits: Credits?
    @State private var reviews = [Review]()
    @State private var requests = Set<AnyCancellable>()
    
    @State private var reviewText = ""
    
    var reviewURL: URL? {
        URL(string: "https://www.hackingwithswift.com/samples/ios-accelerator/\(movie.id)")
    }
    
    @State private var showingAllCast = false
    @State private var showingAllCrew = false
    
    var displayedCast: [CastMember] {
        guard let credits = credits else { return [] }
        
        if showingAllCast {
            return credits.cast
        } else {
            return Array(credits.cast.prefix(5))
        }
    }
    
    var displayedCrew: [CrewMember] {
        guard let credits = credits else { return [] }
        
        if showingAllCrew {
            return credits.crew
        } else {
            return Array(credits.crew.prefix(5))
        }
    }
    
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
                    
                    if let details = details {
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
                
                Group {
                    Text("Cast")
                        .font(.title)
                    
                    ForEach(displayedCast) { person in
                        VStack(alignment: .leading) {
                            Text(person.name)
                                .font(.headline)
                            
                            Text(person.character)
                        }
                        .padding(.bottom, 1)
                    }
                    
                    if showingAllCast == false {
                        Button("Show all") {
                            withAnimation(.easeIn(duration: 3)) {
                                showingAllCast.toggle()
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    Text("Crew")
                        .font(.title)
                    
                    ForEach(displayedCrew) { person in
                        VStack(alignment: .leading) {
                            Text(person.name)
                                .font(.headline)
                            
                            Text(person.job)
                        }
                        .padding(.bottom, 1)
                    }
                    
                    if showingAllCrew == false {
                        Button("Show all") {
                            withAnimation(.easeIn(duration: 3)) {
                                showingAllCrew.toggle()
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    Text("Reviews")
                        .font(.title)
                    
                    ForEach(reviews) { review in
                        Text(review.text)
                            .font(.body.italic())
                    }
                    
                    TextEditor(text: $reviewText)
                        .frame(height: 200)
                        .border(Color.gray, width: 1)
                    
                    Button("Submit Review", action: submitReview)
                }
                .padding(.horizontal, 10)
            }
        }
        .toolbar {
            Button {
                dataController.toggleFavorite(movie)
            } label: {
                if dataController.isFavorite(movie) {
                    Image(systemName: "heart.fill")
                } else {
                    Image(systemName: "heart")
                }
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchMovieDetails)
    }
    
    func fetchMovieDetails() {
        let movieRequest = URLSession.shared.get(path: "movie/\(movie.id)", defaultValue: nil) { downloaded in
            details = downloaded
        }
        
        let creditsRequest = URLSession.shared.get(path: "movie/\(movie.id)/credits", defaultValue: nil) { downloaded in
            credits = downloaded
        }
        
        if let movieRequest = movieRequest { requests.insert(movieRequest) }
        if let creditsRequest = creditsRequest { requests.insert(creditsRequest) }
        
        guard let reviewURL = reviewURL else { return }
        
        let reviewsRequest = URLSession.shared.fetch(reviewURL, defaultValue: []) { downloaded in reviews = downloaded
        }
        
        requests.insert(reviewsRequest)
    }
    
    func submitReview() {
        guard reviewText.isEmpty == false else { return }
        guard let reviewURL = reviewURL else { return }
        
        let review = Review(id: UUID().uuidString, text: reviewText)
        
        let request = URLSession.shared.post(review, to: reviewURL) {
            result in
            if result == "OK" {
                reviews.append(review)
                reviewText = ""
            }
        }
        
        requests.insert(request)
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Movie.example)
    }
}
