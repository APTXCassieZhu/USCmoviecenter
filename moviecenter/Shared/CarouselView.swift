//
//  CarouselView.swift
//  movie
//
//  Created by ruiqi on 2021/4/14.
//

import SwiftUI
import Combine

struct CarouselView<Media: View>: View {
    private var numberOfImages: Int
    private var media: Media

    @State private var currentIndex: Int = 0
    
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    init(numberOfImages: Int, @ViewBuilder media: () -> Media) {
        self.numberOfImages = numberOfImages
        self.media = media()
    }

    var body: some View {
        GeometryReader { geometry in
        HStack(spacing: 0) {
                self.media
            }
            .frame(width: 370, height: 270, alignment: .leading)
            .offset(x: CGFloat(self.currentIndex) * -370, y: 0)
            .animation(.spring())
            .onReceive(self.timer) { _ in
                self.currentIndex = (self.currentIndex + 1) % self.numberOfImages
            }
        }
    }
}

//struct CarouselView_Previews: PreviewProvider {
//    static var previews: some View {
//        CarouselView()
//    }
//}
