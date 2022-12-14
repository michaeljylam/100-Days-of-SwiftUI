//
//  ContentView.swift
//  P3-ViewsAndModifiers
//
//  Created by Michael Lam on 2022-06-09.
//

import SwiftUI

struct ProminentText: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func prominentStyle() -> some View {
        modifier(ProminentText())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .prominentStyle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
