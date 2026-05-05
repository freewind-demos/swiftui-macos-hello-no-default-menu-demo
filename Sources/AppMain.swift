import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.mainMenu = NSMenu()

        DispatchQueue.main.async {
            NSApp.windows.forEach { window in
                window.collectionBehavior = window.collectionBehavior
                    .subtracting(.fullScreenPrimary)
                    .union(.fullScreenNone)
            }
        }
    }
}

@main
struct HelloNoDefaultMenuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Window("Hello, no menus", id: "main") {
            ContentView()
        }
        .defaultSize(width: 320, height: 180)
        .commandsRemoved()
        .commandsReplaced {}
    }
}
