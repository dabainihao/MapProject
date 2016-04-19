//
//  LO_loginHelper.swift
//  MapProject
//
//  Created by 杨少锋 on 16/4/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  负责登陆,注册,验证邮箱,电话号码,等

// 

import UIKit

enum UserNameType {
    case userName
    case email
    case mobilePhoneNumber
    case error
}

// 用户类
class LO_user: NSObject {
    var userName:String?
    var email : String?
    var mobilePhoneNumber : String?
}
// 负责登陆,注册,验证邮箱,电话号码,等
class LO_loginHelper: NSObject {
    // 验证是否登陆
    func isLogin()->Bool {
      let str = NSUserDefaults.standardUserDefaults().objectForKey("siLogin");
        return str == nil ?  false : true
    }
    
    // 退出登录
    func loginOut() {
        AVUser.logOut()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("siLogin")
    }
    
    // 返回邮箱
    func getEmail()->String {
        let user = AVUser.currentUser()
        if user.email != nil {
           return user.email
        }
        return "绑定邮箱"
    }
    
    // 返回电话
    func getPhone()->String {
        let user = AVUser.currentUser()
        return user.mobilePhoneNumber != nil ? user.mobilePhoneNumber : "绑定电话"
        
    }
    
    // 返回用户名
    func getUserName()->String {
        let user = AVUser.currentUser()
        return user.username != nil ? user.username : "初始化用户名"
    }
    
    // 登陆
    func loginWithInformation(userName: String, passWorld: String, success:(user:LO_user?)->Void, faile:(err:NSError?)->Void) {
        // 先判断用户输入的用户名是邮箱还是电话, 还是用户名
       let isOK = self.passWorld(passWorld)
        if !isOK {
            print("密码不正确")
            return;
        }
      let type = self .userNameType(userName)
        switch type {
        case .userName :    // 使用用户名登陆
            print("用户名登陆")
            AVUser.logInWithUsernameInBackground(userName, password: passWorld, block: { (userInfor, err) -> Void in
                if err != nil || userInfor == nil {
                    print("用户名登陆失败")
                    return
                }
                let us : LO_user = LO_user()
                us.userName = userInfor.username != nil ? userInfor.username : "请输入用户名"
                us.mobilePhoneNumber = userInfor.mobilePhoneNumber != nil ? userInfor.mobilePhoneNumber : "绑定手机"
                us.email = userInfor.mobilePhoneNumber != nil ? userInfor.email : "绑定邮箱"
                NSUserDefaults.standardUserDefaults().setObject("login", forKey:("siLogin"))
                success(user: us)
            })
        case .email :
            //
            print("email登陆")
        case .mobilePhoneNumber :
            print("手机号登陆")
            AVUser.logInWithMobilePhoneNumberInBackground(userName, password: passWorld, block: { (userInfor, err) -> Void in
                if err != nil || userInfor == nil {
                    print("手机号登陆失败")
                    faile(err: err)
                    return
                }
                let us : LO_user = LO_user()
                us.userName = userInfor.username != nil ? userInfor.username : "请输入用户名"
                us.mobilePhoneNumber = userInfor.mobilePhoneNumber != nil ? userInfor.mobilePhoneNumber : "绑定手机"
                us.email = userInfor.mobilePhoneNumber != nil ? userInfor.email : "绑定邮箱"
                NSUserDefaults.standardUserDefaults().setObject("login", forKey:("siLogin"))
                success(user: us)
            })
        case .error :
            print("错误登陆")
        }
    }
    
