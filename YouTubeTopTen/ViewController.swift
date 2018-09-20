//
//  ViewController.swift
//  YouTubeTopTen
//
//  Created by Bryan Mazariegos on 9/17/18.
//  Copyright © 2018 Bryan Mazariegos. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import youtube_ios_player_helper


class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, UITabBarDelegate, YTPlayerViewDelegate {
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeYouTubeReadonly]
    private let service = GTLRYouTubeService()
    private var greyScreen = UIView()
    var videoList:[YTVideoCellData] = [YTVideoCellData]()
    var videoTypeFilter = "any"
    
    @IBOutlet var videosTableView:UITableView?
    @IBOutlet var videoTypeSelectionBar:UITabBar?
    @IBOutlet var searchBar:UISearchBar?
    @IBOutlet var activityIndicator:UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        videoTypeSelectionBar?.selectedItem = videoTypeSelectionBar?.items![0]
        videosTableView?.allowsSelection = true
        searchBar?.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Ask for Top 10 video with user's search query, top rated
    func fetchTopVideos(_ withQuery:String) {
        activityIndicator?.startAnimating()
        videoList.removeAll()
        print("Query used: " + withQuery)
        let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
        query.maxResults = 10
        query.order = "viewCount"
        query.q = withQuery
        query.type = "video"
        query.videoType = videoTypeFilter
        
        service.shouldFetchNextPages = false
        service.apiKey = "AIzaSyBr8ZLhPQKWxzgVlQOgqzyTTHxCOSYvD0o"
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(processResultWithTicketForTopList(ticket:finishedWithObject:error:)))
    }
    
    //Process the response for the Top 10 Search
    @objc func processResultWithTicketForTopList(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_SearchListResponse,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        if let videos = response.items, !videos.isEmpty {
            for video in response.items! {
                let videoData = YTVideoCellData()
                videoData.thumbnailURL = (video.snippet?.thumbnails?.defaultProperty?.url)!
                videoData.videoTitle = (video.snippet?.title!)!
                videoData.channelTitle = (video.snippet?.channelTitle!)!
                videoData.publishedDate = String(describing:video.snippet!.publishedAt!.date)
                videoData.videoID = (video.identifier?.videoId)!
                
                videoList.append(videoData)
            }
            print("Vid List Updated!")
            
            let query = GTLRYouTubeQuery_VideosList.query(withPart: "contentDetails,snippet")
            query.maxResults = 10
            var videoIdList = ""
            for video in videoList {
                videoIdList += "\(video.videoID),"
            }
            
            videoIdList.removeLast()
            query.identifier = videoIdList
            
            service.shouldFetchNextPages = false
            service.apiKey = "AIzaSyBr8ZLhPQKWxzgVlQOgqzyTTHxCOSYvD0o"
            service.executeQuery(query,
                                 delegate: self,
                                 didFinish: #selector(processResultWithTicketForExtraInfo(ticket:finishedWithObject:error:)))
        } else {
            activityIndicator?.stopAnimating()
            let searchText:String = searchBar!.text as! String
            showAlert(title: "Your search for '\(searchText)' returned empty", message: "Your search for '\(searchText)' returned empty. It seems the selected category (\(videoTypeFilter.capitalized)) doesn't have any videos of this type. Try a different category.")
        }
    }
    
    //Process Extra Info of each video found in our Top 10 list
    @objc func processResultWithTicketForExtraInfo(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_VideoListResponse,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        if let videos = response.items, !videos.isEmpty {
            for (i,video) in response.items!.enumerated() {
                videoList[i].videoType = (video.snippet?.categoryId)!
                videoList[i].duration = (video.contentDetails?.duration)!
                videoList[i].duration.removeFirst()
                videoList[i].duration.removeFirst()
            }
            print("Vid List Updated for durations!")
            
            videosTableView?.reloadData()
            activityIndicator?.stopAnimating()
        }
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            fetchTopVideos(searchBar.text!)
        }
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ytVideoCell") as! YTVideoCell
        let videoData:YTVideoCellData = videoList[indexPath.row]
        
        do {
            let data = try Data(contentsOf: URL(string: videoData.thumbnailURL)!)
            cell.thumbnail?.image = UIImage(data: data)
        } catch {
            
        }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: videoData.publishedDate) {
            cell.publishedDate?.text = dateFormatterPrint.string(from: date)
        }
        else {
            print("There was an error decoding the string")
        }
        
        if videoData.duration.contains("M") {
            videoData.duration.insert(" ", at: videoData.duration.index(after: videoData.duration.index(of: "M")!))
        } else if videoData.duration.contains("H") {
            videoData.duration.insert(" ", at: videoData.duration.index(after: videoData.duration.index(of: "H")!))
        }
        
        cell.videoTitle?.text = videoData.videoTitle
        cell.duration?.text = videoData.duration.lowercased()
        cell.channelTitle?.text = videoData.channelTitle
        
        //Video is under Show Category
        if videoData.videoType == "43" {
            cell.videoType?.image = UIImage(named: "tvIcon.png")
        } else if videoData.videoType ==  "30" { //Video is under Movie Category
            cell.videoType?.image = UIImage(named: "movieIcon.png")
        } else { //Video is Any/Other
            cell.videoType?.image = UIImage(named: "anyIcon.png")
            print("Video named, \(videoData.videoTitle), has typeId: \(videoData.videoType)")
        }
        
        cell.videoType?.tintColor = UIColor.init(red: 222/255, green: 197/255, blue: 62/255, alpha: 1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedGreyArea))
        
        let darken = UIView(frame: self.view.frame)
        darken.backgroundColor = UIColor(white: 0.25, alpha: 0.5)
        darken.addGestureRecognizer(tapRecognizer)
        
        let player = YTPlayerView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.midY - (self.view.frame.width * 0.4), width: self.view.frame.width, height: self.view.frame.width * 0.75))
        player.load(withVideoId: videoList[indexPath.row].videoID, playerVars: ["origin":"https://www.youtube.com","autoplay":"1"])
        player.delegate = self
        //player.load(withVideoId: videoList[indexPath.row].videoID)
        
        self.view.addSubview(darken)
        darken.addSubview(player)
        greyScreen = darken
        
        print("Tried playing video with ID: \(videoList[indexPath.row].videoID)")
    }
    
    @objc func tappedGreyArea() {
        greyScreen.removeFromSuperview()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == YTPlayerState.ended {
            self.tappedGreyArea()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 0 {
            videoTypeFilter = "any"
        } else if tabBarController.selectedIndex == 1 {
            videoTypeFilter = "movie"
        } else {
            videoTypeFilter = "episode"
        }
        
        print("Changed Video Filter to: \(videoTypeFilter)")
        fetchTopVideos(searchBar!.text!)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.items![0] == item {
            videoTypeFilter = "any"
        } else if tabBar.items![1] == item {
            videoTypeFilter = "movie"
        } else if tabBar.items![2] == item {
            videoTypeFilter = "episode"
        }
        
        print("Changed Video Filter to: \(videoTypeFilter)")
        fetchTopVideos(searchBar!.text!)
    }
    
    
}
