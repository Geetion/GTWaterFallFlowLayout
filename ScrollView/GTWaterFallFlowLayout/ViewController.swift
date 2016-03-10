//
//  ViewController.swift
//  GTWaterFallFlowLayout
//
//  Created by 胡健 on 09/03/2016.
//  Copyright © 2016 Geetion. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController,WaterFallFlowViewDelegate,WaterFallFlowViewDatasource{
    
    var URL = "http://gank.io/api/data/福利/10/"
    var imgArray = NSMutableArray()
    var page = 2
    
    let wt = WaterFallFlowView()
    
    var isfresh = true
    
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
            
            self.isfresh = true
            
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
        }
    }
    
    func waterFallFlowView(didselectImageView indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    func waterFallFlowView(numberOfItemsInSection section:Int)->Int{
        return imgArray.count
    }
    
    func waterFallFlowView(heightofItemAtIndexPath indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat {
        
        let image = imgArray[indexPath.row]
        
        let newHeight = image.size.height/image.size.width * itemWidth
        
        return newHeight
    }
    
    func waterFallFlowView(viewAtIndexPath indexPath:NSIndexPath)->UIView {
        
        let imageView = UIImageView(image: imgArray[indexPath.row] as? UIImage)
        
        return imageView
    }
    
    func waterFallFlowView(numberOfColumnInSection section: Int) -> Int {
        return 2
    }
    
    func waterFallFlowView(insetForSectionOfIndex section: Int) -> EdgeSpace {
        return EdgeSpace(vertical: 10, horizontal: 10)
    }
    
    func waterFallFlowViewDidScroll(scrollView: UIScrollView) {
        if(scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height < 100){
            requestMoreImage()
            isfresh = false
        }
    }
    
}