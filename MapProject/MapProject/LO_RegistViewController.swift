//
//  LO_RegistViewController.swift
//  MapProject
//
//  Created by 杨少锋 on 16/4/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  注册

import UIKit

class LO_RegistViewController: UIViewController,UIAlertViewDelegate {

    weak var userNameTextField : UITextField!
    weak var passWorldTextField : UITextField!
    weak var registButton : UIButton?
    weak var secondsButton : UIButton?
    var buttonCurrentTime :Int?
    var timer : NSTimer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let userName = UITextField(frame: CGRectMake(30,70 , self.view.bounds.size.width - 60, 40))
        userName.placeholder = "请输入手机号"
        self.view .addSubview(userName)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "usrNameChang", name: UITextFieldTextDidChangeNotification, object: nil)
        userName.layer.borderColor = UIColor.blueColor().CGColor
        userName.layer.borderWidth = 1;
        userName.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.userNameTextField = userName
        
        let passWorld = UITextField(frame: CGRectMake(30 , 120 , self.view.bounds.size.width - 200, 40))
        passWorld.placeholder = "请输入验证码"
        self.view .addSubview(passWorld)
        passWorld.layer.borderColor = UIColor.blueColor().CGColor
        passWorld.layer.borderWidth = 1;
        passWorld.clearButtonMode = UITextFieldViewMode.WhileEditing
//        passWorld.secureTextEntry = true
        self.passWorldTextField = passWorld
        
        let btn = UIButton(type: UIButtonType.System)
        btn.frame = CGRectMake(250, 120, 90, 40)
        btn.enabled = false
        btn.setTitle("发送验证码", forState: UIControlState.Normal)
        btn.addTarget(self, action: "sendVerificationCode:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view .addSubview(btn)
        btn.layer.borderColor = UIColor.blueColor().CGColor
        btn.layer.borderWidth = 1;
        self.secondsButton = btn
        
        let registButton = UIButton(type: UIButtonType.System)
        registButton.frame = CGRectMake(30, 170, self.view.bounds.size.width - 60, 40)
        registButton.setTitle("注册", forState: UIControlState.Normal)
        registButton.addTarget(self, action: "registAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view .addSubview(registButton)
        registButton.layer.borderColor = UIColor.blueColor().CGColor
        registButton.layer.borderWidth = 1;
        self.registButton = registButton
    }
    
    // 发送验证码
    func sendVerificationCode(btn:UIButton) {
        self.buttonCurrentTime = 60;
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "ButtonTimer", userInfo: nil, repeats: true)
//        NSRunLoop.currentRunLoop() .addTimer(self.timer!, forMode: NSDefaultRunLoopMode)
        LO_loginHelper.sendMessageCode(self.userNameTextField.text!) { (reslut) -> Void in
            if reslut is NSError {  // 发送验证码错误
                self.timer?.invalidate()
                self.timer = nil
                if reslut.code == 601 {
                    self.secondsButton?.setTitle("稍后发送", forState: UIControlState.Normal)
                    self.secondsButton?.enabled = true
                    return
                }
                self.secondsButton?.enabled = true
                self.secondsButton?.setTitle("重新发送", forState: UIControlState.Normal)
                return
            }
            
        }
    }
    
    // 时间改变
    func ButtonTimer() {
        self.buttonCurrentTime = self.buttonCurrentTime! - 1
        self.secondsButton?.setTitle(String(self.buttonCurrentTime!) + "s", forState: UIControlState.Normal)
        if self.buttonCurrentTime == 0 {
            self.secondsButton?.setTitle("重新发送", forState: UIControlState.Normal)
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    // 电话号码发生改变
    func usrNameChang() {
        var isClick = false
        if self.passWorldTextField.text != nil {
        isClick = LO_loginHelper().isPhoneNumber(self.userNameTextField.text!)
        }
        print(isClick)
        if isClick {
            self.secondsButton?.enabled = true
        } else {
            self.secondsButton?.enabled = false
        }
    }
    
    // 注册
    func registAction() {
        if self.userNameTextField.text == nil || self.passWorldTextField.text == nil {
            return
        }
       LO_loginHelper.loginUpWithcode(self.userNameTextField.text!, code: self.passWorldTextField.text!) { (result) -> Void in
        if result is NSError {  // 注册失败
            print("注册失败")
            let alterView : UIAlertView = UIAlertView(title: "温馨提示", message: result.domain!, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alterView.show()
            return;
        }
        self.navigationController?.pushViewController(LO_AddPassworldVC(), animated: true)
//       // print("注册成功")
//        let alterView : UIAlertView = UIAlertView(title: "温馨提示", message: "注册成功", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
//        alterView.show()
//        //self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

class LO_AddPassworldVC: UIViewController,UIAlertViewDelegate {
    weak var passWorldTextField : UITextField!
    weak var secondsButton  : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let passWorld = UITextField(frame: CGRectMake(30 , 120 , self.view.bounds.size.width - 200, 40))
        passWorld.placeholder = "密码"
        self.view .addSubview(passWorld)
        passWorld.layer.borderColor = UIColor.blueColor().CGColor
        passWorld.layer.borderWidth = 1;
        passWorld.clearButtonMode = UITextFieldViewMode.WhileEditing
        passWorld.secureTextEntry = true
        self.passWorldTextField = passWorld
        
        let btn = UIButton(type: UIButtonType.System)
        btn.frame = CGRectMake(250, 120, 90, 40)
        btn.setTitle("确认", forState: UIControlState.Normal)
        btn.addTarget(self, action: "sendVerificationCode", forControlEvents: UIControlEvents.TouchUpInside)
        self.view .addSubview(btn)
        btn.layer.borderColor = UIColor.blueColor().CGColor
        btn.layer.borderWidth = 1;
        self.secondsButton = btn
    }
    
    func sendVerificationCode()->Void {
      let user =  AVUser.currentUser()
        user.password = self.passWorldTextField.text
        user.saveInBackgroundWithBlock { (result, err) -> Void in
            if err == nil {
                let alterView : UIAlertView = UIAlertView(title: "温馨提示", message: "注册成功", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alterView.show()
            }
        };
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}



