//
//  LoadingScreen.swift
//  YouTubeTopTen
//
//  Created by Bryan Mazariegos on 9/19/18.
//  Copyright © 2018 Bryan Mazariegos. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {
    @IBOutlet var loadingHoneyMustardLogo:UIImageView?
    @IBOutlet var honeyMustardPosition: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pullUpLogo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pullUpLogo() {
        self.loadingHoneyMustardLogo?.center.x = self.view.frame.midX
        UIView.animate(withDuration: 0.85, animations: {
            self.honeyMustardPosition.constant = -self.view.frame.height * 1.1
            self.view.layoutIfNeeded()
        },completion: { (finished:Bool) in
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! ViewController
            self.present(mainVC, animated: true, completion: nil)
        })
    }
}
