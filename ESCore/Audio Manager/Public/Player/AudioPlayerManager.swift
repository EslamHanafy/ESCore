//
//  AudioPlayerManager.swift
//  AudioPlayerManager
//
//  Created by Hans Seiffert on 02.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

open class AudioPlayerManager: NSObject {

	// MARK: - PUBLIC -

	/// Strategy which should be used during the buffering.
	/// - Note: Is only supported by iOS 10+
	public enum BufferStrategy {
		/// The player will wait until enough data is loaded to minimize stalling. This will take longer to laod in the beginning but will lead to a smoother playback. Sets `AVPlayer.automaticallyWaitsToMinimizeStalling` to `true`
		case minimizeStalling
		/// The player will play as soon as the buffer isn't empty. Sets `AVPlayer.automaticallyWaitsToMinimizeStalling` to `false`
		case playImmediately
	}

	// MARK: - Properties

	public static let shared						= AudioPlayerManager()

	// MARK: - Configuration

	/// Set this to true if the `AudioPlayerManager` log should be enabled. The default is `false`.
	public static var verbose						= true

	/// Set this to true if the `AudioPlayerManager` log should contain detailed information about the calling class, function and line. The default is `true`
	public static var detailedLog					= true

	public private(set) var player                                    = AVPlayer()
    
    /// Set this to true to use the systems `MPNowPlayingInfoCenter` (control center and lock screen). The default value is `true`.
	open var useNowPlayingInfoCenter			= true

