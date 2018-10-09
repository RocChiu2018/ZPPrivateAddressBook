//
//  ZPContactsTableViewController.m
//  私人通讯录
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPContactsTableViewController.h"
#import "ZPAddViewController.h"
#import "ZPContact.h"
#import "ZPEditViewController.h"
#import "ZPTableViewCell.h"
#import "MBProgressHUD+MJ.h"

#define kFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"contacts.data"]

@interface ZPContactsTableViewController () <ZPAddViewControllerDelegate, ZPEditViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *contacts;  //联系人数组

@end

@implementation ZPContactsTableViewController

#pragma mark ————— 懒加载 —————
- (NSMutableArray *)contacts
{
    if (_contacts == nil)
    {
        /**
         归档这种存储方式一般用来存储自定义对象类型的数据，这种存储方式一般把要存储的数据存放在手机沙盒中的Library文件夹中的Caches文件夹中；
         在程序运行之后先从手机的沙盒中解档取出相应的数据。
         */
        _contacts = [NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];
        
        //如果沙盒中原本就没有相应数据的话则解档出来以后联系人数组是空的，这个时候联系人数组不会被初始化，所以在这种情况下应该给联系人数组进行初始化。
        if (_contacts == nil)
        {
            _contacts = [NSMutableArray array];
        }
    }
    
    return _contacts;
}

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [MBProgressHUD hideHUD];
    
    //去掉tableview的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark ————— 点击“注销”按钮触发的方法 —————
- (IBAction)clickLogOut:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要注销吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //添加“确定”按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    //添加“取消”按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark ————— UITableViewDataSource —————
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZPTableViewCell *cell = [ZPTableViewCell cellWithTableView:tableView];
    cell.contact = [self.contacts objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark ————— UITableViewDelegate —————
/**
 只要实现了这个方法，左滑cell就会出现“删除”按钮；
 如果点击“删除”按钮，系统就会自动调用这个方法。
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)  //删除操作
    {
        //1、删除数据模型：
        [self.contacts removeObjectAtIndex:indexPath.row];
        
        /**
         2、刷新列表：
         下面的方法代表仅删除表格中的特定行并且仅刷新这些被删除的行；
         此方法与reloadData方法的区别就在于下面的方法仅仅是刷新被删除的那些行，而reloadData方法是刷新整个列表，下面的方法较reloadData方法更节省系统的资源并且在刷新的过程中还可以设置动画效果；
         下面方法调用的前提是删掉对象的个数和删掉的行数要一致，否则程序就会崩溃。
         */
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        /**
         3、归档：把删除后的新的联系人数组存放到沙盒中；
         归档的时候系统会遍历self.contacts这个数组，然后把这个数组里面的对象一个一个地进行归档。
         */
        [NSKeyedArchiver archiveRootObject:self.contacts toFile:kFilePath];
    }
}

#pragma mark ————— segue方法 —————
/**
 在storyboard文件中从本视图控制器跳转到其他视图控制器的segue都是自动型segue；
 程序运行以后点击导航栏右上角的“+”按钮和点击cell之后在页面跳转之前会调用这个方法；
 
 两个类之间的逆传传值主要有以下的三种方式：
 1、利用代理设计模式逆传数据：下面的方法中会用到，其他的Demo中也会单独介绍这种逆传方式；
 2、利用block回调的方式来逆传数据：下面的方法中会用到，其他的Demo中也会单独介绍这种逆传方式；
 3、利用通知的方式来逆传数据：其他的Demo中会单独介绍这种逆传方式。
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //获取目的视图控制器
    id destinationVC = segue.destinationViewController;
    
    if ([destinationVC isKindOfClass:[ZPAddViewController class]])  //跳转到添加联系人页面
    {
        ZPAddViewController *addVC = destinationVC;
        
        //利用代理设计模式逆传数据
//        addVC.delegate = self;
        
        //利用block回调的方式来逆传数据
        addVC.block = ^(ZPContact *contact){
            [self.contacts addObject:contact];
            
            [self.tableView reloadData];
            
            //把新的联系人数组进行归档
            [NSKeyedArchiver archiveRootObject:self.contacts toFile:kFilePath];
        };
    }else if ([destinationVC isKindOfClass:[ZPEditViewController class]])  //跳转到编辑联系人页面
    {
        ZPEditViewController *editVC = destinationVC;
        
        //获取表格中选中的那一行
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        //顺传数据：把本类的对象数据传递给其他类
        editVC.contact = [self.contacts objectAtIndex:indexPath.row];
        
        //利用代理设计模式逆传数据
//        editVC.delegate = self;
        
        //利用block回调的方式来逆传数据
        editVC.block = ^(){
            [self.tableView reloadData];
            
            //把最新的联系人数组进行归档
            [NSKeyedArchiver archiveRootObject:self.contacts toFile:kFilePath];
        };
    }
}

#pragma mark ————— ZPAddViewControllerDelegate —————
/**
 利用代理设计模式逆传数据：在其他类中调用代理方法的时候把需要逆传的数据作为代理方法的一个参数传递给本类，这样在本类中实现这个代理方法的时候就可以拿到这个逆传过来的数据了。
 */
- (void)addViewController:(ZPAddViewController *)addVC didAddContact:(ZPContact *)contact
{
    [self.contacts addObject:contact];
    
    [self.tableView reloadData];
    
    //把新的联系人数组进行归档
    [NSKeyedArchiver archiveRootObject:self.contacts toFile:kFilePath];
}

#pragma mark ————— ZPEditViewControllerDelegate —————
/**
 利用代理设计模式逆传数据：下面代理方法中的从编辑页面传递过来的contact对象就是当初从本类传递过去的那个contact对象，在编辑页面中已经对这个contact对象的相关属性进行了修改，所以从编辑页面逆传过来的这个contact对象已经是属性经过修改的contact对象了。从本质上讲本类的和编辑页面的contact对象是同一个contact对象，只不过在编辑页面把这个contact对象的属性进行了修改而已。
 */
-(void)editViewController:(ZPEditViewController *)editVC didSaveContact:(ZPContact *)contact
{
    [self.tableView reloadData];
    
    //把最新的联系人数组进行归档
    [NSKeyedArchiver archiveRootObject:self.contacts toFile:kFilePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
