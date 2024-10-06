//
//  Auth.swift
//  Sonus
//
//  Created by Sankalp Saini on 2024-10-05.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct AuthView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    @State private var isAuthenticated = false
    
    let db = Firestore.firestore()
    
    var body: some View {
        if isAuthenticated {
            
            HomeView()
            
        } else {

            VStack {
                
                // Title near the top
                Text("**Welcome to Aavaaz**")
                    .font(.largeTitle)
                    .padding(.top, 100) // Push title towards the top
                
                Spacer()
                
                // Centered username text field
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(minWidth: 0, maxWidth: 300)
                
                // Centered secure password text field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)
                    .frame(minWidth: 0, maxWidth: 300)
                
                // Display login message if necessary
                Text(loginMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                
                // Submit button
                Button(action: submitAuth) {
                    Text("submit")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .frame(width: 200)
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Optional background
            .background(Color(UIColor.systemGroupedBackground))
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private func submitAuth() {
        if !username.isEmpty && !password.isEmpty {
            db.collection("users")
                .whereField("username", isEqualTo: username)
                .whereField("password", isEqualTo: password)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error checking credentials: \(error)")
                        loginMessage = "Error occurred. Try again."
                    } else if let snapshot = snapshot, !snapshot.isEmpty {
                        loginMessage = "Login successful!"
                        isAuthenticated = true
                    } else {
                        loginMessage = "Invalid username or password."
                    }
                }
        } else {
            loginMessage = "Please fill in both fields."
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
