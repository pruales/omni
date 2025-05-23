//
//  OmniApp.swift
//  Omni
//
//  Created by Paul on 5/22/25.
//

import SwiftUI

@main
struct OmniApp: App {
    @StateObject private var searchWindowManager = SearchWindowManager()
    private var globalShortcut: GlobalShortcut?
    
    init() {
        let manager = SearchWindowManager()
        _searchWindowManager = StateObject(wrappedValue: manager)
        
        globalShortcut = GlobalShortcut {
            DispatchQueue.main.async {
                manager.toggle()
            }
        }
        globalShortcut?.register()
    }

    var body: some Scene {
        WindowGroup {
            EmptyView()
                .frame(width: 0, height: 0)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
        
        Settings {
            Text("Omni Settings")
                .padding()
        }
    }
}
