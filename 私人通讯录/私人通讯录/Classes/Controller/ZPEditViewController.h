//
//  ZPEditViewController.h
//  私人通讯录
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

//编辑联系人信息页面

#import <UIKit/UIKit.h>

@class ZPContact, ZPEditViewController;

typedef void(^ZPEditViewControllerBlock)();

@protocol ZPEditViewControllerDelegate <NSObject>

@optional

- (void)editViewController:(ZPEditViewController *)editVC didSaveContact:(ZPContact *)contact;

@end

@interface ZPEditViewController : UIViewController

@property (nonatomic, strong) ZPContact *contact;  //接收从联系人列表页面传递过来的联系人对象
@property (nonatomic, weak) id <ZPEditViewControllerDelegate> delegate;
@property (nonatomic, copy) ZPEditViewControllerBlock block;

@end
