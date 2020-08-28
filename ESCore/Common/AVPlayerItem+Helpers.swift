//
//  AVPlayerItem+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 8/25/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import AVFoundation

public extension AVPlayerItem {
    var totalBufferSeconds: Double {
        return self.loadedTimeRanges
            .map({ $0.timeRangeValue })
            .reduce(0, { acc, cur in
                return acc + CMTimeGetSeconds(cur.start) + CMTimeGetSeconds(cur.duration)
            })
    }

    var currentBufferSeconds: Double {
        let currentTime = self.currentTime()

        guard let timeRange = self.loadedTimeRanges.map({ $0.timeRangeValue })
            .first(where: { $0.containsTime(currentTime) }) else { return -1 }

        return CMTimeGetSeconds(timeRange.end) - currentTime.seconds
    }
}

