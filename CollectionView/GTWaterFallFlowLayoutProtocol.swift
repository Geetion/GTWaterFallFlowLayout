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

protocol WaterFallFlowLayoutDatasource{
    
    func waterFallFlowLayout(numberOfItemsInSection section:Int)->Int
    
    func waterFallFlowLayout(heightofItemAtIndexPath indexPath:NSIndexPath,itemWidth:CGFloat)->CGFloat
    
    func waterFallFlowLayout(viewAtIndexPath indexPath:NSIndexPath)->UIView
    
    //    optional
    
    func waterFallFlowLayout(numberOfColumnInSection section:Int)->Int
    
    func waterFallFlowLayout(insetForSectionOfIndex section:Int)->EdgeSpace
    
}

extension WaterFallFlowLayoutDatasource{
    func waterFallFlowLayout(numberOfColumnInSection section:Int)->Int{return 3}
    
    func waterFallFlowLayout(insetForSectionOfIndex section:Int)->EdgeSpace{return EdgeSpace(vertical: 5, horizontal: 5)}
}

protocol WaterFallFlowLayoutDelegate{
    
    func waterFallFlowLayout(didselectImageView indexPath:NSIndexPath)
    
}
