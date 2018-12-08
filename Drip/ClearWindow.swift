//
//  ClearWindow.swift
//  time
//
//  Created by Andrew Finke on 3/2/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import Cocoa

class ClearWindow: NSWindow {

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {

        super.init(contentRect: contentRect,
                   styleMask: .borderless,
                   backing: .buffered,
                   defer: false)

        isOpaque = false
        backgroundColor = NSColor.clear
        isMovableByWindowBackground = true
        level = .floating

        hasShadow = false

        self.styleMask.insert(.titled)

        collectionBehavior = .canJoinAllSpaces
    }

}
