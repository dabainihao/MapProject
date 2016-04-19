//
//  LO_LoginViewController.swift
//  MapProject
//
//  Created by 杨少锋 on 16/4/17.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  个人中心

import UIKit

class LO_HomeController: UIViewController,UITableViewDelegate,UITableViewDataSource,updateInformationDelegate {
    
    weak var loginButton : UIButton?
    weak var tableView : UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户中心"
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = true
        super.viewWillAppear(animated)
        if (LO_loginHelper().isLogin()) {   //登录时
        self.showLoingView()
        } else {
        self.showLoginOutView()
        }
    }
    
    // 显示登录时的界面
    func showLoingView() {
        if self.loginButton != nil {
            self.loginButton?.removeFromSuperview()
        }
        if self.tableView != nil {
            self.tableView?.removeFromSuperview()
            self.tableView?.delegate = nil
            self.tableView?.dataSource = nil
        }
        let table = UITableView(frame: CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 10))
        self.view .addSubview(table)
        self.tableView = table
        self.tableView?.delegate = self;
        self.tableView?.dataSource = self;
    }
    
    // 显示未登录时候的界面
    func showLoginOutView() {
        if self.loginButton != nil {
            self.loginButton?.removeFromSuperview()
        }
        if self.tableView != nil {
            self.tableView?.removeFromSuperview()
            self.tableView?.delegate = nil
            self.tableView?.dataSource = nil
        }
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(80, 100, 200, 50);
        button .setTitle("登陆/注册", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.blueColor()
        button.addTarget(self, action: "loginOrRegist", forControlEvents: UIControlEvents.TouchUpInside)
        self.view .addSubview(button)
        self.loginButton = button;
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
        let updateVC : UpdateInformation = UpdateInformation()
        updateVC.delegate = self
        switch indexPath.row {
        case 3 :
            updateVC.delegate = nil
            LO_loginHelper().loginOut()
            self .showLoginOutView()
            return
        case 0 :
            updateVC.navTitle = "用户名"
            updateVC.textFieldString = LO_loginHelper().getUserName()
        case 1 :
            updateVC.navTitle = "电话"
            updateVC.textFieldString = LO_loginHelper().getPhone();
        case 2 :
            updateVC.navTitle = "email"
            updateVC.textFieldString = LO_loginHelper().getEmail();
        default :
            print("未知")
        }
        //self.presentViewController(updateVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(updateVC, animated: true)
    }
}

//暂时没有使用 修改数据回调使用, 但是AVUser提供了一种类似NSUsrDefalut一样的工程
@objc protocol updateInformationDelegate {
    optional func sendInforMation(infor: AnyObject)->Void
}

// 修改用户名邮箱等
class UpdateInformation:UIViewController {
    var delegate: updateInformationDelegate? = nil
    var navTitle : String?
    var textFieldString : String?
    var nameTextField : UITextField?
    var saveButton : UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.title = self.navTitle
        self.nameTextField = UITextField(frame: CGRectMake(50, 100, self.view.bounds.size.width - 100,50))
        self.nameTextField?.text = textFieldString
        self.nameTextField?.borderStyle = UITextBorderStyle.Bezel
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldChang", name: UITextFieldTextDidChangeNotification, object: nil)
        self.view.addSubview(self.nameTextField!)
        
        self.saveButton = UIButton(type: UIButtonType.System)
        self.saveButton?.enabled = false
        self.saveButton?.frame = CGRectMake(50, 170, self.view.bounds.size.width - 100,50)
        self.saveButton?.setTitle("保存", forState: UIControlState.Normal)
        self.saveButton?.backgroundColor = UIColor.blueColor()
        self.saveButton?.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.saveButton!)
    }
    
    //
    func textFieldChang() {
        if (self.nameTextField?.text != self.textFieldString) {
            self.saveButton?.enabled = true
        } else {
            self.saveButton?.enabled = false
        }
    }
    
    // 保存
    func save() {
        weak var wealself : UpdateInformation! = self
        let mb: MBProgressHUD = MBProgressHUD(view: self.view)
        mb.labelText = "保存中"
        mb.labelColor = UIColor.grayColor()
        mb.show(true)
        if self.navTitle == "用户名" {
            AVUser.currentUser().setObject(self.nameTextField?.text, forKey: "username")
            AVUser.currentUser().saveInBackgroundWithBlock({ (sucess, Err) -> Void in
                if (Err != nil) {
                    mb.labelText = "更新失败"
                    mb.hide(true)
                }
                if sucess {
                    mb.labelText = "保存完成"
                    mb.hide(true)
                    wealself.navigationController?.popToRootViewControllerAnimated(true)
                }
                
            })
        }
        if self.navTitle == "邮箱" {
            AVUser.currentUser().setObject(self.nameTextField?.text, forKey: "email")
            AVUser.currentUser().saveInBackgroundWithBlock({ (sucess, Err) -> Void in
                if (Err != nil) {
                    mb.labelText = "更新失败"
                    mb.hide(true)
                }
                if sucess {
                    mb.labelText = "保存完成"
                    mb.hide(true)
                    wealself.navigationController?.popToRootViewControllerAnimated(true)
                }
                
            })
        }
        if self.navTitle == "电话" {
            AVUser.currentUser().setObject(self.nameTextField?.text, forKey: "mobilePhoneNumber")
            AVUser.currentUser().saveInBackgroundWithBlock({ (sucess, Err) -> Void in
                if (Err != nil) {
                    mb.labelText = "更新失败"
                    mb.hide(true)
                }
                if sucess {
                    mb.labelText = "保存完成"
                    mb.hide(true)
                    wealself.navigationController?.popToRootViewControllerAnimated(true)
                    
                }
            })
        }
    }
}


class LO_Infor: NSObject {
   var index : NSIndexPath?
    var usrDate : String?
}









