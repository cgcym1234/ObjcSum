//
//  LoginViewController.m
//  justice
//
//  Created by sihuan on 15/10/25.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpManager.h"
#import "LoginManager.h"
#import "YYHud.h"


#define UsernamePlaceHolder @"请输入登录名"
#define PasswordPlaceHolder @"请输入密码"
#define TipLoginSuccess @"登录成功"

static NSString * const TipNoUserName           = @"请输入用户名";
static NSString * const TipNoPassword           = @"请输入密码";

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginContainerView;

@property (weak, nonatomic) IBOutlet UIButton *topIcon;

@property (weak, nonatomic) IBOutlet UIView *inputContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameTopMargin;
@property (weak, nonatomic) IBOutlet UIButton *usernameIcon;
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;

@property (weak, nonatomic) IBOutlet UIView *separatedLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatedLineHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordBottomMargin;
@property (weak, nonatomic) IBOutlet UIButton *passwordIcon;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, copy) LoginViewControllerCompletionBlock completionBlock;

- (IBAction)userNameIconDidClicked:(UIButton *)sender;
- (IBAction)topIconDidClicked:(UIButton *)sender;
- (IBAction)passwordIconDidClicked:(UIButton *)sender;
- (IBAction)loginButtonDidClicked:(UIButton *)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEnvironment];
}

- (void)setEnvironment {
    self.inputContainerView.layer.borderWidth = 0.5;
    self.inputContainerView.layer.borderColor = ColorSeparator.CGColor;
    
    self.usernameInput.delegate = self;
    self.usernameInput.placeholder = UsernamePlaceHolder;
    
    self.passwordInput.delegate = self;
    self.passwordInput.placeholder = UsernamePlaceHolder;
    
    self.usernameTopMargin.constant = 1;
    self.passwordBottomMargin.constant = 1;
    
    self.separatedLineHeight.constant = 0.5;
    
    [self.usernameInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.loginButton.layer.cornerRadius = 4;
    
    self.usernameInput.text = @"admin";
    self.passwordInput.text = @"admin";
}

#pragma mark - Private

- (void)setUsernameIconSelected:(BOOL)isSelected {
    _usernameIcon.selected = isSelected;
    _passwordIcon.selected = !isSelected;
}

- (void)endEdit
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setUsernameIconSelected:textField == _usernameInput];
}

- (void)textFieldDidChange:(UITextField *)textField {
    self.loginButton.enabled = self.passwordInput.text.length > 0 && self.usernameInput.text.length > 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameInput) {
        [self.passwordInput becomeFirstResponder];
    } else if (textField == self.passwordInput) {
        [self.passwordInput resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)userNameIconDidClicked:(UIButton *)sender {
}

- (IBAction)topIconDidClicked:(UIButton *)sender {
    
}
- (IBAction)passwordIconDidClicked:(UIButton *)sender {
    
}
- (IBAction)loginButtonDidClicked:(UIButton *)sender {
    [self endEdit];
    
    NSString *username = self.usernameInput.text;
    NSString *password = self.passwordInput.text;
    
    if (username == nil || [username isEqualToString:@""])
    {
        [YYHud showTip:TipNoUserName];
        return;
    }
    
    if (password == nil || [password isEqualToString:@""])
    {
        [YYHud showTip:TipNoPassword];
        return;
    }
    
    [YYHud show:@"登录中"];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpManager loginWithLoginName:username password:password success:^(LoginModel *loginModel) {
        [LoginManager loginSuccessWithUserInfo:loginModel];
        [YYHud dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_LoginSuccess object:nil];
        if (weakSelf.completionBlock) {
            weakSelf.completionBlock(weakSelf, YES);
        }
    } failure:^(NSString *errorString) {
        [YYHud showTip:errorString];
    }];
}

#pragma mark - Public

+ (instancetype)instanceFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
}

+ (instancetype)instanceFromStoryboardWithCompletion:(LoginViewControllerCompletionBlock)completion {
    LoginViewController *login = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    login.completionBlock = completion;
    return login;
}

@end
