//
//  LO_Login.swift
//  MapProject
//
//  Created by 杨少锋 on 16/4/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  登陆界面

import UIKit

class LO_LoginController: UIViewController {

    weak var userNameTextField : UITextField?
    weak var passWorldTextField : UITextField?
    weak var loginButton : UIButton?
    weak var registButton : UIButton?
    weak var forgetButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 设置返回按钮
        let barButton : UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "backAction")
        self.navigationItem.leftBarButtonItem =  barButton
        
        let userName = UITextField(frame: CGRectMake(30,70 , self.view.bounds.size.width - 60, 40))
        userName.placeholder = "请输入电话,邮箱或者用户名"
        self.view .addSubview(userName)
        userName.layer.borderColor = UIColor.blueColor().CGColor
        userName.layer.borderWidth = 1;
        userName.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.userNameTextField = userName
        
        let passWorld = UITextField(frame: CGRectMake(30 , 120 , self.view.bounds.size.width - 60, 40))
        passWorld.placeholder = "请输入密码"
        self.view .addSubview(passWorld)
        passWorld.layer.borderColor = UIColor.blueColor().CGColor
        passWorld.layer.borderWidth = 1;
        passWorld.clearButtonMode = UITextFieldViewMode.WhileEditing
        passWorld.secureTextEntry = true
        self.passWorldTextField = passWorld
        
        let loginButton = UIButton(type: UIButtonType.System)
        loginButton.frame = CGRectMake(30, 170, self.view.bounds.size.width - 60, 40)
        loginButton.setTitle("登陆", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "loginAction", forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.backgroundColor = UIColor.blueColor()
        self.view.addSubview(loginButton)
        self.loginButton = loginButton
        
        let registButton = UIButton(type: UIButtonType.System)
        registButton.frame = CGRectMake(30, 220, 80, 40)
        registButton.setTitle("注册", forState: UIControlState.Normal)
        registButton.addTarget(self, action: "registAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view .addSubview(registButton)
        registButton.layer.borderColor = UIColor.blueColor().CGColor
        registButton.layer.borderWidth = 1;
        self.registButton = registButton
        
        let forgetButton = UIButton(type: UIButtonType.System)
        forgetButton.frame = CGRectMake(260, 220, 80, 40)
        forgetButton.layer.borderColor = UIColor.blueColor().CGColor
        forgetButton.layer.borderWidth = 1;
        forgetButton.setTitle("忘记密码", forState: UIControlState.Normal)
        forgetButton.addTarget(self, action: "forgetButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view .addSubview(forgetButton)
        self.forgetButton = forgetButton
    }

    // 登陆
    func loginAction() {
        LO_loginHelper().loginWithInformation((self.userNameTextField?.text)!, passWorld: (self.passWorldTextField?.text)!, success: { (user) -> Void in
            
            }) { (err) -> Void in
                
        }
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
