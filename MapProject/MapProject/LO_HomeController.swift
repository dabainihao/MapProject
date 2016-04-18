//
//  LO_LoginViewController.swift
//  MapProject
//
//  Created by 杨少锋 on 16/4/17.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  个人中心

import UIKit

class LO_HomeController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    weak var loginButton : UIButton?
    weak var tableView : UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = AVUser.currentUser()
        if user != nil {
            if self.loginButton != nil {
                self.loginButton?.removeFromSuperview()
            }
            let table = UITableView(frame: CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 10))
            self.view .addSubview(table)
            self.tableView = table
            self.tableView?.delegate = self;
            self.tableView?.dataSource = self;
            self
        } else {    //未登录
            if self.tableView != nil {
                self.tableView?.removeFromSuperview()
            }
            let button = UIButton(type: UIButtonType.System)
            button.frame = CGRectMake(80, 100, 200, 50);
            button .setTitle("登陆/注册", forState: UIControlState.Normal)
            button.backgroundColor = UIColor.blueColor()
            button.addTarget(self, action: "loginOrRegist", forControlEvents: UIControlEvents.TouchUpInside)
            self.view .addSubview(button)
        }
    }
    
    // 注册或者登陆
    func loginOrRegist() {
        self.presentViewController(LO_LoginController(), animated: true) { () -> Void in
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
