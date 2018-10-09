//
//  ZPTableViewCell.m
//  私人通讯录
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPTableViewCell.h"
#import "ZPContact.h"

@interface ZPTableViewCell()

@property (nonatomic, strong) UIView *divider;  //分割线

@end

@implementation ZPTableViewCell

/**
 用storyboard文件创建这个自定义cell的时候，系统就会调用这个方法，但是当用代码创建这个自定义cell的话就不会调用这个方法；
 一般在此方法中对本类中做连线的属性做一些初始化的工作，比如把方形的头像变成圆形的等等诸如此类的操作；
 现在在此方法中给这个自定义cell添加一个分割线，但是不在此方法中给这个分割线设置尺寸。
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    //创建自定义cell的分割线
    self.divider = [[UIView alloc] init];
    self.divider.backgroundColor = [UIColor blackColor];
    self.divider.alpha = 0.2;
    [self.contentView addSubview:self.divider];  //在cell里面添加控件的话必须加在cell的contentView上面
}

/**
 不论用代码创建还是用xib创建此自定义cell，系统都会调用此方法，一般在此方法中设置自定义cell控件内部的子控件的尺寸。
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置分割线的frame
    CGFloat dividerX = 0;
    CGFloat dividerH = 1;
    CGFloat dividerY = self.frame.size.height - dividerH;
    CGFloat dividerW = self.frame.size.width;
    self.divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"contacts";
    
    ZPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[ZPTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    return cell;
}

- (void)setContact:(ZPContact *)contact
{
    _contact = contact;
    
    self.textLabel.text = contact.name;
    self.detailTextLabel.text = contact.phone;
}

@end
