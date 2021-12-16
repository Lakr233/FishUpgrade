//
//  FishWindow.swift
//  FishUpgrade
//
//  Created by Lakr Aream on 2021/12/16.
//

import Cocoa
import SwiftUI

struct FishView: View {
    let beginDate: Date
    let completeDate: Date
    let duration: Double
    init(duration: Double) {
        beginDate = Date()
        completeDate = Date(timeIntervalSinceNow: TimeInterval(duration))
        self.duration = duration
        debugPrint("init duration \(duration)")
        _ = disableScreenSleep(reason: "你在摸鱼呢")
    }

    /*
     timer will call us each second
     but only a number of time we update the percentage to the real
     so it will fill lacky and the same as apple do
     */

    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()

    @State var reloadTrigger: Bool = false
    @State var percentage: Double = 0 // we only update this on a chance :)

    var body: some View {
        GeometryReader { r in
            ZStack {
                VStack(spacing: 0) {
                    Image(systemName: "applelogo")
                        .antialiased(true)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .font(.system(size: 72))
                    Spacer()
                        .frame(width: 200, height: 35)
                    progress
                    Spacer()
                        .frame(width: 200, height: 10)
                    tintLabel
                    Spacer()
                        .frame(width: 200, height: 10)
                }
            }
            .frame(
                width: r.size.width,
                height: r.size.height,
                alignment: .center
            )
        }
        .background(Color.black)
        .onReceive(timer) { _ in
            reloadTrigger.toggle()
            if Date().timeIntervalSince(completeDate) > 0 {
                for window in NSApplication.shared.windows {
                    window.close()
                    exit(0)
                }
            }
            checkUpdateProgress()
        }
        .onHover { hover in
            if hover {
                NSCursor.hide()
            } else {
                NSCursor.unhide()
            }
        }
        .frame(minWidth: 600, minHeight: 400)
    }

    var progress: some View {
        Rectangle()
            .foregroundColor(Color.gray.opacity(0.5))
            .frame(width: 200, height: 4)
            .overlay(
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: 200 * percentage, height: 4)
                        .background(Text("\(reloadTrigger ? 1 : 0)").hidden())
                    Spacer()
                }
            )
            .clipped()
            .cornerRadius(2)
    }

    var tintLabel: some View {
        Text(makeElapseTime())
            .foregroundColor(Color.white)
            .font(.system(size: 10, weight: .semibold, design: .default))
            .background(Text("\(reloadTrigger ? 1 : 0)").hidden())
    }

    func makeElapseTime() -> String {
        if percentage == 0 {
            return ""
        }
        var timeLeft = duration * (1 - percentage)
        if timeLeft < 30 {
            timeLeft = 30
        }
        let hour = Int(timeLeft / 3600)
        let min = Int((Int(timeLeft) % 3600) / 60)
        var str = "剩余时间 "
        if hour > 0 {
            str += "\(hour) 小时"
        }
        if hour > 0, min > 0 {
            str += " "
        }
        if min > 0 {
            str += "\(min) 分钟"
        }
        return str
    }

    func makePercent() -> Double {
        let current = Date().timeIntervalSince(beginDate)
        return current / duration
    }

    func checkUpdateProgress() {
        if Int.random(in: 0 ... 25) == 0 {
            // avg update 1/x times per second
            percentage = makePercent()
        }
    }
}

extension View {
    func openFishWindow(withDuration: Double) {
        let controller = NSHostingController(rootView: FishView(duration: withDuration))
        let window = NSWindow(contentViewController: controller)
        window.title = ""
        window.titlebarAppearsTransparent = true
        window.contentViewController = controller
        window.makeKeyAndOrderFront(nil)
        window.toggleFullScreen(true)
    }
}
