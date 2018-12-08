//
//  AppDelegate.swift
//  Drip
//
//  Created by Andrew Finke on 12/6/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        print(filenames)
    }


}

