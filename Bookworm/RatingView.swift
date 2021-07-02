//
//  RatingView.swift
//  Bookworm
//
//  Created by Alexander Bonney on 5/29/21.
//
/*
 SwiftUI makes it really easy to create custom UI components, because they are effectively just views that have some sort of @Binding exposed for us to read.

 To demonstrate this, we’re going to build a star rating view that lets the user enter scores between 1 and 5 by tapping images. Although we could just make this view simple enough to work for our exact use case, it’s often better to add some flexibility where appropriate so it can be used elsewhere too. Here, that means we’re going to make six customizable properties:

 What label should be placed before the rating (default: an empty string)
 The maximum integer rating (default: 5)
 The off and on images, which dictate the images to use when the star is highlighted or not (default: nil for the off image, and a filled star for the on image; if we find nil in the off image we’ll use the on image there too)
 The off and on colors, which dictate the colors to use when the star is highlighted or not (default: gray for off, yellow for on)
 We also need one extra property to store an @Binding integer, so we can report back the user’s selection to whatever is using the star rating.

 Before we fill in the body property, please try building the code – you should find that it fails, because our the RatingView_Previews struct doesn’t pass in a binding to use for rating.

 SwiftUI has a specific and simple solution for this called constant bindings. These are bindings that have fixed values, which on the one hand means they can’t be changed in the UI, but also means we can create them trivially – they are perfect for previews.
 
 Now let’s turn to the body property. This is going to be a HStack containing any label that was provided, plus as many stars as have been requested – although, of course, they can choose any image they want, so it might not be a star at all.

 The logic for choosing which image to show is pretty simple, but it’s perfect for carving off into its own method to reduce the complexity of our code. The logic is this:

 If the number that was passed in is greater than the current rating, return the off image if it was set, otherwise return the on image.
 If the number that was passed in is equal to or less than the current rating, return the on image.
 
 And now implementing the body property is surprisingly easy: if the label has any text use it, then use ForEach to count from 1 to the maximum rating plus 1 and call image(for:) repeatedly. We’ll also apply a foreground color depending on the rating, and add a tap gesture that adjusts the rating.
 */

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
                    .accessibility(label: Text("\(number == 1 ? "1 star" : "\(number) stars")"))
                    .accessibility(removeTraits: .isImage)
                    .accessibility(addTraits: number > self.rating ? .isButton : [.isButton, .isSelected])
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(3))
    }
}
