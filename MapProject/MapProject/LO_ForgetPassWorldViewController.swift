//
//  LO_ForgetPassWorldViewController.swift
//  MapProject
//
//  Created by 杨少锋 on 16/4/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  忘记密码

import UIKit

class LO_ForgetPassWorldViewController: UIViewController,UIAlertViewDelegate {

        weak var userNameTextField : UITextField!
        weak var passWorldTextField : UITextField!
        weak var registButton : UIButton?
        weak var secondsButton : UIButton?
        weak var newPassworldTextField : UITextField!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.whiteColor()
        let userName = UITextField(frame: CGRectMake(30,70 , self.view.bounds.size.width - 60, 40))
        userName.placeholder = "请输入手机号"
        self.view .addSubview(userName)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "usrNameChang", name: UITextFieldTextDidChangeNotification, object: nil)
        userName.layer.borderColor = UIColor.grayColor().CGColor
        userName.layer.borderWidth = 1;
        userName.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.userNameTextField = userName
        
        let newPs = UITextField(frame: CGRectMake(30, 170 , self.view.bounds.size.width - 60, 40))
        newPs.placeholder = "重置的密码"
        self.view .addSubview(newPs)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pwChang", name: UITextFieldTextDidChangeNotification, object: nil)
        newPs.layer.borderColor = UIColor.grayColor().CGColor
        newPs.layer.borderWidth = 1;
        newPs.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.newPassworldTextField = newPs
            
        let passWorld = UITextField(frame: CGRectMake(30 , 120 , self.view.bounds.size.width - 200, 40))
        passWorld.placeholder = "请输入验证码"
        self.view .addSubview(passWorld)
        passWorld.layer.borderColor = UIColor.grayColor().CGColor
        passWorld.layer.borderWidth = 1;
        passWorld.clearButtonMode = UITextFieldViewMode.WhileEditing
        //        passWorld.secureTextEntry = true
        self.passWorldTextField = passWorld
        
        let btn = UIButton(type: UIButtonType.System)
        btn.frame = CGRectMake(250, 120, 90, 40)
        btn.enabled = false
        btn.setTitle("发送验证码", forState: UIControlState.Normal)
        btn.addTarget(self, action: "sendVerificationCode", forControlEvents: UIControlEvents.TouchUpInside)
        self.view .addSubview(btn)
        btn.layer.borderColor = UIColor.grayColor().CGColor
        btn.layer.borderWidth = 1;
        self.secondsButton = btn
        
        let registButton = UIButton(type: UIButtonType.System)
        registButton.frame = CGRectMake(30, 220, self.view.bounds.size.width - 60, 40)
        registButton.setTitle("重置密码", forState: UIControlState.Normal)
        registButton.addTarget(self, action: "registAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view .addSubview(registButton)
        registButton.layer.borderColor = UIColor.grayColor().CGColor
        registButton.enabled = false
        registButton.layer.borderWidth = 1;
        self.registButton = registButton
    }
    
    // 发送验证码
    func sendVerificationCode() {
        self.secondsButton?.setTitle("已发送", forState: UIControlState.Normal)
        LO_loginHelper.registSMSCod(self.userNameTextField.text!) { (infor) -> Void in
            if infor is NSError {
                self.secondsButton?.setTitle("重新发送", forState: UIControlState.Normal)
            }
            print(infor)
        }
    }
    
    // 重置
    func registAction() {
        LO_loginHelper.resetPW(self.passWorldTextField.text!, newPW: self.userNameTextField.text!) {(infor) -> Void in
            let view : UIAlertView = UIAlertView(title: "提示", message: "重置成功", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            view .show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // 电话发生改变
    func usrNameChang() {
        if self.userNameTextField.text == nil {
            return
        }
        if LO_loginHelper().isPhoneNumber(self.userNameTextField.text!) {
            self.secondsButton?.enabled = true
        } else {
            self.secondsButton?.enabled = false
        }
    }
    
    // 密码
    func pwChang() {
        if self.newPassworldTextField.text == nil {
            return
        }
        if LO_loginHelper().passWorld(self.newPassworldTextField.text!) {
            self.registButton?.enabled = true
        } else {
            self.registButton?.enabled = false
        }
    }
}












