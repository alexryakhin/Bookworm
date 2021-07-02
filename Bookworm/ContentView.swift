//
//  ContentView.swift
//  Bookworm
//
//  Created by Alexander Bonney on 5/27/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true)
    ])
    var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(
                        destination: DetailView(book: book),
                        label: {
                            EmojiRatingView(rating: book.rating)
                                            .font(.largeTitle)
                            VStack(alignment: .leading) {
                                if book.rating == 1 {
                                    Text(book.title ?? "Unknown Title")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                } else {
                                    Text(book.title ?? "Unknown Title")
                                        .font(.headline)
                                }
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        })
                }.onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    showingAddScreen.toggle()
                }, label: {
                    Image(systemName: "plus")
                }))
            .sheet(isPresented: $showingAddScreen) {
                    AddBookView().environment(\.managedObjectContext, viewContext)
                }
        }
    }
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            viewContext.delete(book)
        }
        try? viewContext.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
    }
}
