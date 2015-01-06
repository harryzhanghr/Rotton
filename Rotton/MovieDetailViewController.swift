//
//  MovieDetailViewController.swift
//  Rotton
//
//  Created by haoran zhang on 1/4/15.
//  Copyright (c) 2015 haoran zhang. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var cellInfo: MovieCell!
    var mainVC: MovieViewController!
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var movieTitle: UINavigationItem!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet var imageExpand: UITapGestureRecognizer!
    @IBOutlet var detailExpand: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bgImage.userInteractionEnabled = true
        imageExpand.addTarget(self, action: "imageExpanding")
        detailExpand.addTarget(self, action: "detailExpand")
    }

    func imageExpanding() {
        print("hi")
        UIView.animateWithDuration(0.5, animations: {
            var tempFrame = self.detailView.frame
            tempFrame.origin.y = self.view.bounds.height
            self.detailView.frame = tempFrame
            self.navigationController?.navigationBarHidden = true
        })
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setUp() {
        print(cellInfo.poster.image == nil)
//        bgImage.image = cellInfo.poster.image
        movieTitle.title = cellInfo.movieTitle.text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
