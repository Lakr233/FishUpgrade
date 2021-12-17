//
//  BlankWindow.swift
//  FishUpgrade
//
//  Created by Lessica <82flex@gmail.com> on 2021/12/17.
//

import Cocoa

class BlankCursorView: NSView {

    var trackingArea: NSTrackingArea?

    override func layout() {
        super.layout()
        if let trackingArea = self.trackingArea {
            removeTrackingArea(trackingArea)
            self.trackingArea = nil
        }
        let trackingArea = NSTrackingArea(rect: frame, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
        self.trackingArea = trackingArea
    }

    override func mouseEntered(with event: NSEvent) {
        NSCursor.hide()
    }

    override func mouseMoved(with event: NSEvent) {
        NSCursor.hide()
    }

    override func mouseExited(with event: NSEvent) {
        NSCursor.hide()
    }
}

class BlankWindow: NSWindow {
    convenience init(in screen: NSScreen) {
        self.init(
            contentRect: CGRect(x: 0, y: 0, width: 1, height: 1),
            styleMask: [.resizable, .titled, .fullSizeContentView],
            backing: .buffered,
            defer: true,
            screen: screen
        )
        isOpaque = true
        backgroundColor = .black
        titlebarAppearsTransparent = true
        setFrameOrigin(screen.visibleFrame.origin)
        contentView = BlankCursorView()
    }

    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}
