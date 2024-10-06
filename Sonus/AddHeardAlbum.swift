//
//  AddHeardAlbum.swift
//  Sonus
//
//  Created by Sankalp Saini on 2024-10-05.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct AddHeardAlbum: View {
    @Environment(\.presentationMode) var presentationMode  // To dismiss the view
    @State private var title: String = ""
    @State private var artist: String = ""
    @State private var rating: Int = 3
    @State private var notes: String = ""
    @State private var selectedDate = Date()
    

    let db = Firestore.firestore()

    var body: some View {
        VStack {
            // Title TextField
            TextField("enter album title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Artist TextField
            TextField("enter artist", text: $artist)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Rating Picker
            Picker("rate this album", selection: $rating) {
                ForEach(1..<6) { number in
                    Text("\(number)").tag(number)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Date (auto-filled)
            DatePicker("date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()

            // Notes TextField
            TextField("comments", text: $notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Submit button
            Button(action: submitItem) {
                Text("submit")
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
    }

    private func submitItem() {
        if !title.isEmpty {
            let newAlbumData: [String: Any] = [
                "title": title,
                "artist": artist,
                "rating": rating,
                "notes": notes,
                "date": selectedDate,
                "timestamp": Date()
            ]
            
            db.collection("albums").addDocument(data: newAlbumData) { err in
                if let err = err {
                    print("Error adding new album: \(err)")
                } else {
                    print("New Album added")
                    self.presentationMode.wrappedValue.dismiss()  // Dismiss the view after saving
                }
            }
        }
    }
}
