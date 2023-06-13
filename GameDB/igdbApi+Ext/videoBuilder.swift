//
//  videoBuilder.swift
//  GameDB
//
//  Created by Parshva Shah on 6/6/23.
//

import Foundation

private let videoURL = "https://www.youtube.com"

public func videoBuilder(video_id: String) -> String {
    return "\(videoURL)/embed/\(video_id)"
}
