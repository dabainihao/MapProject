//
//  ViewController.swift
//  MapProject
//
//  Created by 杨少锋 on 16/4/13.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  地图定位, 编码, 插大头针

import UIKit

class ViewController: UIViewController,BMKMapViewDelegate,UITextFieldDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate {
    lazy var map : BMKMapView? =  {
        BMKMapView()
    }()
    lazy var locService : BMKLocationService? = {
        BMKLocationService()
    }()
    lazy var geo: BMKGeoCodeSearch? = {
        BMKGeoCodeSearch()
    }()
    lazy var expectAddress: UITextField! = {
        UITextField()
    }()
    // route搜索服务
    lazy var routeSearch: BMKRouteSearch! = {
        BMKRouteSearch()
    }()
    
    lazy var titleView : UIView! = {
        UIView()
    }()

    var loginButton : UIButton!
    var sureButton: UIButton!
    var routePlannButton : UIButton!
    var userLocation :CLLocation?
    var expectLocation : String?
    var label : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "路线规划"
        if (!CLLocationManager.locationServicesEnabled()) {
            print("定位服务当前可能尚未打开，请设置打开！")
            return;
        }
        self.locService?.allowsBackgroundLocationUpdates = false;
        self.locService?.distanceFilter = 100
        self.locService?.desiredAccuracy = 100
        self.locService?.startUserLocationService();
        
