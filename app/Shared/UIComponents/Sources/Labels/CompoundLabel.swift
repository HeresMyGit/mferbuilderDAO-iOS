//
//  CompoundLabel.swift
//  
//
//  Created by Ziad Tamim on 15.11.21.
//

import SwiftUI

/// A label for user interface items, consisting of nested labels.
public struct CompoundLabel<Title>: View where Title: View {
    private let icon: Image
    private let title: Title
    private let caption: String
    
    public init(_ title: Title, icon: Image, caption: String) {
        self.icon = icon
        self.title = title
        self.caption = caption
    }
    
    public var body: some View {
        HStack {
            icon
            VStack(alignment: .leading, spacing: 0) {
                title
                    .font(.custom(.bold, relativeTo: .footnote))
                
                Text(caption)
                    .font(.custom(.regular, relativeTo: .footnote).monospacedDigit())
            }
        }
    }
}
