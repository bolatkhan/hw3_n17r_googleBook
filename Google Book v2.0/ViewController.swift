//
//  ViewController.swift
//  Google Book v2.0
//
//  Created by user on 09.06.16.
//  Copyright © 2016 Roborzoid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var orderBy: UISegmentedControl!
    
    
    var stringURL: String!

    
    @IBAction func orderBy(sender: UISegmentedControl) {
        guard let keyword = searchBar.text else { return }
       if sender.selectedSegmentIndex == 0{
            stringURL="https://www.googleapis.com/books/v1/volumes?q=\(keyword)+inauthor:keyes&key=AIzaSyBP072Zl-Tv4BOZvYJiR9tREMRCTOUnq00"+"&orderBy=newest"
        
       }else {
            stringURL="https://www.googleapis.com/books/v1/volumes?q=\(keyword)+inauthor:keyes&key=AIzaSyBP072Zl-Tv4BOZvYJiR9tREMRCTOUnq00"+"&orderBy=relevance"
        
        }
        downloadBook()
        
    }
    
    /*
     maxResults	unsigned integer	Maximum number of results to return. Acceptable values are 0 to 40, inclusive.
     
     
     printType	string	Restrict to books or magazines.
     
     Acceptable values are:
     "all" - All volume content types.
     "books" - Just books.
     "magazines" - Just magazines.
     
     */
    
    var books = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        searchBar.delegate = self
        
        
        
        
        }
    
    func downloadBook(){
            guard let url = NSURL(string: stringURL) else {
            print("url problem")
            return
            
            }
        
            let urlRequest = NSMutableURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
        
            let task = session.dataTaskWithRequest(urlRequest) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            guard let jsonData = data else {
                print("no data has been downloaded")
                
                return
            
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) 
                
                let items = json["items"] as! [[String: AnyObject]]
                
                self.books = items
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                
                })
                
                } catch{
                print("error with JSON: ")
                }
            
            
            }
        
        task.resume()
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailsTableViewCell", forIndexPath: indexPath) as! detailsTableViewCell
        
        if let volumeInfo = self.books[indexPath.row]["volumeInfo"] as? [String: AnyObject] {
            cell.name?.text = volumeInfo["title"] as? String
            cell.descrition?.text = volumeInfo["subtitle"] as? String
            cell.publisher?.text = volumeInfo["publisher"] as? String
            
            
            guard let arrayAuthors = volumeInfo["authors"] as? NSArray else { return cell }
            
            cell.author?.text = arrayAuthors.componentsJoinedByString(" ,")
            
         //   let imgUrl = volumeInfo["smallThumbnail"] as! String
            
            if let imageLinks = volumeInfo["imageLinks"], imgUrl = imageLinks["thumbnail"] as? String {
                //print(thumbnail)
                
                let url = NSURL(string: imgUrl)

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    dispatch_async(dispatch_get_main_queue(), {
                        guard let data = data else { return }
                        cell.thumImage.image = UIImage(data: data)
                    });
                }
                
            }
           // print(imgUrl)
        }
        return cell
    }
    
}



extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let bookTitle = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        stringURL = "https://www.googleapis.com/books/v1/volumes?q=\(bookTitle)+inauthor:keyes&key=AIzaSyBP072Zl-Tv4BOZvYJiR9tREMRCTOUnq00"
        self.downloadBook()
        searchBar.resignFirstResponder()
        
    }

}







