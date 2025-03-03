//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var games: [Game]
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct Game: Codable {
    var team: String
    var id: Int
    var opponent: String
    var isHomeGame: Bool
    var date: String
    var score: Score
}

struct ContentView: View {
    @State private var games: [Game] = []
    
    var body: some View {
        NavigationStack {
            List(games, id: \.id) {
                game in HStack {
                    VStack(alignment: .leading) {
                        Text("\(game.team) vs. \(game.opponent)")
                            .font(.headline)
                        Text(game.date)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .font(.headline)
                        Text(game.isHomeGame ? "Home" : "Away")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("UNC Basketball")
        }
            
        .task {
            await loadData()
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data) {
                games = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
