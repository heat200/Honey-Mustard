//
//  YTVideoCell.swift
//  YouTubeTopTen
//
//  Created by Bryan Mazariegos on 9/18/18.
//  Copyright © 2018 Bryan Mazariegos. All rights reserved.
//

import UIKit

class YTVideoCell:UITableViewCell {
    //This is our custom TableViewCell for connections to UI elements
    @IBOutlet var thumbnail:UIImageView?
    @IBOutlet var videoTitle:UILabel?
    @IBOutlet var duration:UILabel?
    @IBOutlet var channelTitle:UILabel?
    @IBOutlet var publishedDate:UILabel?
    @IBOutlet var videoType:UIImageView?
}
