//
//  ViewController.swift
//  Drip
//
//  Created by Andrew Finke on 12/6/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    // MARK: - Interface Properties

    @IBOutlet weak var playPauseButton: NSButton!
    @IBOutlet weak var ratePopUpButton: NSPopUpButton!

    // MARK: - Properties
    
    var playbackRate: Float = 1.0 {
        didSet {
            audioPlayer?.rate = playbackRate
        }
    }
    var isPlaying = false {
        didSet {
            playbackStateUpdated()
        }
    }

    var trackTitle = ""
    var playbackTimer: Timer?
    var audioPlayer: AVAudioPlayer?

    // MARK: - View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        view.window?.title = "Drip"

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.command.rawValue) > 0,
                event.keyCode == 31 {
                self.selectFilePressed(nil)
                return nil
            }

            switch event.keyCode {
            case 18:
                self.rateIndexChanged(0)
            case 19:
                self.rateIndexChanged(1)
            case 20:
                self.rateIndexChanged(2)
            case 21:
                self.rateIndexChanged(3)
            case 23:
                self.rateIndexChanged(4)
            case 49:
                self.isPlaying.toggle()
            case 123:
                self.rewindPressed(nil)
            case 124:
                self.fastForwardPressed(nil)
            default:
                return event
            }
            return nil
        }
    }

    // MARK: - Actions

    @IBAction func fastForwardPressed(_ sender: Any?) {
        guard let player = audioPlayer else { return }
        player.currentTime += 15
        updateProgress()
    }

    @IBAction func rewindPressed(_ sender: Any?) {
        guard let player = audioPlayer else { return }
        player.currentTime -= 15
        updateProgress()
    }

    @IBAction func playPauseButtonPressed(_ sender: Any?) {
        isPlaying.toggle()
    }

    @IBAction func rateChanged(_ sender: NSPopUpButton) {
        rateIndexChanged(sender.selectedTag())
    }

    @objc
    func rateIndexChanged(_ index: Int) {
        switch index {
        case 0:
            playbackRate = 1.4
        case 1:
            playbackRate = 1.2
        case 2:
            playbackRate = 1.0
        case 3:
            playbackRate = 0.8
        case 4:
            playbackRate = 0.6
        default:
            fatalError()
        }
        ratePopUpButton.selectItem(at: index)
    }

    @IBAction func selectFilePressed(_ sender: Any?) {
        func select(_ url: URL) {
            audioPlayer?.stop()
            audioPlayer = nil
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.enableRate = true
                player.rate = playbackRate
                player.prepareToPlay()
                audioPlayer = player
                isPlaying = true
            } catch {
                fatalError(error.localizedDescription)
            }
        }

        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.canDownloadUbiquitousContents = false
        openPanel.begin { result in
            if result == .OK, let url = openPanel.url {
                select(url)
                self.trackTitle = String(url.lastPathComponent.split(separator: ".")[0])
                self.updateProgress()
            }
        }
    }

    // MARK: - Interface Updates

    func playbackStateUpdated() {
        playbackTimer?.invalidate()
        
        if isPlaying {
            playbackTimer = Timer.scheduledTimer(timeInterval: TimeInterval(playbackRate), target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            audioPlayer?.play()
            playPauseButton.image = NSImage(named: NSImage.touchBarPauseTemplateName)
        } else {
            audioPlayer?.pause()
            playPauseButton.image = NSImage(named: NSImage.touchBarPlayTemplateName)
        }
    }

    @objc
    func updateProgress() {
        let progress = Int(audioPlayer?.currentTime ?? 0)
        let minute = progress / 60
        let seconds = progress % 60
        let secondsString = seconds < 10 ? "0" + seconds.description : seconds.description
        view.window?.title = "\(trackTitle) - \(minute):\(secondsString)"
    }

}