	/// Decides whether the audio player should wait until enough data is loaded to minimize stalling or if it should play as soon as the buffer is not empty. The default is `BufferStrategy.minimizeStalling`.
	/// - Note: Is only supported in iOS 10+
    open var bufferStrategy						= BufferStrategy.playImmediately {
		didSet {
			if #available(iOS 10.0, *) {
				self.player.automaticallyWaitsToMinimizeStalling = self.bufferStrategy == .minimizeStalling
			}
		}
	}

	/// Overrides the `preferredForwardBufferDuration` of `AVPlayerItem`. The default is `0` which let AVPlayer decide about the duration. 
	/// - Note: Is only supported in iOS 10+
	open var preferredForwardBufferDuration		= TimeInterval(0) {
		didSet {
			if #available(iOS 10.0, *) {
				self.player.currentItem?.preferredForwardBufferDuration = self.preferredForwardBufferDuration
			}
		}
	}

	// Set this to true to receive control events
	open var useRemoteControlEvents				= true {
		didSet {
			self.setupRemoteControlEvents()
		}
	}

	// The `NSTimeInterval` of the players update interval. Eg. the PlaybackTimeChangeCallbacks will be called then.
	open var playingTimeRefreshRate				: TimeInterval = 0.1

	open var currentTrack						: AudioTrack? {
		return self.queue.currentTrack
	}

	// MARK: - Initializaiton

	open class func makeStandalonePlayer() -> AudioPlayerManager {
		return self.makeStandalonePlayer(useNowPlayingInfoCenter: nil, useRemoteControlEvents: nil)
	}

	open class func makeStandalonePlayer(useNowPlayingInfoCenter: Bool?, useRemoteControlEvents: Bool?) -> AudioPlayerManager {
		let manager = AudioPlayerManager()
		if let useRemoteControlEvents = useRemoteControlEvents {
			manager.useRemoteControlEvents = useRemoteControlEvents
		}
		if let useNowPlayingInfoCenter = useNowPlayingInfoCenter {
			manager.useNowPlayingInfoCenter = useNowPlayingInfoCenter
		}
		return manager
	}

	public override init() {
		super.init()

		NotificationCenter.default.addObserver(self, selector: #selector(AudioPlayerManager.trackDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
	}

	open func setup() {
		self.setupRemoteControlEvents()
		self.setupAudioSession()
		self.setupPlayer()
	}

	// MARK: - Control playback

	open func togglePlayPause() {
		if self.isPlaying() == true {
			self.pause()
		} else {
			self.play()
		}
	}

	// MARK: - Play

	open func canPlay() -> Bool {
		return self.queue.count() > 0
	}

	open func play(updateNowPlayingInfo: Bool = false) {
		if #available(iOS 10.0, *) {
		     self.player.playImmediately(atRate: 1.0)
		     self.player.automaticallyWaitsToMinimizeStalling = false
		} else {
		     self.player.play()
		}
		
		if (updateNowPlayingInfo == true || self.didStopPlayback == true) {
			self.updateNowPlayingInfoIfNeeded()
		}
		self.didStopPlayback = false
		self.startPlaybackTimeChangeTimer()
		self.callPlayStateChangeCallbacks()
		if let currentTrack = self.currentTrack {
			NotificationCenter.default.post(name: Notification.Name(rawValue: self.playerStateChangedNotificationKey(track: currentTrack)), object: nil)
		}
	}

	open func play(_ audioTrack: AudioTrack) {
		log("play(audioTrack: \(audioTrack))")
		self.stop()
		self.play([audioTrack], at: 0)
	}

	open func play(_ audioTracks: [AudioTrack], at startIndex: Int) {
		log("play(audioTracks: \(audioTracks.count) tracks, startIndex: \(startIndex))")
		self.replace(with: audioTracks, at: startIndex)
		// Start playing the new track
		self.restartCurrentTrack()
	}

	open func replace(with audioTrack: AudioTrack) {
		log("replace(audioTrack: \(audioTrack))")
		self.replace(with: [audioTrack], at: 0)
	}

	open func replace(with audioTracks: [AudioTrack], at startIndex: Int) {
		log("replace(audioTracks: \(audioTracks.count) tracks, startIndex: \(startIndex))")
		self.stop()
		self.queue.replace(audioTracks, at: startIndex)
		self.queueGeneration += 1
	}

	open func prepend(_ audioTracks: [AudioTrack], toQueue generation: Int) {
		if (self.queueGeneration == generation) {
			log("Queue generation (\(generation)) gets prepended with \(audioTracks.count) tracks.")
			self.queue.prepend(audioTracks)
			self.callPlayStateChangeCallbacks()
		} else {
			log("Queue generation (\(generation)) isn't the same as the current (\(self.queueGeneration)). Won't prepend \(audioTracks.count) tracks.")
		}
	}

	open func append(_ audioTracks: [AudioTrack], toQueue generation: Int) {
		if (self.queueGeneration == generation) {
			log("Queue generation (\(generation)) gets appended with \(audioTracks.count) tracks.")
			self.queue.append(audioTracks)
			self.callPlayStateChangeCallbacks()
		} else {
			log("Queue generation (\(generation)) isn't the same as the current (\(self.queueGeneration)). Won't append \(audioTracks.count) tracks.")
		}
	}

	// MARK: - Pause

	open func pause() {
		self.player.pause()
		self.stopPlaybackTimeChangeTimer = true
		self.callPlaybackTimeChangeCallbacks()
		self.callPlayStateChangeCallbacks()
		if let currentTrack = self.currentTrack {
			NotificationCenter.default.post(name: Notification.Name(rawValue: self.playerStateChangedNotificationKey(track: currentTrack)), object: nil)
		}
	}

	open func stop(clearQueue: Bool = false) {
		if (self.didStopPlayback == false) {
			self.didStopPlayback = true
			if (clearQueue == true) {
				self.clearQueue()
			} else {
				self.player.seek(to: CMTimeMake(value: 0, timescale: 1))
				self.pause()
			}
			self.callPlayStateChangeCallbacks()
			self.callPlaybackTimeChangeCallbacks()
		} else if (clearQueue == true) {
			self.clearQueue()
		}
	}

	// MARK: - Forward

	open func canForward() -> Bool {
		return self.queue.canForward()
	}

	open func forward() {
		self.stop()
		if (self.queue.forward() == true) {
			self.restartCurrentTrack()
		}
	}

	// MARK: - Rewind

	open func canRewind() -> Bool {
		guard let currentTrack = self.currentTrack else {
			return false
		}

		if ((currentTrack.currentTimeInSeconds() > Float(1)) || self.canRewindInQueue()) {
			return true
		}

		return false
	}

	open func rewind() {
		guard let currentTrack = self.currentTrack else {
			self.stop()
			return
		}

		if (currentTrack.currentTimeInSeconds() <= Float(1) && self.canRewindInQueue() == true) {
			self.stop()
			if (self.queue.rewind() == true) {
				self.restartCurrentTrack()
			}
		} else {
			// Move to the beginning of the track if we aren't in the beginning.
			self.player.seek(to: CMTimeMake(value: 0, timescale: 1))
			// Update the now playing info to show the new playback time
			self.updateNowPlayingInfoIfNeeded()
			// Call the callbacks to inform about the new time
			self.callPlaybackTimeChangeCallbacks()
		}
	}

	open func seek(toTime time: CMTime) {
		self.player.seek(to: time)
	}

	open func seek(toProgress progress: Float) {
		let progressInSeconds = Int64(progress * (self.currentTrack?.durationInSeconds() ?? 0))
		let time = CMTimeMake(value: progressInSeconds, timescale: 1)
		self.seek(toTime: time)
	}

	// MARK: - Internal helper

	@objc open func trackDidFinishPlaying() {
		self.forward()
	}

	// MARK: - Playback time change callback

	open func addPlaybackTimeChangeCallback(_ sender: AnyObject, callback: @escaping (_ track: AudioTrack) -> Void) {
		let uid = "\(Unmanaged.passUnretained(sender).toOpaque())"
		if var callbacks = self.playbackPositionChangeCallbacks[uid] {
			callbacks.append(callback)
		} else {
			self.playbackPositionChangeCallbacks[uid] = [callback]
		}
	}

	open func removePlaybackTimeChangeCallback(_ sender: AnyObject) {
		let uid = "\(Unmanaged.passUnretained(sender).toOpaque())"
		self.playbackPositionChangeCallbacks.removeValue(forKey: uid)
	}

	// MARK: - Play state change callback

	open func addPlayStateChangeCallback(_ sender: AnyObject, callback: @escaping (_ track: AudioTrack?) -> Void) {
		let uid = "\(Unmanaged.passUnretained(sender).toOpaque())"
		if var callbacks = self.playStateChangeCallbacks[uid] {
			callbacks.append(callback)
		} else {
			self.playStateChangeCallbacks[uid] = [callback]
		}
	}

	open func removePlayStateChangeCallback(_ sender: AnyObject) {
		let uid = "\(Unmanaged.passUnretained(sender).toOpaque())"
		self.playStateChangeCallbacks.removeValue(forKey: uid)
	}

	// MARK: - Helper

	open func isPlaying() -> Bool {
		return (self.player.rate > 0)
	}

	// MARK: - INTERNAL -

	// MARK: - Properties

	var queueGeneration								= 0

	// MARK: - Initializaiton

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	func applicationDidEnterBackground(_ notification: Notification) {
		if (self.isPlaying() == false) {
			self.stop()
		}
	}

	// MARK: - Lifecycle

	func didUpdateMetadata() {
		self.callPlayStateChangeCallbacks()
	}

	// MARK: - PRIVATE -

	// MARK: - Properties

	fileprivate let audioPlayerManagerStateChangedPrefix	= "AudioPlayerManager.\(UUID().uuidString).playerStateChanged"

	fileprivate var queue									= AudioTracksQueue()

	fileprivate var didStopPlayback							= false

	// MARK: - Callbacks
	// swiftlint:disable syntactic_sugar
	fileprivate var playStateChangeCallbacks				= Dictionary<String, [((_ track: AudioTrack?) -> Void)]>()
	fileprivate var playbackPositionChangeCallbacks			= Dictionary<String, [((_ track: AudioTrack) -> Void)]>()
	// swiftlint:enable syntactic_sugar

	fileprivate var playbackPositionChangeTimer				: Timer?
	fileprivate var stopPlaybackTimeChangeTimer				= false

	// MARK: - Initializaiton

	fileprivate func setupAudioSession() {
		if #available(iOS 10.0, *) {
			_ = try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
		} else {
			// Workaround until https://forums.swift.org/t/using-methods-marked-unavailable-in-swift-4-2/14949 isn't fixed
			AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
		}
		_ = try? AVAudioSession.sharedInstance().setActive(true)
	}

	fileprivate func setupPlayer() {
		if #available(iOS 10.0, *) {
			self.player.automaticallyWaitsToMinimizeStalling = self.bufferStrategy == .minimizeStalling
		}

		if (self.player.responds(to: #selector(setter: AVAudioMixing.volume)) == true) {
			self.player.volume = 1.0
		}

		self.player.allowsExternalPlayback = true
		self.player.usesExternalPlaybackWhileExternalScreenIsActive = true
	}

	fileprivate func setupRemoteControlEvents() {
		if (self.useRemoteControlEvents == true) {
			UIApplication.shared.beginReceivingRemoteControlEvents()
		} else {
			UIApplication.shared.endReceivingRemoteControlEvents()
		}
	}

	// MARK: - Play

	fileprivate func restartCurrentTrack() {
		log("restartCurrentTrack")
		if (self.player != nil) {
			self.stop()
		}

		if let currentTrack = self.queue.currentTrack {
			currentTrack.loadResource()
			if let playerItem = currentTrack.avPlayerItem() {
				if #available(iOS 10.0, *) {
					playerItem.preferredForwardBufferDuration = self.preferredForwardBufferDuration
				}
				currentTrack.prepareForPlaying(playerItem)
				self.player.replaceCurrentItem(with: playerItem)
				self.play(updateNowPlayingInfo: true)
			}
		}
	}

	// MARK: - Rewind

	fileprivate func canRewindInQueue() -> Bool {
		return self.queue.canRewind()
	}

	// MARK: - Internal helper

	fileprivate func updateNowPlayingInfoIfNeeded() {
		if (self.useNowPlayingInfoCenter == true) {
			// Update the current play time
			self.currentTrack?.updateNowPlayingInfoPlaybackTime()
			MPNowPlayingInfoCenter.default().nowPlayingInfo = self.currentTrack?.nowPlayingInfo
		}
	}

	private func clearQueue() {
		self.queue.replace(nil, at: 0)
		self.queueGeneration += 1
		self.player.replaceCurrentItem(with: nil)
	}

	// MARK: - Plaback time change callback

	@objc func callPlaybackTimeChangeCallbacks() {
		self.updateNowPlayingInfoIfNeeded()
		// Increase the current tracks playing time if the player is playing
		if let currentTrack = self.currentTrack {
			for sender in self.playbackPositionChangeCallbacks.keys {
				if let callbacks = self.playbackPositionChangeCallbacks[sender] {
					for playbackPositionChangeClosure in callbacks {
						playbackPositionChangeClosure(currentTrack)
					}
				}
			}
		}

		if (self.stopPlaybackTimeChangeTimer == true) {
			self.playbackPositionChangeTimer?.invalidate()
		}
	}

	fileprivate func startPlaybackTimeChangeTimer() {
		self.stopPlaybackTimeChangeTimer = false
		self.playbackPositionChangeTimer = Timer.scheduledTimer(timeInterval: self.playingTimeRefreshRate, target: self, selector: #selector(AudioPlayerManager.callPlaybackTimeChangeCallbacks), userInfo: nil, repeats: true)
		self.playbackPositionChangeTimer?.fire()
	}

	// MARK: - Play state change callback

	func callPlayStateChangeCallbacks() {
		for sender in self.playStateChangeCallbacks.keys {
			if let callbacks = self.playStateChangeCallbacks[sender] {
				for playStateChangeClosure in callbacks {
					playStateChangeClosure(self.currentTrack)
				}
			}
		}
	}
}

extension AudioPlayerManager {

	public func playerStateChangedNotificationKey(track: AudioTrack) -> String {
		return "\(self.audioPlayerManagerStateChangedPrefix)_\(track.identifier() ?? "")"
	}
}
