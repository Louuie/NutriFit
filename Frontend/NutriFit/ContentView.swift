//
//  ContentView.swift
//  NutriFit
//
//  Created by Elias Dandouch on 5/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Test")
            .tabItem {
                Label("Label 1", systemImage: "house")
            }
            Scan()
            .tabItem {
                Label("Scan", systemImage: "camera")
            }
        }
    }
}

#Preview {
    ContentView()
}
