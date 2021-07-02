//
//  AddBookView.swift
//  Bookworm
//
//  Created by Alexander Bonney on 5/29/21.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Poetry"
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller", "ScienceFiction"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Book's name", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }
                Section {
                    Button(action: {
                        //add the book
                        let newBook = Book(context: viewContext)
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        newBook.date = Date()
                        
                        try? viewContext.save()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                    })
                }
            }.navigationTitle("Add book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
