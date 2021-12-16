//
//  ContentView.swift
//  FishUpgrade
//
//  Created by Lakr Aream on 2021/12/16.
//

import SwiftUI

struct ContentView: View {
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()

    @State var inConfiguration: Bool = true
    @State var upgradeDuration: Double = 30 // min

    @State var reloadTrigger: Bool = false

    var body: some View {
        GeometryReader { r in
            ZStack {
                HStack {
                    Spacer()
                    container
                        .frame(minWidth: 200, idealWidth: 400, maxWidth: 500)
                    Spacer()
                }
                .padding()
                .frame(
                    width: r.size.width,
                    height: r.size.height,
                    alignment: .center
                )
            }
            .frame(
                width: r.size.width,
                height: r.size.height,
                alignment: .center
            )
        }
        .overlay(
            VStack(spacing: 2) {
                Spacer()
                Text("Icon designed by Freepik from Flaticon, made with love by @Lakr233")
                    .font(.system(size: 8, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity(0.5)
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: "https://twitter.com/Lakr233")!)
                    }
            }
            .padding()
        )
        .onChange(of: inConfiguration) { newValue in
            NSApplication.shared.keyWindow?.toggleFullScreen(newValue)
        }
        .onReceive(timer) { _ in
            reloadTrigger.toggle()
        }
    }

    var container: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("icon")
                    .antialiased(true)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .center)
                VStack(alignment: .leading, spacing: 4) {
                    Text("开心摸鱼")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("伪装的系统升级，摸鱼再合适不过啦～")
                        .font(.system(size: 8, weight: .semibold, design: .rounded))
                }
                Spacer()
            }
            Divider()
            Group {
                HStack {
                    Image(systemName: "timer")
                    Text("摸鱼时常")
                    Spacer()
                    Text(makeTimeIntervalString())
                }
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                Slider(
                    value: $upgradeDuration,
                    in: 5 ... 300, // min, 1 to 5 hour
                    step: 5
                ) { inEditing in
                    debugPrint("in editing? \(inEditing)")
                }
                Text("摸鱼结束时间: \(makeEndingDate())")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .background(Text("\(reloadTrigger ? 1 : 0)").hidden())
            }
            Divider()
            Group {
                HStack {
                    Spacer()
                    Button {
                        let alert = NSAlert()
                        alert.alertStyle = .critical
                        alert.messageText = "摸鱼过程中，请按 ESC 键退出哦～"
                        alert.addButton(withTitle: "确定")
                        alert.beginSheetModal(for: NSApplication.shared.keyWindow ?? NSWindow()) { _ in
                            for window in NSApplication.shared.windows {
                                window.close()
                            }
                            openFishWindow(withDuration: upgradeDuration * 60)
                        }
                    } label: {
                        Text("开始摸鱼！")
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }

    func makeTimeIntervalString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute]
        return formatter
            .string(from: TimeInterval(upgradeDuration * 60)) ?? ""
    }

    func makeEndingDate() -> String {
        let date = Date(timeIntervalSinceNow: TimeInterval(upgradeDuration * 60))
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
