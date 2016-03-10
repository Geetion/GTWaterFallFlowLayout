//
//  ViewController.swift
//  GTWaterFallFlowLayout
//
//  Created by 胡健 on 09/03/2016.
//  Copyright © 2016 Geetion. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    var URL = "http://gank.io/api/data/福利/10/"
    var imgArray = NSMutableArray()
    var page = 2
    let col = 3
    var WIDTH:CGFloat?
    private var cell_X = [CGFloat]()
    
    private var cell_Y = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        将url转换成utf-8
        URL = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        requestImage()
        
        requestMoreImage()
        
        WIDTH = self.view.frame.width
        
        getCellOrigin()
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
    }
    
    func getCellOrigin(){
        
        for(var i = 0;i<col;i++ ){
            let newcell_X = self.WIDTH! / CGFloat(self.col) * CGFloat(i) + 5
            
            cell_X.append(newcell_X)
            
            cell_Y.append(5)
        }
        
    }
    
    func requestImage(){
        
        let manager = AFHTTPSessionManager();
        
        let firstRequest:String = URL + "1"
        
        manager.GET(firstRequest, parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let results = resp?.objectForKey("results") as! NSArray
            
            let currentArray = NSMutableArray()
            
            for each in results{
                
                let imgUrl = NSURL(string: (each["url"]!)! as! String)
                
                let data = NSData(contentsOfURL: imgUrl!)
                
                let image = UIImage(data: data!)
                
                currentArray.addObject(image!)
                
            }
            
            self.imgArray = currentArray
            
            self.collectionView?.reloadData()
            
            
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
        }
    }
    
    func requestMoreImage(){
        
        let manager = AFHTTPSessionManager();
        
        let requestUrl = URL + String(page)
        
        manager.GET(requestUrl, parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let results = resp?.objectForKey("results") as! NSArray
            
            for each in results{
                
                let imgUrl = NSURL(string: (each["url"]!)! as! String)
                
                let data = NSData(contentsOfURL: imgUrl!)
                
                let image = UIImage(data: data!)
                
                self.imgArray.addObject(image!)
                
            }
            self.collectionView?.reloadData()
            
            self.page++
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
        }
    }
    
    func sizeForItemAtIndexPath(indexPath: Int) -> CGSize {
        
        let newWidth = (WIDTH! - CGFloat(col + 1) * (5) )/CGFloat(col)
        
        let image = imgArray[indexPath]
        
        let newHeight = image.size.height/image.size.width * newWidth
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
//    func layoutView(){
//        
//        for (var i = 0;i<itemNumber;i++){
//            
//
//            
//            self.scrollView.addSubview(imageView!)
//        }
//    
//        
//    }
    
    func getViewHeight()->CGFloat{
        
        var maxHeight:CGFloat = 0
        
        for each in cell_Y{
            
            maxHeight = each > maxHeight ? each:maxHeight
        }
        
        return maxHeight
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        let img = UIImageView(image: imgArray[indexPath.row] as? UIImage)
        
        let currentCol = indexPath.row % self.col
        
//        cell.frame.origin = CGPoint(x: cell_X[currentCol], y: cell_Y[currentCol])
        
        img.frame = cell.bounds
    
        cell.addSubview(img)
        
        cell_Y[currentCol] = cell_Y[currentCol] + img.frame.height + 5
        
//        let maxHeight = getViewHeight()
//        
//        self.collectionView!.contentSize = CGSize(width: WIDTH!, height: maxHeight)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return imgArray.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        let newWidth = (WIDTH! - CGFloat(col + 1) * (5) )/CGFloat(col)
        
        let image = imgArray[indexPath.row]
        
        let newHeight = image.size.height/image.size.width * newWidth
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    
    
}