//
//  ViewController.swift
//  GTWaterFallFlowLayout
//
//  Created by 胡健 on 09/03/2016.
//  Copyright © 2016 Geetion. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController,WaterFallFlowLayoutDelegate,WaterFallFlowLayoutDatasource{
    
    var URL = "http://gank.io/api/data/福利/10/"
    var imgArray = NSMutableArray()
    var page = 2
    
    let wt = WaterFallFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        //        将url转换成utf-8
        URL = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        requestImage()
        
        requestMoreImage()
        
        wt.initWithFrameRect(self.view.frame)
        
        self.view = wt
        
        wt.delegate = self
        wt.dataSource = self
        
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
            
            self.wt.reloadData()
            
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
            
            self.wt.reloadData()
            
            self.page++
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
        }
    }
    
    func waterFallFlowLayout(didselectImageView indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    func waterFallFlowLayout(numberOfItemsInSection section:Int)->Int{
        return imgArray.count
    }
    
    func waterFallFlowLayout(heightofItemAtIndexPath indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat {
        
        let image = imgArray[indexPath.row]
        
        let newHeight = image.size.height/image.size.width * itemWidth
        
        return newHeight
    }
    
    func waterFallFlowLayout(viewAtIndexPath indexPath:NSIndexPath)->UIView {
        
        let imageView = UIImageView(image: imgArray[indexPath.row] as? UIImage)
        
        return imageView
    }
    
    func waterFallFlowLayout(numberOfColumnInSection section: Int) -> Int {
        return 4
    }
    
    func waterFallFlowLayout(insetForSectionOfIndex section: Int) -> EdgeSpace {
        return EdgeSpace(vertical: 10, horizontal: 10)
    }
    
}