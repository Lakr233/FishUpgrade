//
//  FishUpgradeApp.swift
//  FishUpgrade
//
//  Created by Lakr Aream on 2021/12/16.
//  Modified by Lessica <82flex@gmail.com> on 2021/12/17.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }

    #if !SANDBOX
        var doNotDisturbEnabled = false

        func applicationWillTerminate(_: Notification) {
            DoNotDisturb.isEnabled = doNotDisturbEnabled
        }
    #endif
}

@main
struct FishUpgradeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        #if !SANDBOX
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let keyWindow = NSApplication.shared.keyWindow {
                    DoNotDisturb.installShortcutIfNeeded(in: keyWindow)
                }
            }
        #endif
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
