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
       let user = AVUser.currentUser()
        if user == nil {
            return false
        } else {
            return true
        }
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
            AVUser.logInWithUsernameInBackground(userName, password: passWorld, block: { (userInfor, err) -> Void in
                if err != nil || userInfor == nil {
                    return
                }
                let us : LO_user = LO_user()
                us.userName = userInfor.username != nil ? userInfor.username : "请输入用户名"
                us.mobilePhoneNumber = userInfor.mobilePhoneNumber != nil ? userInfor.mobilePhoneNumber : "绑定手机"
                us.email = userInfor.mobilePhoneNumber != nil ? userInfor.email : "绑定邮箱"
                success(user: us)
            })
        case .email :
            //
            print("请输入用户名或者手机号")
        case .mobilePhoneNumber :
            AVUser.logInWithMobilePhoneNumberInBackground(userName, password: passWorld, block: { (userInfor, err) -> Void in
                if err != nil || userInfor == nil {
                    return
                }
                let us : LO_user = LO_user()
                us.userName = userInfor.username != nil ? userInfor.username : "请输入用户名"
                us.mobilePhoneNumber = userInfor.mobilePhoneNumber != nil ? userInfor.mobilePhoneNumber : "绑定手机"
                us.email = userInfor.mobilePhoneNumber != nil ? userInfor.email : "绑定邮箱"
                success(user: us)
            })
        case .error :
            print("错误")
        }
    }
    
    // 注册
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
    
    func userNameType(username: String)->UserNameType {
        let patternTel: String = "^1[3,5,8,7][0-9]{9}$"
        let tel = NSPredicate(format: "SELF MATCHES \(patternTel)", argumentArray: nil)
        if tel .evaluateWithObject(patternTel) {
            return UserNameType.mobilePhoneNumber
        }
        
        let patternemial : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let email = NSPredicate(format: "SELF MATCHES \(patternemial)", argumentArray: nil)
        if email.evaluateWithObject(patternemial) {
            return UserNameType.email
        }
        
        let patternUserName : String = "^[A-Za-z0-9_]{6,20}+$"
        let userNem = NSPredicate(format: "SELF MATCHES \(patternUserName)", argumentArray: nil)
        if userNem.evaluateWithObject(username) {
            return UserNameType.userName
        }
        return UserNameType.error
    }
    
    func passWorld(passwd : String)->Bool {
        let pass = "^[a-zA-Z0-9.]{6,20}+$"
        let userNem = NSPredicate(format: "SELF MATCHES \(pass)", argumentArray: nil)
        return userNem.evaluateWithObject(passwd)
    }
    
    
    
    
    
}
