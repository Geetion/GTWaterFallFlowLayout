//
//  WaterFallFlowLayout.swift
//  For Code
//
//  Created by 胡健 on 26/02/2016.
//  Copyright © 2016 GeekTeen. All rights reserved.
//

import UIKit

class WaterFallFlowView: UIView,UIScrollViewDelegate,UITableViewDelegate{
    var dataSource:WaterFallFlowViewDatasource?
    
    var delegate:WaterFallFlowViewDelegate?
    
    private var WIDTH:CGFloat?
    
    private var col:Int = 3
    
    private var cell_X = [CGFloat]()
    
    private var cell_Y = [CGFloat]()
    
    private var scrollView = UIScrollView()
    
    private var itemNumber = Int()
    
    private var cellOrigin = [CGRect]()
    
    private var edgeSpace:EdgeSpace?
    
    private var beginNumber = 0
    
    func initWithFrameRect(frame:CGRect){
        
        self.frame = frame
        
        self.backgroundColor = UIColor.whiteColor()
        
        scrollView = UIScrollView(frame: frame)
        scrollView.scrollEnabled = true
        scrollView.bounces = true
        scrollView.delegate = self
        
        WIDTH = self.frame.width
        
        self.addSubview(scrollView)
    }
    
    func getCellOrigin(){
        
        for(var i = 0;i<col;i++ ){
            let newcell_X = self.WIDTH! / CGFloat(self.col) * CGFloat(i) + (edgeSpace?.horizontal)!
            
            cell_X.append(newcell_X)
            
            cell_Y.append((edgeSpace?.vertical)!)
        }
        
    }
    
    func reloadData(){
        
        resetData()
        
        layoutView()
    }
    
    func resetData(){
        if(dataSource != nil ){
            
            itemNumber = (dataSource?.waterFallFlowView(numberOfItemsInSection: 0))!
            
            if let newCol = dataSource?.waterFallFlowView(numberOfColumnInSection: 0){
                col = newCol
            }
            
            if let newEdgeSpace = dataSource?.waterFallFlowView(insetForSectionOfIndex: 0){
                edgeSpace = newEdgeSpace
            }
            
            getCellOrigin()
        }
    }
    
    func layoutView(){
        
        for (var i = beginNumber;i<itemNumber;i++){
            
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            
            let imageView = dataSource?.waterFallFlowView(viewAtIndexPath: indexPath)
            
            imageView!.frame.size = sizeForItemAtIndexPath(i)
            
            let currentCol = i % self.col
            
            imageView!.frame.origin = CGPoint(x: cell_X[currentCol], y: cell_Y[currentCol])
            
            cellOrigin.append(imageView!.frame)
            
            cell_Y[currentCol] = cell_Y[currentCol] + imageView!.frame.height + (edgeSpace?.vertical)!
            
            
            imageView!.tag = i + 1
            
            let touch = UITapGestureRecognizer(target: self, action: "didSelectImageView:")
            
            imageView!.userInteractionEnabled = true
            imageView!.addGestureRecognizer(touch)
            
            self.scrollView.addSubview(imageView!)
        }
        
        beginNumber = itemNumber
        
        let maxHeight = getViewHeight()
        
        self.scrollView.contentSize = CGSize(width: WIDTH!, height: maxHeight)
        
    }
    
    func getViewHeight()->CGFloat{
        
        var maxHeight:CGFloat = 0
        
        for each in cell_Y{
            
            maxHeight = each > maxHeight ? each:maxHeight
        }
        
        return maxHeight
    }
    
    
    func sizeForItemAtIndexPath(indexPath: Int) -> CGSize {
        
        let newindexPath = NSIndexPath(forRow: indexPath, inSection: 0)
        
        let newWidth = (WIDTH! - CGFloat(col + 1) * (edgeSpace?.horizontal)! )/CGFloat(col)
        
        let newHeight = dataSource?.waterFallFlowView(heightofItemAtIndexPath: newindexPath, itemWidth: newWidth)
        
        return CGSize(width: newWidth, height: newHeight!)
    }
    
    func didSelectImageView(tap:UIGestureRecognizer){
        
        let indexPath = NSIndexPath(forRow: tap.view!.tag, inSection: 0)
        
        delegate?.waterFallFlowView!(didselectImageView: indexPath)
    }
    
    func checkItemVisible(){
        
        for (var i = 1;i<=itemNumber;i++){
            
            let view = self.viewWithTag(i)
            let lastView = self.viewWithTag(i - col)
            
//            print(view?.frame.origin.y)
//            print(lastView?.frame.origin.y)
//            if( view?.frame.origin.y > scrollView.contentOffset.y){
//                lastView?.alpha = 0
//            }else{
//                lastView?.alpha = 1
//            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        checkItemVisible()
//        print(scrollView.contentOffset.y)
        delegate?.waterFallFlowViewDidScroll?(scrollView)
    }
    
}
