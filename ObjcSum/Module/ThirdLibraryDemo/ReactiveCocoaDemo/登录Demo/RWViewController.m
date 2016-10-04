//
//  RWViewController.m
//  ObjcSum
//
//  Created by yangyuan on 2016/9/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "RWViewController.h"
#import "ReactiveCocoa.h"
#import "RWSignInService.h"

@interface RWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@property (nonatomic) BOOL passwordIsValid;
@property (nonatomic) BOOL usernameIsValid;

@property (nonatomic, strong) RWSignInService *signInService;

@end

@implementation RWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _signInService = [RWSignInService new];
    [self updateUIState];
    
    // handle text changes for both text fields
    [self.usernameTextField addTarget:self action:@selector(usernameTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(passwordTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    // initially hide the failure message
    self.signInFailureText.hidden = YES;
}

- (void)updateUIState {
    self.usernameTextField.backgroundColor = self.usernameIsValid ? [UIColor clearColor] : [UIColor yellowColor];
    self.passwordTextField.backgroundColor = self.passwordIsValid ? [UIColor clearColor] : [UIColor yellowColor];
    self.signInButton.enabled = self.usernameIsValid && self.passwordIsValid;
}

- (void)usernameTextFieldChanged {
    self.usernameIsValid = [self isValidUsername:self.usernameTextField.text];
    [self updateUIState];
}

- (void)passwordTextFieldChanged {
    self.passwordIsValid = [self isValidPassword:self.passwordTextField.text];
    [self updateUIState];
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

- (IBAction)signInButtonTouched:(id)sender {
    _signInButton.enabled = NO;
    _signInFailureText.hidden = YES;
    
    [_signInService signInWithUsername:_usernameTextField.text password:_passwordTextField.text complete:^(BOOL success) {
        self.signInButton.enabled = YES;
        self.signInFailureText.hidden = success;
        if (success) {
            [self performSegueWithIdentifier:@"signInSuccess" sender:self];
        }
    }];
}

#pragma mark - 1.理论篇

- (void)racTheory {
    [_usernameTextField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    /**
     每次在text field中输入时，都会执行block中的代码。没有target-action，没有代理，只有信号与block。是不是很棒？
     
     ReactiveCocoa信号发送一个事件流到它们的订阅者中。
     我们需要知道三种类型的事件：next, error和completed。
     一个信号可能由于error事件或completed事件而终止，在此之前它会发送很多个next事件。在这一部分中，我们将重点关注next事件。
     
     RACSignal有许多方法用于订阅这些不同的事件类型。每个方法会有一个或多个block，每个block执行不同的逻辑处理。在上面这个例子中，我们看到subscribeNext:方法提供了一个响应next事件的block。
     
     ReactiveCocoa框架通过类别来为大部分标准UIKit控件添加信号，以便这些控件可以添加其相应事件的订阅，如上面的UITextField包含了rac_textSignal属性。
     */
    
    //ReactiveCocoa有大量的操作右用于处理事件流。例如，如果我们只对长度大于3的用户名感兴趣，则我们可以使用filter操作。
    [[_usernameTextField.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    //可以看到当长度小于3时，并不执行后续的操作。通过这种方式，我们创建了一个简单的管道。这就是响应式编程的实质
}

#pragma mark - 2.重构版

- (void)addSignal {
    /**
     1. 创建有效的状态信号
     我们要做的第一件事就是创建一对信号来校验用户名与密码的输入是否有效
     */
    RACSignal *validUsernameSignal = [_usernameTextField.rac_textSignal map:^id(id value) {
        return @([self isValidUsername:value]);
    }];
    RACSignal *validPasswordSignal = [_passwordTextField.rac_textSignal map:^id(id value) {
        return @([self isValidPassword:value]);
    }];
    
    /**
     2. 接着将转换这些信号，以便其可以为文本输入框提供一个合适的背影颜色。
     我们可以订阅这个信号并使用其结果来更新文本输入框的颜色。
     */
    [[validPasswordSignal map:^id(NSNumber *value) {
        return value.boolValue ? [UIColor clearColor] : [UIColor yellowColor];
    }] subscribeNext:^(UIColor *color) {
        //我们将信号的输出值赋值给文本输入框的backgroundColor属性。
        self.passwordTextField.backgroundColor = color;
    }];
    
    /**
     上面这段代码有点糟糕。我们可以以另外一种方式来做相同的处理。这得益于ReactiveCocoa定义的一些宏。
     
     RAC宏我们将信号的输入值指派给对象的属性。它带有两个参数，第一个参数是对象，第二个参数是对象的属性名。
     每次信号发送下一个事件时，其输出值都会指派给给定的属性。这是个非常优雅的解决方案，对吧？
     */
    RAC(_passwordTextField, backgroundColor) = [validPasswordSignal map:^id(NSNumber *value) {
        return value.boolValue ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RAC(_usernameTextField, backgroundColor) = [validUsernameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    /**
     3. 组合信号
     
     在当前的程序中，Sign in按钮只有在两个输入框都有效时才可点击。
     使用combineLatest:reduce:方法来组合validUsernameSignal与validPasswordSignal最后输出的值，并生成一个新的信号。
     每次两个源信号中的一个输出新值时，reduce块都会被执行，而返回的值会作为组合信号的下一个值。
     
     》注意：RACSignal组合方法可以组合任何数量的信号，而reduce块的参数会对应每一个信号。
     */
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
        return @(usernameValid.boolValue && passwordValid.boolValue);
    }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.signInButton.enabled = signupActive.boolValue;
    }];
    
    /**
     上面我们已经用ReactiveCocoa实现了一些非常棒的功能，它包含了两个重要的概念：
     
     1. Spliting: 信号可以有多个订阅者，且作为资源服务于序列化管道的多个步骤。
     2. Combining: 多个信号可以组合起来创建新的信号。
     
     在上面的程序中，这些改变让程序不再需要私有属性，来标明两个输入域的有效状态。这是使用响应式编程的关键区别–我们不需要使用实例变量来跟踪短暂的状态。
     */
    
    
    /**
     4. 响应Sign-in
     
     为了处理按钮事件，我们需要使用ReactiveCocoa添加到UIKit的另一个方法：rac_signalForControlEvents。
     */
    [[_signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //从按钮的UIControlEventTouchUpInside事件中创建一个信号，并添加订阅以在每次事件发生时添加日志。
        NSLog(@"Button clicked");
    }];
    
    /**
     5. 创建信号
     现在点击事件有一个信号了，接下来将信号与登录处理连接起来。打开RWSignInService.h文件，我们会看到下面的接口：
     这个方法带有一个用户名、密码和一个完成block。block会在登录成功或失败时调用。
     我们可以在subscribeNext:块中直接调用这个方法，但为什么不呢？因为这是一个异步操作，小心了。
     幸运的是，将一个已存在的异步API表示为一个信号相当简单
     */
    
    //使用signInSignal
    [[[_signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(id value) {
        return [self signInSignal];
    }] subscribeNext:^(id x) {
        NSLog(@"Sign in result: %@", x);
    }];
    /**
     运行程序，点击按钮，可以看到以下输出：
     2014-07-31 18:29:27.134 RWReactivePlayground[9749:60b] Sign in result: <UIButton: 0x13651ed40; frame = (192 201; 76 30); opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x178224c00>>
     
     可以看到subscribeNext:块传递了一个正确的信号，但结果不是登录信号。
     
     当点击按钮时rac_signalForControlEvents发出了一个next事件。map这一步创建并返回一个登录信号，意味着接下来的管理接收一个RACSignal。这是我们在subscribeNext:中观察到的对象。
     
     上面这个方案有时候称为信号的信号(signal of signals)，换句话说，就是一个外部信号包含一个内部信号。可以在输出信号的subscribeNext:块中订阅内部信号。但这会引起嵌套的麻烦。幸运的是，这是个普遍的问题，而ReactiveCocoa已经提供了解决方案。
     */
    
    /**
     7. Signal of Signals
     只需要使用flattenMap来替换map
     */
    [[[_signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^id(id value) {
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *signedIn) {
        BOOL success = [signedIn boolValue];
        self.signInButton.enabled = YES;
        self.signInFailureText.hidden = success;
        if (success) {
            [self performSegueWithIdentifier:@"signInSuccess" sender:self];
        }
    }];
    
    /**
     8. 添加附加操作(side-effects)
     
     注意doNext:并不返回一个值，因为它是附加操作。它完成时不改变事件。
     */
    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x) {
           self.signInButton.enabled = NO;
           self.signInFailureText.hidden = YES;
       }]
      flattenMap:^RACStream *(id value) {
          return [self signInSignal];
      }]
     subscribeNext:^(NSNumber *signedIn) {
         self.signInButton.enabled = YES;
         BOOL success = [signedIn boolValue];
         self.signInFailureText.hidden = success;
         if (success) {
             [self performSegueWithIdentifier:@"signInSuccess" sender:self];
         }
     }];
    
    /**
     总结
     ReactiveCocoa的核心是信号，它是一个事件流。使用ReactiveCocoa时，对于同一个问题，可能会有多种不同的方法来解决。ReactiveCocoa的目的就是为了简化我们的代码并更容易理解。如果使用一个清晰的管道，我们可以很容易理解问题的处理过程。
     */
}

/**
 createSignal:方法用于创建一个信号。描述信号的block是一个信号参数，当信号有一个订阅者时，block中的代码会被执行。
 
 block传递一个实现RACSubscriber协议的subscriber(订阅者)，这个订阅者包含我们调用的用于发送事件的方法；
 我们也可以发送多个next事件，这些事件由一个error事件或complete事件结束。
 在上面这种情况下，它发送一个next事件来表示登录是否成功，后续是一个complete事件。
 
 这个block的返回类型是一个RACDisposable对象，它允许我们执行一些清理任务，这些操作可能发生在订阅取消或丢弃时。上面这个这个信号没有任何清理需求，所以返回nil。
 
 我们就这样在信号中封装了一个异步API。
 */
- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [_signInService signInWithUsername:_usernameTextField.text password:_passwordTextField.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


@end




















