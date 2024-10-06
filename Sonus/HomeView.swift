//
//  HomeView.swift
//  Sonus
//
//  Created by Sankalp Saini on 2024-10-02.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Album: Identifiable {
    var id: String
    var title: String
    var artist: String
    var rating: Int
}

struct HomeView: View {
    @State private var albums: [Album] = []
    
    let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            VStack {
                // List for displaying albums
                List {
                    ForEach(albums) { album in
                        VStack(alignment: .leading) {
                            Text(album.title)
                                .font(.headline)
                            Text(album.artist)
                                .font(.subheadline)
                            Text("Rating: \(album.rating)")
                                .font(.footnote)
                        }
                    }
                    .onDelete(perform: deleteItem)
                    .listRowInsets(EdgeInsets())
                    .padding()
                }
                .listStyle(.plain)
                
                // Add Button Navigation Link
                NavigationLink(destination: AddHeardAlbum()) {
                    Text("Add new Album")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding(.top, 20)
            }
            .navigationBarTitle(Text("**Albums I've Heard**"), displayMode: .large)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: fetchItems)
        }
    }

    private func fetchItems() {
        db.collection("albums").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.albums = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    return Album(
                        id: document.documentID,
                        title: data["title"] as? String ?? "",
                        artist: data["artist"] as? String ?? "",
                        rating: data["rating"] as? Int ?? 0
                    )
                } ?? []
            }
        }
    }

    private func deleteItem(at offsets: IndexSet) {
        let deletedAlbum = offsets.map { albums[$0] }
        albums.remove(atOffsets: offsets)

        for album in deletedAlbum {
            db.collection("albums").document(album.id).delete { error in
                if let error = error {
                    print("Error removing album: \(error)")
                } else {
                    print("Album successfully removed!")
                }
            }
        }
    }
}

