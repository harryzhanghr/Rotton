//
//  MovieViewController.swift
//  Rotton
//
//  Created by haoran zhang on 1/4/15.
//  Copyright (c) 2015 haoran zhang. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var moviesBarItem: UITabBarItem!
    @IBOutlet weak var dvdsBarItem: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var searchBar: UISearchBar!

    var movies: [NSDictionary] = []
    var isMovie: Bool = true
    var refreshControl: UIRefreshControl!

    let movieURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=50&country=us&apikey=ggvjpt8kdbru4rsvc8nqp65q"
//    let movieRequest = NSURLRequest(URL: NSURL(string: movieURL)!)
    let dvdURL:String = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=ggvjpt8kdbru4rsvc8nqp65q"
//    let dvdRequest = NSURLRequest(URL: NSURL(string: dvdURL)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadTableContents()
        
        self.refreshControl = UIRefreshControl()
        var attributedString = NSMutableAttributedString(string: "Pull down to refersh")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0, attributedString.length))
        self.refreshControl.attributedTitle = attributedString
        self.refreshControl.tintColor = UIColor(red: 218.0/255.0, green: 165.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.myTable.addSubview(self.refreshControl)
        self.myTable.backgroundView = refreshControl
//        self.refreshControl.layer.zPosition = self.myTable.backgroundView!.layer.zPosition - 1
    }
    
    func refresh() {
        loadTableContents()
        searchBar.text.removeAll(keepCapacity: true)
        self.refreshControl.endRefreshing()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText  == "" {
            loadTableContents()
        } else {
            print("hi")
            var escapedSearchTerm = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            var url = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=\(escapedSearchTerm!)&page_limit=20&apikey=axku2sndnpg2d6dhjw59wj3d&country=us"
            var request = NSURLRequest(URL: NSURL(string: url)!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if (error != nil) {
                    return
                }
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = object["movies"] as [NSDictionary]
                self.myTable.reloadData()
                self.tabBar.selectedItem = self.moviesBarItem
            }

        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }

    
    func loadTableContents() {
        var movieURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=50&country=us&apikey=ggvjpt8kdbru4rsvc8nqp65q"
        var movieRequest = NSURLRequest(URL: NSURL(string: movieURL)!)
        var dvdURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=ggvjpt8kdbru4rsvc8nqp65q"
        var dvdRequest = NSURLRequest(URL: NSURL(string: dvdURL)!)
        if self.isMovie {
            NSURLConnection.sendAsynchronousRequest(movieRequest, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if (error != nil) {
                    return
                }
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = object["movies"] as [NSDictionary]
                self.myTable.reloadData()
                self.tabBar.selectedItem = self.moviesBarItem
            }
        } else {
            NSURLConnection.sendAsynchronousRequest(dvdRequest, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = object["movies"] as [NSDictionary]
                self.myTable.reloadData()
                self.tabBar.selectedItem = self.dvdsBarItem
            }
        }
    }
    
    
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
        myTable.deselectRowAtIndexPath(indexPath, animated: false)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetailSeg" {
            let detailVC = segue.destinationViewController as MovieDetailViewController
            detailVC.mainVC = self
            let indexPath: NSIndexPath = myTable.indexPathForSelectedRow()!
//            var movie = movies[indexPath.row]
//            var posters = movie["posters"] as NSDictionary
//            var posterURL = posters["thumbnail"] as String
//            print(posterURL)
            detailVC.cellInfo = myTable.cellForRowAtIndexPath(indexPath) as MovieCell
            detailVC.setUp()
//            detailVC.bgImage.setImageWithURL(NSURL(string: posterURL))
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        println(item)
        if item.title == "Movies" {
            isMovie = true
            loadTableContents()
        } else if item.title == "DVDs" {
            isMovie = false
            loadTableContents()
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
