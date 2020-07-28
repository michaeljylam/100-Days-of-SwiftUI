//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Michael Lam on 2020-07-28.
//  Copyright © 2020 Michael Lam. All rights reserved.
//

import SwiftUI

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(Color.blue)
    }
}

extension View {
    func blueTitleStyle() -> some View {
        self.modifier(BlueTitle())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .blueTitleStyle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
