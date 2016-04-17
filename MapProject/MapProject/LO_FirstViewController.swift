//
//  LO_FirstViewController.swift
//  MapProject
//
//  Created by 杨少锋 on 16/4/17.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  POI检索


import UIKit

class LO_FirstViewController: UIViewController,BMKMapViewDelegate, BMKPoiSearchDelegate,UITextFieldDelegate {
    var poiSearch: BMKPoiSearch!
    weak var rootMap : BMKMapView!
    weak var poiTextFiled : UITextField!
    var sureButton: UIButton!
    var currPageIndex: Int32 = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.poiSearch = BMKPoiSearch()
        let map  = BMKMapView(frame: CGRectMake(0, 100, self.view.bounds.size.width,self.view.bounds.size.height-100))
        self.rootMap = map
        self.rootMap.zoomLevel = 13
        self.view.addSubview(self.rootMap)
        
        let textField = UITextField(frame: CGRectMake(20, 20, 250, 50))
        self.poiTextFiled = textField;
        self.poiTextFiled.placeholder = "请输入你要搜索的地点,例如餐厅,酒店"
        self.poiTextFiled.delegate = self;
        self.view.addSubview(textField)
        
        self.sureButton = UIButton(type: UIButtonType.System)
        self.sureButton.setTitle("确定", forState: UIControlState.Normal)
        self.sureButton.frame = CGRectMake(300, 20, 30, 50)
        self.sureButton .addTarget(self, action: "sureButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.sureButton)
        
    }
    
    func sureButtonAction() {
        self.sendPoiSearchRequest()
        self.poiTextFiled.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.sendPoiSearchRequest()
        self.poiTextFiled.resignFirstResponder()
        return true
        // 酒店
    }
    
    func sendPoiSearchRequest() {
        let citySearchOption = BMKCitySearchOption()
        citySearchOption.pageIndex = self.currPageIndex++
        citySearchOption.pageCapacity = 10
        citySearchOption.city = "北京"
        citySearchOption.keyword = self.poiTextFiled.text
        if poiSearch.poiSearchInCity(citySearchOption) {
            print("城市内检索发送成功！")
        }else {
            print("城市内检索发送失败！")
        }
    }
    
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        print("onGetPoiResult code: \(errorCode)");
        // 清除屏幕中所有的 annotation
        self.rootMap.removeAnnotations(self.rootMap.annotations)
        if errorCode == BMK_SEARCH_NO_ERROR {
            var annotations = [BMKPointAnnotation]()
            for i in 0..<poiResult.poiInfoList.count {
                let poi = poiResult.poiInfoList[i] as! BMKPoiInfo
                let item = BMKPointAnnotation()
                item.coordinate = poi.pt
                item.title = poi.name
                annotations.append(item)
            }
           self.rootMap.addAnnotations(annotations)
        self.rootMap.showAnnotations(annotations, animated: true)
        } else if errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD {
            print("检索词有歧义")
        } else {
            // 各种情况的判断……
        }
    }

    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let AnnotationViewID = "renameMark"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(AnnotationViewID) as! BMKPinAnnotationView?
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            // 设置颜色
            annotationView!.pinColor = UInt(BMKPinAnnotationColorRed)
            // 从天上掉下的动画
            annotationView!.animatesDrop = true
            // 设置是否可以拖拽
            annotationView!.draggable = false
        }
        annotationView?.annotation = annotation
        return annotationView
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.rootMap.delegate = self
        self.poiSearch.delegate = self
        self.rootMap.viewWillAppear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.rootMap.delegate = nil
        self.poiSearch.delegate = nil
        self.rootMap.viewWillDisappear()
    }
}
