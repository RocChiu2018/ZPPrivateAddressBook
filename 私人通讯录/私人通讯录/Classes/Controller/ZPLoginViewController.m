//
//  ZPLoginViewController.m
//  私人通讯录
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPLoginViewController.h"
#import "MBProgressHUD+MJ.h"

#define kUserDefaults [NSUserDefaults standardUserDefaults]

@interface ZPLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;  //账号输入框
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;  //密码输入框
@property (weak, nonatomic) IBOutlet UISwitch *remberSwitch;  //记住密码开关
@property (weak, nonatomic) IBOutlet UISwitch *autoSwitch;  //自动登录开关
@property (weak, nonatomic) IBOutlet UIButton *loginButton;  //登录按钮

@end

@implementation ZPLoginViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**
     偏好设置存储一般存储简单的软件参数配置的数据，这种存储方式一般把要存储的数据存到手机沙盒中的Library文件夹中的Preferences文件夹里面；
     在程序运行之后先从手机的沙盒中取出相应的数据。
     */
    NSString *account = [kUserDefaults objectForKey:@"account"];
    NSString*password = [kUserDefaults objectForKey:@"password"];
    BOOL isRember = [kUserDefaults boolForKey:@"isRember"];
    BOOL isAuto = [kUserDefaults boolForKey:@"isAuto"];
    
    //设置账号
    self.accountTextField.text = account;
    
    //如果之前的“记住密码”开关是打开的则要在密码框中填充密码
    if (isRember)
    {
        self.pwdTextField.text = password;
    }
    
    self.remberSwitch.on = isRember;
    self.autoSwitch.on = isAuto;
    
    //如果之前的“自动登录”开关是打开的则应该调用登录方法
    if (isAuto)
    {
        [self clickLoginButton];
    }
    
    //给账号输入框和密码输入框注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.accountTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdTextField];
    
    //如果不用上述的代码给两个输入框注册通知的话也可以用下面的代码给两个输入框添加监听事件
//    [self.accountTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
//    [self.pwdTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark ————— 文本框开始编辑的时候调用 —————
/**
 在storyboard文件中会先把“登录”按钮的Enabled设置为NO，当账户和密码输入框都有文字输入的时候再把“登录”按钮的Enabled设置为YES。
 */
-(void)textChange
{
    if (self.accountTextField.text.length && self.pwdTextField.text.length)
    {
        self.loginButton.enabled = YES;
    }else
    {
        self.loginButton.enabled = NO;
    }
}

#pragma mark ————— 点击“记住密码”开关 —————
//当记住密码开关关闭的时候，自动登录开关也应该关闭
- (IBAction)remberChange:(id)sender
{
    if (self.remberSwitch.isOn == NO)
    {
        [self.autoSwitch setOn:NO animated:YES];
    }
}

#pragma mark ————— 点击“自动登录”开关 —————
//当自动登录开关打开的时候，记住密码开关也应该打开
- (IBAction)autoChange:(id)sender
{
    if (self.autoSwitch.isOn)
    {
        [self.remberSwitch setOn:YES animated:YES];
    }
}

#pragma mark ————— 点击“登录”按钮 —————
//账号是"mj"，密码是“123”。
- (IBAction)clickLoginButton
{
    if (![self.accountTextField.text isEqualToString:@"mj"])
    {
        [MBProgressHUD showError:@"您输入的账号有误"];
    }else if (![self.pwdTextField.text isEqualToString:@"123"])
    {
        [MBProgressHUD showError:@"您输入的密码有误"];
    }else  //输入正确
    {
        //显示蒙版，为了不让用户再能和界面进行交互。
        [MBProgressHUD showMessage:@"正在登录..."];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //两秒钟后把蒙版隐藏
            [MBProgressHUD hideHUD];
            
            NSString *homePath = NSHomeDirectory();
            NSLog(@"homePath = %@", homePath);
            
            //把账号、密码、是否记住密码、是否自动登录等数据用偏好设置存储的方式存储到手机沙盒中的Library文件夹中的Preferences文件夹里面
            [kUserDefaults setObject:self.accountTextField.text forKey:@"account"];
            [kUserDefaults setObject:self.pwdTextField.text forKey:@"password"];
            [kUserDefaults setBool:self.remberSwitch.on forKey:@"isRember"];
            [kUserDefaults setBool:self.autoSwitch.on forKey:@"isAuto"];
            
            //对于手动型的segue，在满足了一定的条件之后开发者要在来源视图控制器类中主动调用下面的方法来完成后续的两个类之间的传值和页面的跳转
            [self performSegueWithIdentifier:@"loginToContacts" sender:@"123"];
        });
    }
}

/**
 storyboard文件中的segue有如下的三个属性：
 1、唯一标识符(identifier)，可以在storyboard文件中对segue进行设置；
 2、来源视图控制器(sourceViewController)；
 3、目的视图控制器(destinationViewController)。
 
 在storyboard文件中根据拖线方式的不同，可以把segue分为如下的两种：
 1、自动型segue：在storyboard文件中按住control键从来源视图控制器中的某个控件拖线到目的视图控制器；
 在程序运行之后如果点击来源视图控制器中的某个控件后不需要做任何判断，一定会跳转到目的视图控制器的话则应使用自动型segue。
 2、手动型segue：在storyboard文件中按住control键从来源视图控制器直接拖线到目的视图控制器；
 这种类型的segue需要提前在storyboard文件中给那个segue设置一个标识符(identifier)，然后在代码中如果满足了一定条件的时候在来源视图控制器类中开发人员应主动调用performSegueWithIdentifier: sender: 方法来执行那个segue以完成页面之间的传值和跳转；
 在程序运行之后如果点击来源视图控制器的某个控件后需要做一些判断，只有在满足某种条件的情况下才能跳转到目的视图控制器的话则应使用手动型segue。
 
 利用storyboard文件中的segue来完成两个视图控制器之间的顺传传值：
 1、自动型segue：在程序运行之后点击来源视图控制器中的某个控件后，系统会自动先调用下面的这个方法，在这个方法中把需要传递的数据传递给目的视图控制器，在执行完这个方法之后页面才会自动进行跳转了；
 2、手动型segue：在程序运行之后点击来源视图控制器中的某个控件并满足一定的条件后，开发人员要在来源视图控制器类中主动调用performSegueWithIdentifier: sender: 方法来执行segue，然后系统会自动先调用下面的这个方法，在这个方法中把需要传递的数据传递给目的视图控制器，在执行完这个方法之后页面才会自动进行跳转了。
 
 不管是自动型的segue还是手动型的segue，在页面跳转之前系统都会自动调用下面的方法。
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@ %@ %@ %@", sender, segue.identifier, segue.sourceViewController, segue.destinationViewController);
    
    /**
     给目的视图控制器的导航栏设置标题；
     把来源视图控制器（本类）的数据顺传给目的视图控制器：两个类之间的顺传传值主要使用下面的这一种方式。
     */
    UIViewController *contactsVC = segue.destinationViewController;
    
    contactsVC.navigationItem.title = [NSString stringWithFormat:@"%@的联系人列表", self.accountTextField.text];
}

#pragma mark ————— 视图控制器被销毁的时候会调用这个方法 —————
-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
