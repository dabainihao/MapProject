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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.loginButton != nil {
            self.loginButton?.removeFromSuperview()
        }
        if self.tableView != nil {
            self.tableView?.removeFromSuperview()
        }
        if (LO_loginHelper().isLogin()) {
            let table = UITableView(frame: CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 10))
            self.view .addSubview(table)
            self.tableView = table
            self.tableView?.delegate = self;
            self.tableView?.dataSource = self;
        } else {
            let button = UIButton(type: UIButtonType.System)
            button.frame = CGRectMake(80, 100, 200, 50);
            button .setTitle("登陆/注册", forState: UIControlState.Normal)
            button.backgroundColor = UIColor.blueColor()
            button.addTarget(self, action: "loginOrRegist", forControlEvents: UIControlEvents.TouchUpInside)
            self.view .addSubview(button)
            self.loginButton = button;
        }
    }
    
    // 注册或者登陆
    func loginOrRegist() {
        let nav : UINavigationController = UINavigationController(rootViewController: LO_LoginController())
        self.presentViewController(nav, animated: true) { () -> Void in
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "1")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        switch indexPath.row {
        case 0 :
            cell.textLabel?.text = "用户名"
            cell.detailTextLabel?.text = LO_loginHelper().getUserName();
        case 1 :
            cell.textLabel?.text = "电话"
            cell.detailTextLabel?.text = LO_loginHelper().getPhone();
        case 2 :
            cell.textLabel?.text = "email"
            cell.detailTextLabel?.text = LO_loginHelper().getEmail();
        case 3 :
            cell.textLabel?.text = "退出登录"
            cell.accessoryType = UITableViewCellAccessoryType.None
        default :
            print("未知")
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0 :
            print(1)
        case 1 :
            print(1)
        case 2 :
            print(2)
        case 3 :
            print(3)
        default :
            print("未知")
        }
    }
    
    
}
