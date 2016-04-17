//
//  LO_RouteAnnotation.swift
//  MapProject
//
//  Created by 杨少锋 on 16/4/17.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  大头针

import UIKit
// 标记导航时换乘
class LO_RouteAnnotation: BMKPointAnnotation {
    var type: Int!///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    var degree: Int!
    
    override init() {
        super.init()
    }
    
    init(type: Int, degree: Int) {
        self.type = type
        self.degree = degree
    }
}


// 用户输入位置的标记
class LO_Annotation: BMKPointAnnotation {
    var pointImage : UIImage?
}