    // 注册(暂时没用)
    func registWithInformation(emailOrPhone: String, passWorld: String, successed:(user:LO_user?)->Void, faile:(err:NSError?)->Void) {
        let isOK = self.passWorld(passWorld)
        if !isOK {
            print("密码不正确")
            return;
        }
        let type = self.userNameType(emailOrPhone)
        switch type {
        case .mobilePhoneNumber :
            let usr = AVUser()
            usr.mobilePhoneNumber = emailOrPhone;
            usr.username = emailOrPhone
            usr.password = passWorld
            usr.signUpInBackgroundWithBlock({ (success, err) -> Void in
                if (success) {
                    print("登陆成功")
                    let currentUser = LO_user()
                    currentUser.userName = AVUser.currentUser().username
                    currentUser.email = AVUser.currentUser().email
                    currentUser.mobilePhoneNumber = AVUser.currentUser().mobilePhoneNumber
                    successed(user: currentUser)
                    NSUserDefaults.standardUserDefaults().setObject("login", forKey:("siLogin"))
                    return
                }
                if (err != nil) {
                    faile(err: err)
                    return
                }
            })
        case .email :
            print("邮箱")
            let usr = AVUser()
            usr.email = emailOrPhone;
            usr.username = emailOrPhone
            usr.password = passWorld
            usr.signUpInBackgroundWithBlock({ (success, err) -> Void in
                if (success) {
                    print("登陆成功")
                    let currentUser = LO_user()
                    currentUser.userName = AVUser.currentUser().username
                    currentUser.email = AVUser.currentUser().email
                    currentUser.mobilePhoneNumber = AVUser.currentUser().mobilePhoneNumber
                    successed(user: currentUser)
                    NSUserDefaults.standardUserDefaults().setObject("login", forKey:("siLogin"))
                    return
                }
                if (err != nil) {
                    faile(err: err)
                    return
                }
            })
        case .userName :
            print("用户名")
            
        case .error :
            print("错误的")
        }
    }
    
    
    // 判断用户名是手机号, 还是邮箱, 还是用户名
    func userNameType(username: String)->UserNameType {
        let patternTel: String = "^1[3,5,8,7][0-9]{9}$"
        var matcher: RegexHelper
        do {
            matcher = try! RegexHelper(patternTel)
        }
        if matcher.match(username) {
            return UserNameType.mobilePhoneNumber
        }
        
        let mailPattern =
        "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        do {
            matcher = try! RegexHelper(mailPattern)
        }
        if matcher.match(username) {
            return UserNameType.email
        }
        
        let patternUserName : String = "^[A-Za-z0-9_]{6,20}+$"
        do {
            matcher = try! RegexHelper(patternUserName)
        }
        if matcher.match(username) {
            return UserNameType.userName
        }
        return UserNameType.error
    }
    
    // 判断密码是不是在6-20位
    func passWorld(passwd : String)->Bool {
        let patternTel: String = "^[a-zA-Z0-9.]{6,20}+$"
        var matcher: RegexHelper
        do {
            matcher = try! RegexHelper(patternTel)
        }
        if matcher.match(passwd) {
            return true
        } else {
            return false
        }
    }
    // 判断是不是电话号码
    func isPhoneNumber(phone : String)->Bool {
        print(phone)
        let patternTel: String = "^1[3,5,8,7][0-9]{9}$"
        var matcher: RegexHelper
        do {
            matcher = try! RegexHelper(patternTel)
        }
        if matcher.match(phone) {
            return true
        }
        return false
    }
    
    struct RegexHelper {
        let regex: NSRegularExpression
        
        init(_ pattern: String) throws {
            try regex = NSRegularExpression(pattern: pattern,
                options: .CaseInsensitive)
        }
        
        func match(input: String) -> Bool {
            let matches = regex.matchesInString(input,
                options: [],
                range: NSMakeRange(0, input.characters.count))
            return matches.count > 0
        }
    }
    
    // 发送验证码
    class func sendMessageCode(phone:String,result:(AnyObject)->Void) {
        AVOSCloud.requestSmsCodeWithPhoneNumber(phone) { (reslut, err) -> Void in
            if (err == nil) {
                result(reslut);
                return
            }
            result(err)
        }
    }
    
    // 根据验证码与手机号注册
    class func loginUpWithcode(phone: String, code : String, result:(AnyObject)->Void) {
        if code == "" {
            return
        }
        AVUser.signUpOrLoginWithMobilePhoneNumberInBackground(phone, smsCode: code) { (usr, err) -> Void in
            if err != nil { //注册失败
                result(err);
                return
            }
            NSUserDefaults.standardUserDefaults().setObject("login", forKey:("siLogin"))
            // 注册成功
            result(usr);
            return
        }
    }
    
    // 重置密码请求验证码
    class func registSMSCod(str:String ,result:(AnyObject)->Void) {
        AVUser.requestPasswordResetWithPhoneNumber(str) { (succeeded, err) -> Void in
            if succeeded {
                result(succeeded)
                return
            }
            if err != nil{
                let view = UIAlertView(title: "提示", message: "验证码请求失败", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "取消")
                view.show()
                print(err.domain)
            }
        }
    }
    
    // 重置密码
    class func resetPW(SMScod: String, newPW: String ,result:(AnyObject)->Void) {
        AVUser.resetPasswordWithSmsCode(SMScod, newPassword: newPW) { (succeeded, err) -> Void in
            if succeeded {
                result(succeeded)
                return
            }
            if err != nil {
                let view = UIAlertView(title: "提示", message: "重置失败", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "取消")
                view.show()
               print(err.domain)
            }
        }
    }
    
}
