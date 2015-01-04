//
//  MovieViewController.swift
//  Rotton
//
//  Created by haoran zhang on 1/4/15.
//  Copyright (c) 2015 haoran zhang. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate{

    @IBOutlet weak var myTable: UITableView!
    
    var movies: [NSDictionary] = []
    var isMovie: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var movieURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=50&country=us&apikey=ggvjpt8kdbru4rsvc8nqp65q"
        var movieRequest = NSURLRequest(URL: NSURL(string: movieURL)!)
        var dvdURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=ggvjpt8kdbru4rsvc8nqp65q"
        var dvdRequest = NSURLRequest(URL: NSURL(string: dvdURL)!)
        if self.isMovie {
            NSURLConnection.sendAsynchronousRequest(movieRequest, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = object["movies"] as [NSDictionary]
                self.myTable.reloadData()
            }
        } else {
            NSURLConnection.sendAsynchronousRequest(dvdRequest, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = object["movies"] as [NSDictionary]
                self.myTable.reloadData()
            }
        }
    }
    
//    func urlCompletionHelper(response: NSURLResponse!, data: NSData!, error: NSError!) {
//        var obejct = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = myTable.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        var movie = movies[indexPath.row]
        cell.movieTitle.text = movie["title"] as? String
        cell.movieDescription.text = movie["synopsis"] as? String
        var posters = movie["posters"] as NSDictionary
        var posterURL = posters["thumbnail"] as String
        cell.poster.setImageWithURL(NSURL(string: posterURL))
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("movieDetailSeg", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetailSeg" {
            let detailVC = segue.destinationViewController as MovieDetailViewController
            let indexPath: NSIndexPath = myTable.indexPathForSelectedRow()!
            var movie = movies[indexPath.row]
            var posters = movie["posters"] as NSDictionary
            var posterURL = posters["thumbnail"] as String
            print(posterURL)
            detailVC.bgImage.setImageWithURL(NSURL(string: posterURL))
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if item.title == "Movies" {
            isMovie = true
            viewDidLoad()
        } else if item.title == "DVDs" {
            isMovie = false
            viewDidLoad()
        }
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
