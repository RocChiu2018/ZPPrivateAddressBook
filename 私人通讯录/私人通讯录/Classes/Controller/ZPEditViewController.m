//
//  ZPEditViewController.m
//  私人通讯录
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPEditViewController.h"
#import "ZPContact.h"

@interface ZPEditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ZPEditViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameTextField.text = self.contact.name;
    self.phoneTextField.text = self.contact.phone;
    
    //给两个输入框注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
}

#pragma mark ————— 文本框开始编辑的时候调用 —————
-(void)textChange
{
    if (self.nameTextField.text.length && self.phoneTextField.text.length)
    {
        self.saveButton.enabled = YES;
    }else
    {
        self.saveButton.enabled = NO;
    }
}

#pragma mark ————— 点击导航栏右上角的按钮 —————
/**
 从联系人列表页面跳转到本页面的时候，导航栏右侧的按钮显示的应该是“编辑”字样，并且此时姓名和电话文本框应该是不能编辑的，这个时候应该设置这两个文本框的enabled属性为NO，在点击“编辑”按钮后，按钮的“编辑”字样会变成“取消”字样，并且此时的姓名和电话输入框变为可编辑的，这个时候应该设置这两个输入框的enabled属性为YES。
 */
- (IBAction)edit:(UIBarButtonItem *)item
{
    if (self.nameTextField.enabled)  //此时导航栏右上角的按钮是“取消”字样
    {
        self.nameTextField.enabled = NO;
        self.phoneTextField.enabled = NO;
        self.saveButton.hidden = YES;
        
        //因为两个输入框的enabled属性已经设置为了NO，键盘会自动退出，所以就不用再撰写下面的这句代码了。
//        [self.view endEditing:YES];
        
        item.title = @"编辑";
        
        //输入框还原回原来的数据
        self.nameTextField.text = self.contact.name;
        self.phoneTextField.text = self.contact.phone;
    }else  //此时导航栏右上角的按钮是“编辑”字样
    {
        self.nameTextField.enabled = YES;
        self.phoneTextField.enabled = YES;
        self.saveButton.hidden = NO;
        
        [self.nameTextField becomeFirstResponder];
        
        item.title = @"取消";
    }
}

#pragma mark ————— 点击“保存”按钮 —————
- (IBAction)save
{
    [self.navigationController popViewControllerAnimated:YES];
    
    //更新数据模型
    self.contact.name = self.nameTextField.text;
    self.contact.phone = self.phoneTextField.text;
    
    if ([self.delegate respondsToSelector:@selector(editViewController:didSaveContact:)])
    {
        [self.delegate editViewController:self didSaveContact:self.contact];
    }
    
    if (self.block)
    {
        self.block();
    }
}

#pragma mark ————— 本视图控制器销毁的时候调用 —————
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