        self.map?.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height)
        self.map?.delegate = self
        self.map?.showsUserLocation = true
        self.map?.mapType = 1;
        // 地图比例尺级别，在手机上当前可使用的级别为3-21级
        self.map?.zoomLevel = 19;
        self.map?.userTrackingMode = BMKUserTrackingModeNone;   // 设置定位状态
        self.view.addSubview(self.map!)
        
        self.titleView.frame = CGRectMake(20, 40, self.view.frame.size.width - 40, 50)
        self.titleView.backgroundColor = UIColor.whiteColor()
        self.titleView.layer.cornerRadius = 2;
        self.titleView.layer.masksToBounds = true
        self.view.addSubview(self.titleView)
        
        self.loginButton = UIButton(type: UIButtonType.System)
        self.loginButton.frame = CGRectMake(5, 10, 30, 30)
        self.loginButton.addTarget(self, action: "loginOrregist", forControlEvents: UIControlEvents.TouchUpInside)
        self.titleView.addSubview(self.loginButton)
        
        self.label = UILabel(frame: CGRectMake(39, 10, 1, 30))
        self.label?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        self.titleView.addSubview(self.label!)
        
        self.expectAddress.frame = CGRectMake(50, 0, 170, 50)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "expectAddressChang", name: UITextFieldTextDidChangeNotification, object: nil)
        self.expectAddress.borderStyle = UITextBorderStyle.None
        self.expectAddress.placeholder = "请输入详细的地址"
        self.expectAddress.delegate = self
        self.titleView.addSubview(self.expectAddress)
        
        self.sureButton = UIButton(type: UIButtonType.System)
        self.sureButton.enabled = false
        self.sureButton.setTitle("确定", forState: UIControlState.Normal)
        self.sureButton.frame = CGRectMake(225, 10, 30, 30)
        self.sureButton .addTarget(self, action: "sureButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.sureButton.enabled = false
        self.titleView.addSubview(self.sureButton)

        self.routePlannButton = UIButton(type: UIButtonType.System)
        self.routePlannButton.setTitle("路线规划", forState: UIControlState.Normal)
        self.routePlannButton.frame = CGRectMake(260, 10, 70, 30)
        self.routePlannButton .addTarget(self, action: "routePlannButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.routePlannButton.enabled = false;
        self.titleView.addSubview(self.routePlannButton)
        
    }
    
    func loginOrregist() {
        if (LO_loginHelper().isLogin()) {
            let alter = UIAlertView(title: "提示", message: "已登录", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alter.show() // 
        } else {
            let nav : UINavigationController = UINavigationController(rootViewController: LO_LoginController())
            self.presentViewController(nav, animated: true) { () -> Void in

            }
        }
    }
    
    //BMKMapView新增viewWillAppear、viewWillDisappear方法来控制BMKMapView的生命周期，并且在一个时刻只能有一个BMKMapView接受回调消息，因此在使用BMKMapView的viewController中需要在viewWillAppear、viewWillDisappear方法中调用BMKMapView的对应的方法，并处理delegat
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        if (!LO_loginHelper().isLogin()) {
            self.loginButton.setImage(UIImage(named:"person") , forState:UIControlState.Normal)
            self.loginButton.setImage(UIImage(named:"person") , forState:UIControlState.Selected)
        } else {
            self.loginButton.setImage(UIImage(named:"person_all") , forState:UIControlState.Normal)
            self.loginButton.setImage(UIImage(named:"person_all") , forState:UIControlState.Selected)
        }
        self.locService?.delegate = self
        self.map?.delegate = self
        self.geo?.delegate = self
        self.routeSearch.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.locService?.delegate = nil
        self.map?.delegate = nil
        self.geo?.delegate = nil
        self.routeSearch.delegate = nil
    }
    
    func expectAddressChang() {
        if self.expectAddress.text == "" {
            self.sureButton.enabled = false
        } else {
            self.sureButton.enabled = true
        }
    }
    
    // 确定按钮的事件
    func sureButtonAction() {
        self.sureButton.enabled = false;
         self.expectAddress.resignFirstResponder()
        if (self.expectAddress.text == nil) {
            print("您输入的位置为空")
            return
        }
        let addressInformation: BMKGeoCodeSearchOption = BMKGeoCodeSearchOption()
        addressInformation.address = self.expectAddress.text
        self.geo?.geoCode(addressInformation)
    }
    
    // 路线规划的事件
    func routePlannButtonAction() {
        if (self.userLocation == nil || self.expectAddress.text == nil) {
            return
        }
        let reverseGeoCodeOption : BMKReverseGeoCodeOption = BMKReverseGeoCodeOption();
        reverseGeoCodeOption.reverseGeoPoint = (self.userLocation?.coordinate)!
       self.geo?.reverseGeoCode(reverseGeoCodeOption)
    }
    //*返回地址信息搜索结果(用户输入转化坐标)
       func onGetGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if result.address == nil {
            let alter = UIAlertView(title: "提示", message: "没有这个位置", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "取消")
            alter .show()
            return;
        }
        self.expectLocation = result.address
        self.sureButton.enabled = true;
        if (error != BMK_SEARCH_NO_ERROR || searcher != self.geo || result == nil) { // 如果没有正常返回结果直接返回
            print("编码错误")
            return;
        }
        self.map?.setCenterCoordinate(result.location, animated: true)
        // 移除地图上添加的标注
        self.map?.removeAnnotations(self.map?.annotations)
        let annotation = LO_Annotation()
        annotation.coordinate = result.location
        annotation.pointImage = UIImage(named: "exAddress")
        annotation.title = result.address
        self.map?.addAnnotation(annotation)
    }
    
    /*返回反地理编码搜索结果*/
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        let from = BMKPlanNode()
        from.name = result.addressDetail.district + result.addressDetail.streetName;
        from.name = "上地三街"
        from.cityName = result.addressDetail.city
        let to = BMKPlanNode()
        // 终点
        to.name = self.expectAddress.text!;
        to.name = "清河中街"
        to.cityName = result.addressDetail.city
        let transitRouteSearchOption = BMKTransitRoutePlanOption()
        transitRouteSearchOption.city = result.addressDetail.city
        transitRouteSearchOption.from = from
        transitRouteSearchOption.to = to
        
        print("frame = \(from.name)  to = \(to.name)")
        // 发起公交检索
        let flag = routeSearch.transitSearch(transitRouteSearchOption)
        if flag {
            print("公交检索发送成功")
        }else {
            print("公交检索发送失败")
        }
    }
    // 
    /***返回公交搜索结果*/
    func onGetTransitRouteResult(searcher: BMKRouteSearch!, result: BMKTransitRouteResult!, errorCode error: BMKSearchErrorCode) {
        print("onGetTransitRouteResult: \(error)")
        if error != BMK_SEARCH_NO_ERROR {
            print("%d",error)
            let alter = UIAlertView(title: "提示", message: "\(error)", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "取消")
            alter .show()
        }
        self.map!.removeAnnotations(self.map!.annotations)
        self.map!.removeOverlays(self.map!.overlays)
        if error == BMK_SEARCH_NO_ERROR {
            let plan = result.routes[0] as! BMKTransitRouteLine
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                let transitStep = plan.steps[i] as! BMKTransitStep
                if i == 0 {
                    let item = LO_RouteAnnotation()
                    item.coordinate = plan.starting.location
                    item.title = "起点"
                    item.type = 0
                    self.map!.addAnnotation(item)  // 添加起点标注
                }else if i == size - 1 {
                    let item = LO_RouteAnnotation()
                    item.coordinate = plan.terminal.location
                    item.title = "终点"
                    item.type = 1
                    self.map!.addAnnotation(item)  // 添加终点标注
                }
                let item = LO_RouteAnnotation()
                item.coordinate = transitStep.entrace.location
                item.title = transitStep.instruction
                item.type = 3
                self.map!.addAnnotation(item)
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            // 轨迹点
            var tempPoints = Array(count: planPointCounts, repeatedValue: BMKMapPoint(x: 0, y: 0))
            var i = 0
            for j in 0..<size {
                let transitStep = plan.steps[j] as! BMKTransitStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i++
                }
            }
            // 通过 points 构建 BMKPolyline
            let polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
            // 添加路线 overlay
            self.map!.addOverlay(polyLine)
            mapViewFitPolyLine(polyLine)
        }
    }
    
    // 添加覆盖物
    func mapView(mapView: BMKMapView!, viewForOverlay overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay as! BMKPolyline? != nil {
            let polylineView = BMKPolylineView(overlay: overlay as! BMKPolyline)
            polylineView.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.7)
            polylineView.lineWidth = 3
            return polylineView
        }
        return nil
    }
    //根据polyline设置地图范围
    func mapViewFitPolyLine(polyline: BMKPolyline!) {
        if polyline.pointCount < 1 {
            return
        }
        let pt = polyline.points[0]
        var ltX = pt.x
        var rbX = pt.x
        var ltY = pt.y
        var rbY = pt.y
        
        for i in 1..<polyline.pointCount {
            let pt = polyline.points[Int(i)]
            if pt.x < ltX {
                ltX = pt.x
            }
            if pt.x > rbX {
                rbX = pt.x
            }
            if pt.y > ltY {
                ltY = pt.y
            }
            if pt.y < rbY {
                rbY = pt.y
            }
        }
        
        let rect = BMKMapRectMake(ltX, ltY, rbX - ltX, rbY - ltY)
        self.map!.visibleMapRect = rect
        self.map!.zoomLevel = self.map!.zoomLevel - 0.3
    }

    
    // 添加大头针的代理
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation is LO_RouteAnnotation {
            if let routeAnnotation = annotation as! LO_RouteAnnotation? {
                return getViewForRouteAnnotation(routeAnnotation)
            }
        }
        if annotation is BMKUserLocation {
            self.routePlannButton.enabled = false
            return nil;
        }
        let AnnotationViewID = "renameMark"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(AnnotationViewID) as! BMKPinAnnotationView?
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
        }
        annotationView?.annotation = annotation
        let lo_annotation = annotation as! LO_Annotation
        annotationView?.image = lo_annotation.pointImage
        annotationView?.canShowCallout = true
        self.routePlannButton.enabled = true;
        return annotationView
    }
    
    // 
    func getViewForRouteAnnotation(routeAnnotation: LO_RouteAnnotation!) -> BMKAnnotationView? {
        var view: BMKAnnotationView?
        
        let imageName = "nav_bus"
        let identifier = "\(imageName)_annotation"
        view = self.map!.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if view == nil {
            view = BMKAnnotationView(annotation: routeAnnotation, reuseIdentifier: identifier)
            view?.centerOffset = CGPointMake(0, -(view!.frame.size.height * 0.5))
            view?.canShowCallout = true
        }
        view?.annotation = routeAnnotation
        let bundlePath = NSBundle.mainBundle().resourcePath?.stringByAppendingString("/mapapi.bundle/")
        let bundle = NSBundle(path: bundlePath!)
        if let imagePath = bundle?.resourcePath?.stringByAppendingString("/images/icon_\(imageName).png") {
            let image = UIImage(contentsOfFile: imagePath)
            if image != nil {
                view?.image = image
            }
        }
        return view
    }

    
    // 用户位置更新
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        self.userLocation = userLocation.location;
        self.map?.updateLocationData(userLocation)
        // 设置用户位置为地图的中心点
        self.map?.setCenterCoordinate(userLocation.location.coordinate, animated: true)
    }
    
    // 定位失败
    func didFailToLocateUserWithError(error: NSError!) {
        print("定位失败")
    }
    
    // 大头针的点击事件
    func mapView(mapView: BMKMapView!, didSelectAnnotationView view: BMKAnnotationView!) {
        self.map?.setCenterCoordinate(view.annotation.coordinate, animated: true);
    }
    
    // 控制键盘回收
    func mapView(mapView: BMKMapView!, regionWillChangeAnimated animated: Bool) {
        self.expectAddress.resignFirstResponder()
    }
    
    func mapView(mapView: BMKMapView!, onClickedBMKOverlayView overlayView: BMKOverlayView!) {
        self.expectAddress.resignFirstResponder()
    }
    
    func mapview(mapView: BMKMapView!, onDoubleClick coordinate: CLLocationCoordinate2D) {
        self.expectAddress.resignFirstResponder()
    }
    
    func mapview(mapView: BMKMapView!, onLongClick coordinate: CLLocationCoordinate2D) {
        self.expectAddress.resignFirstResponder()
    }
    func mapView(mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        self.expectAddress.resignFirstResponder()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.expectAddress.resignFirstResponder()
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            self.expectAddress.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.expectAddress.resignFirstResponder()
        return true
    }
}





