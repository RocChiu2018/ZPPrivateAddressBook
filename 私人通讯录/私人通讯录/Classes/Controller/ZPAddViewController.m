//
//  ZPAddViewController.m
//  私人通讯录
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPAddViewController.h"
#import "ZPContact.h"

@interface ZPAddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;  //姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;  //电话输入框
@property (weak, nonatomic) IBOutlet UIButton *addButton;  //添加按钮

@end

@implementation ZPAddViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //给两个输入框注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //等view完全呈现在窗口以后再把键盘调出来
    [self.nameTextField becomeFirstResponder];
}

#pragma mark ————— 文本框开始编辑的时候调用 —————
-(void)textChange
{
    if (self.nameTextField.text.length && self.phoneTextField.text.length)
    {
        self.addButton.enabled = YES;
    }else
    {
        self.addButton.enabled = NO;
    }
}

#pragma mark ————— 点击“添加”按钮 —————
- (IBAction)add:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    ZPContact *contact = [[ZPContact alloc] init];
    contact.name = self.nameTextField.text;
    contact.phone = self.phoneTextField.text;
    
    //首先要确定遵循协议的那个类是否已经实现了协议里面的代理方法
    if ([self.delegate respondsToSelector:@selector(addViewController:didAddContact:)])
    {
        //利用代理设计模式逆传数据（把本类的contact对象逆传过去）
        [self.delegate addViewController:self didAddContact:contact];
    }
    
    //利用block回调的方式逆传数据
    if (self.block)
    {
        self.block(contact);
    }
}

#pragma mark ————— 本视图控制器销毁的时候调用 —————
//在此方法中移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
