//
//  FishUpgradeApp.swift
//  FishUpgrade
//
//  Created by Lakr Aream on 2021/12/16.
//

import SwiftUI

@main
struct FishUpgradeApp: App {
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if isFullScreen() {
                NSApplication.shared.keyWindow?.toggleFullScreen(nil)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 600, idealWidth: 600, maxWidth: 600,
                       minHeight: 400, idealHeight: 400, maxHeight: 400,
                       alignment: .center)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {
                // don't create new window lol!
            }
        }
    }
}

func isFullScreen() -> Bool {
    // TODO: HERE
    false
}
