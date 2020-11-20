//
//  AppDelegate.swift
//  freeshuttercounter
//
//  Created by Sean Coker on 11/20/20.
//  Copyright © 2020 Oleg Orlov. All rights reserved.
//

import CoreFoundation
import Cocoa
//import AppKit

class AppDelegate: NSObject {
    @IBOutlet private var window: NSWindow!
    @IBOutlet weak var aboutText: NSTextField!
    @IBOutlet weak var output: NSTextField!

    @IBAction func button_homepage(_ sender: Any) {
        var url: URL? = nil
        if let object = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            url = URL(string: "http://orlv.github.io/freeshuttercounter/?version=\(object)")
        }
        if let url = url {
            NSWorkspace.shared.open(url)
        }
    }
    
    @IBAction func button_get_camera_data(_ sender: Any) {
//        output.text
        output.stringValue = camera_get_info()
        output.selectText(self)
        output.currentEditor()?.selectedRange = NSRange(location: "\(String(describing: output))".count, length: 0)
    }
    
    func camera_get_info() -> String {
        return ""
    }

    //     check if we in /Applications folder
    func check_installed() -> Bool {
        if !(URL(fileURLWithPath: Bundle.main.bundlePath).deletingLastPathComponent().path == "/Applications") {
            return false
        }
        return true
    }
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if !check_installed() {
            let alert = NSAlert()
            alert.addButton(withTitle: "Quit")
            alert.messageText = "Warning"
            alert.informativeText = "Please copy this app into the /Applications folder."
            alert.alertStyle = .warning
            alert.runModal()

            NSApplication.shared.terminate(nil)
        }

        if let object = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            aboutText.stringValue = "freeshuttercounter v\(object)"
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
