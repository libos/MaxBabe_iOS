//
//  QueryReg.swift
//  MaxBabe
//
//  Created by Liber on 6/11/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

class QueryReg {
    
    let QueryURL = ["unique_username.php", "register.php",
        "login.php", "update.php","forget_password.php"]
    let base_url = "http://api.babe.maxtain.com/users/"
    
    enum QueryType{
        case UNIQUE, REGISTER, LOGIN, UPDATE, FORGET
    }
    enum ACCOUNT_STATUS{
        case CANCEL, NO_NETWORK, DUPLICATE, DATA_OK, DATA_ERR, NO_USER, LOGON,UPDATE_DONE
    }
    
    var params:NSDictionary
    var query_url:String
    
    init(params:NSDictionary,type:QueryType){
        self.params = params
        switch(type){
        case .UNIQUE:
            self.query_url = self.base_url + QueryURL[0]
        case .REGISTER:
            self.query_url = self.base_url + QueryURL[1]
        case .LOGIN:
            self.query_url = self.base_url + QueryURL[2]
        case .UPDATE:
            self.query_url = self.base_url + QueryURL[3]
        case .FORGET:
            self.query_url = self.base_url + QueryURL[4]
        }
    }
    
    func start(callback:(a_s:ACCOUNT_STATUS)->()){
        var axs:ACCOUNT_STATUS = ACCOUNT_STATUS.CANCEL
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.POST(
            self.query_url, parameters: self.params,
            success: {(operation:AFHTTPRequestOperation!,response:AnyObject!) in
                println(response.description)
                if response != nil {
                    let json:NSDictionary? = (response as? NSDictionary)
                    if json == nil {
                        axs = ACCOUNT_STATUS.NO_NETWORK
                    }else{
                        let state:String = (json?.valueForKey("state") as? String)!
                        
                        if  state.startWith("err") {
                            axs = ACCOUNT_STATUS.DATA_ERR
                        }
                        if (state.startWith("duplicate")) {
                            axs = ACCOUNT_STATUS.DUPLICATE
                        }
                        if (state.startWith("ok")) {
                            axs = ACCOUNT_STATUS.DATA_OK
                        }
                        if state == "no_user" {
                            axs = ACCOUNT_STATUS.NO_USER
                        }
                        if state == "login" {
                            var st = NSUserDefaults.standardUserDefaults()
                            st.setObject(json?.valueForKey("email"), forKey: Global.ACCOUNT_EMAIL)
                            st.setObject(json?.valueForKey("phone"), forKey: Global.ACCOUNT_EMAIL)
                            st.setObject(json?.valueForKey("nickname"), forKey: Global.ACCOUNT_EMAIL)
                            if json!.valueForKey("sex")!.isEqualToString("1") {
                                st.setObject("男", forKey: Global.ACCOUNT_SEX)
                            }else{
                                st.setObject("女", forKey: Global.ACCOUNT_SEX)
                            }
                            st.synchronize()
                            axs = ACCOUNT_STATUS.LOGON
                        }
                        if state == "done" {
                            axs = ACCOUNT_STATUS.UPDATE_DONE
                        }
                    }
                }else{
                    axs = ACCOUNT_STATUS.NO_NETWORK
                }
                callback(a_s: axs)
            },
            failure: {(operation : AFHTTPRequestOperation!, error : NSError!) in
                println(error.localizedDescription)
                axs = ACCOUNT_STATUS.NO_NETWORK;
                callback(a_s: axs)
            }
        )
    }
}