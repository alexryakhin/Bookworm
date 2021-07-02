//
//  DetailView.swift
//  Bookworm
//
//  Created by Alexander Bonney on 5/29/21.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre ?? "Fantasy")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width)
                        
                    
                    Text(book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Text(book.author ?? "Unknown Author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
                
                Spacer()
                
                Text("Book added: \(book.date ?? Date(), formatter: dateFormatter)").foregroundColor(.secondary)
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown book"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            showingDeleteAlert = true
        }, label: {
            Image(systemName: "trash")
        }))
        .alert(isPresented: $showingDeleteAlert, content: {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                deleteBook()
            }, secondaryButton: .cancel())
        })
    }
    func deleteBook() {
        viewContext.delete(book)
        try? viewContext.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
//        formatter.timeStyle = .medium
        return formatter
    }()
}

struct DetailView_Previews: PreviewProvider {
    static let viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: viewContext)
        book.title = "Harry Potter and the Sorcerer's Stone"
        book.author = "J. K. Rowling"
        book.rating = 5
        book.genre = "Fantasy"
        book.review = "That't a fantastic book!"
        book.date = Date()
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
