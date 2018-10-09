//
//  ZPTableViewCell.h
//  私人通讯录
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPContact;

@interface ZPTableViewCell : UITableViewCell

@property (nonatomic, strong) ZPContact *contact;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
