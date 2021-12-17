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

    private static weak var mainWindowToken: NSObjectProtocol?
    private static var blankWindows: [BlankWindow]?

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.setupBlankWindows()
    }

    private static func setupBlankWindows() {
        if NSScreen.screensHaveSeparateSpaces {
            AppDelegate.blankWindows = NSScreen
                .screens
                .map { BlankWindow(in: $0) }
        } else {
            AppDelegate.blankWindows = []
        }
    }

    static func showBlankWindows(for mainWindow: NSWindow) {
        mainWindowToken = NotificationCenter.default.addObserver(
            forName: NSWindow.didExitFullScreenNotification,
            object: mainWindow,
            queue: .main) { noti in
                // well... it is the best approach
                NSApp.terminate(nil)
            }
        blankWindows?.forEach { blank in
            if blank.screen != mainWindow.screen {
                blank.orderFront(nil)
                blank.toggleFullScreen(nil)
            }
        }
    }

    #if !SANDBOX
        static var doNotDisturbEnabled = false

        func applicationWillTerminate(_: Notification) {
            DoNotDisturb.isEnabled = AppDelegate.doNotDisturbEnabled
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
