//
//  ShowMoreLessView.swift
//  movie
//
//  Created by ruiqi on 2021/4/20.
//

import SwiftUI

struct ShowMoreLessView: View {
    /* Indicates whether the user want to see all the text or not. */
    @State private var expanded: Bool = false

    /* Indicates whether the text has been truncated in its display. */
    @State private var truncated: Bool = false

    private var text: String

    init(text: String) {
        self.text = text
    }
    
    private func determineTruncation(_ geometry: GeometryProxy) {
        // Calculate the bounding box we'd need to render the
        // text given the width from the GeometryReader.
        let total = self.text.boundingRect(
            with: CGSize(
                width: geometry.size.width,
                height: .greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        )

        if total.size.height > geometry.size.height + 6 {
            self.truncated = true
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(self.text)
                .font(.system(size: 16))
                .lineLimit(self.expanded ? nil : 3)
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        self.determineTruncation(geometry)
                    }
                })

            if self.truncated {
                Button(action: { self.expanded.toggle() }) {
                    Text(self.expanded ? "Show less" : "Show more..")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .bold()
                }.frame(width: 360, alignment: .trailing)
            }
        }
    }
}

