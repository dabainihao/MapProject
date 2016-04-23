//
//  LO_Login.swift
//  MapProject
//
//  Created by 杨少锋 on 16/4/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  登陆界面

import UIKit

class LO_LoginController: UIViewController,UIAlertViewDelegate {

    weak var userNameTextField : UITextField?
    weak var passWorldTextField : UITextField?
    weak var loginButton : UIButton?
    weak var registButton : UIButton?
    weak var forgetButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登陆"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = true;
        // 设置返回按钮
        let barButton : UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "backAction")
        self.navigationItem.leftBarButtonItem =  barButton
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "usrNameChang", name: UITextFieldTextDidChangeNotification, object: nil)
        let userName = UITextField(frame: CGRectMake(30,90 , self.view.bounds.size.width - 60, 40))
        userName.placeholder = "请输入电话,邮箱或者用户名"
        self.view .addSubview(userName)
        userName.layer.borderColor = UIColor.grayColor().CGColor
        userName.layer.borderWidth = 1;
        userName.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.userNameTextField = userName
        
        let passWorld = UITextField(frame: CGRectMake(30 , 140 , self.view.bounds.size.width - 60, 40))
        passWorld.placeholder = "请输入密码"
        self.view .addSubview(passWorld)
        passWorld.layer.borderColor = UIColor.grayColor().CGColor
        passWorld.layer.borderWidth = 1;
        passWorld.clearButtonMode = UITextFieldViewMode.WhileEditing
        passWorld.secureTextEntry = true
        self.passWorldTextField = passWorld
        
        let loginButton = UIButton(type: UIButtonType.System)
        loginButton.frame = CGRectMake(30, 190, self.view.bounds.size.width - 60, 40)
        loginButton.setTitle("登陆", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "loginAction", forControlEvents: UIControlEvents.TouchUpInside)
        loginButton .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.backgroundColor = UIColor.grayColor()
        loginButton.enabled = false
        self.view.addSubview(loginButton)
        self.loginButton = loginButton
        
        let registButton = UIButton(type: UIButtonType.System)
        registButton.frame = CGRectMake(30, 240, 80, 40)
        registButton.setTitle("注册", forState: UIControlState.Normal)
        registButton.addTarget(self, action: "registAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view .addSubview(registButton)
        registButton.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.registButton = registButton
        
        let forgetButton = UIButton(type: UIButtonType.System)
        forgetButton.frame = CGRectMake(260, 240, 80, 40)
        forgetButton.titleLabel?.font = UIFont.systemFontOfSize(10)
        forgetButton.setTitle("忘记密码", forState: UIControlState.Normal)
        forgetButton.addTarget(self, action: "forgetButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view .addSubview(forgetButton)
        self.forgetButton = forgetButton
    }

    func usrNameChang() {
        if self.userNameTextField?.text != "" && self.passWorldTextField?.text != "" {
            self.loginButton?.enabled = true
            self.loginButton?.backgroundColor = UIColor.brownColor()
        } else  {
            self.loginButton?.enabled = false
            self.loginButton?.backgroundColor = UIColor.grayColor()
        }
    }
    
    // 登陆
    func loginAction() {
        LO_loginHelper().loginWithInformation((self.userNameTextField?.text)!, passWorld: (self.passWorldTextField?.text)!, success: { (user) -> Void in
            // print(user?.mobilePhoneNumber)
            let alterView = UIAlertView(title: "温馨提示", message: "登录成功", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alterView .show()
            }) { (err) -> Void in
               print(err)
                let alterView = UIAlertView(title: "温馨提示", message: "登陆失败", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alterView .show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 注册
    func registAction() {
        self.navigationController?.pushViewController(LO_RegistViewController(), animated: true)
    }
    
    // 忘记密码
    func forgetButtonAction() {
       self.navigationController?.pushViewController(LO_ForgetPassWorldViewController(), animated: true)
    }
    // 返回
    func backAction() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
