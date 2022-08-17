//
//  ComicsView.swift
//  MarvelAPIApp
//
//  Created by Md Shah Alam on 7/20/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ComicsView: View {
    
    @EnvironmentObject var homeData: HomeViewModel
    
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                if homeData.fetchedComics.isEmpty {
                    ProgressView()
                        .padding(.top, 30)
                }
                else{
                    // Displaying Contents...
                    
                    VStack(spacing: 15){
                        ForEach(homeData.fetchedComics) { comic in
                            ComicRowView(character: comic)
                        }
                        
                        // Infinity Scroll Using Geomtry Reader...
                        if homeData.offset ==  homeData.fetchedComics.count {
                            // showing progress and fetching new data...
                            ProgressView()
                                .padding(.vertical)
                                .onAppear {
                                    print("fetching new data...")
                                    homeData.fetchComics()
                                }
                        }
                        else{
                            GeometryReader{ reader -> Color in
                                
                                let minY = reader.frame(in: .global).minY
                                
                                let height = UIScreen.main.bounds.height / 1.3
                                
                                // When it goes over the height triggering update...
                                
                                if !homeData.fetchedComics.isEmpty && minY < height {
                                    
                                    DispatchQueue.main.async {
                                        // Settings offset to current fetched comics count...
                                        // so 0 will be now fetched from 20...
                                        // and so on...
                                        homeData.offset = homeData.fetchedComics.count
                                    }
                                }
                                
                                return Color.clear
                            }
                            .frame(width: 20, height: 20)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("marvel's Comics")
        }
        
        // Loading Data...
        .onAppear {
            if homeData.fetchedComics.isEmpty{
                homeData.fetchComics()
            }
        }
    }
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView()
    }
}

struct ComicRowView: View {
    var character: Comic
    
    var body: some View {
        HStack(alignment: .top, spacing: 15){
            WebImage(url: extractImage(data: character.thumbnail))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(character.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                if let description = character.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                }
                
                // Links...
                HStack(spacing: 10){
                    ForEach(character.urls, id: \.self) { data in
                        NavigationLink(destination: WebView(url: extractURL(data: data))
                                        .navigationTitle(extractURLType(data: data))) {
                            Text(extractURLType(data: data))
                        }
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
    }
    
    func extractImage(data: [String: String]) -> URL {
        // combining both and forming image...
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        
        return URL(string: "\(path).\(ext)")!
    }
    
    func extractURL(data: [String: String]) -> URL {
        let url = data["url"] ?? ""
        
        return URL(string: url)!
        
    }
    
    func extractURLType(data: [String: String]) -> String {
        let type = data["type"] ?? ""
        
        return type.capitalized
        
    }
}
