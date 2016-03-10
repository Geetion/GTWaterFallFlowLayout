//
//  GTWaterFallFlowLayoutProtocol.swift
//  GTWaterFallFlowLayout
//
//  Created by 胡健 on 09/03/2016.
//  Copyright © 2016 Geetion. All rights reserved.
//

import UIKit


public struct EdgeSpace {
    public var vertical: CGFloat
    public var horizontal: CGFloat
    public init(vertical: CGFloat, horizontal: CGFloat){
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

protocol WaterFallFlowViewDatasource{
    
    func waterFallFlowView(numberOfItemsInSection section:Int)->Int
    
    func waterFallFlowView(heightofItemAtIndexPath indexPath:NSIndexPath,itemWidth:CGFloat)->CGFloat
    
    func waterFallFlowView(viewAtIndexPath indexPath:NSIndexPath)->UIView
    
    //    optional
    
    func waterFallFlowView(numberOfColumnInSection section:Int)->Int
    
    func waterFallFlowView(insetForSectionOfIndex section:Int)->EdgeSpace
    
}

extension WaterFallFlowViewDatasource{
    
    func waterFallFlowView(numberOfColumnInSection section:Int)->Int{return 3}
    
    func waterFallFlowView(insetForSectionOfIndex section:Int)->EdgeSpace{return EdgeSpace(vertical: 5, horizontal: 5)}
}

@objc protocol WaterFallFlowViewDelegate{
    
    optional func waterFallFlowView(didselectImageView indexPath:NSIndexPath)
    
    optional func waterFallFlowViewDidScroll(scrollView: UIScrollView)
    
}
