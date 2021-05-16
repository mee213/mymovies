//
//  ContentView.swift
//  MyMovies
//
//  Created by Paul Hudson on 12/05/2021.
//

import SwiftUI

//
// TMDb asks you to register for an API key to use their
// service, and it's free as long as you provide attribution.
// You can learn more and apply for your own API key here:
// https://www.themoviedb.org/documentation/api
//
// Alternatively, just for testing purposes you can use this testing
// key I have generated specifically for this workshop:
// API KEY: cda44c124921b7b8d95d7055ed36baf3
//
// IMPORTANT: Do *not* use that key in a shipping application,
// because it might go away at any point in the future. It's
// just for testing here.
//

struct ContentView: View {
    @State private var searchResults = Bundle.main.decode(SearchResults.self, from: "results.json", keyDecodingStrategy: .convertFromSnakeCase)
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(searchResults.results, content: MovieRow.init)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("MyMovies")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
