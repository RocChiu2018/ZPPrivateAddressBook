//
//  ZPAddViewController.h
//  私人通讯录
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

//添加联系人页面

#import <UIKit/UIKit.h>

@class ZPAddViewController, ZPContact;

//block的命名规则：以类名为开头后面加上Block
typedef void (^ZPAddViewControllerBlock) (ZPContact *contact);

//协议的命名规则：协议的名称以本类的类名为开头后面加上Delegate。
@protocol ZPAddViewControllerDelegate <NSObject>

@optional

/**
 协议的代理方法的命名规则：代理方法的名称一般包含两个部分（两个参数）：第一个部分写为调用这个代理方法的视图控制器的名称，它后面的参数应传入调用这个代理方法的视图控制器，第二部分写为将要用这个代理方法所做的事情，它后面的参数应传入将要逆传的数据（自定义的对象）。
 */
- (void)addViewController:(ZPAddViewController *)addVC didAddContact:(ZPContact *)contact;

@end

@interface ZPAddViewController : UIViewController

@property (nonatomic, weak) id <ZPAddViewControllerDelegate> delegate;  //代理属性用weak关键字来修饰
@property (nonatomic, copy) ZPAddViewControllerBlock block;  //block属性用copy关键字来修饰

@end
