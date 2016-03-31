//
//  ViewController.m
//  RACPractice
//
//  Created by 9188iMac on 16/3/30.
//  Copyright © 2016年 9188iMac. All rights reserved.
//  代理， 通知，  监听事件。 kvo  文本框文字变化。   界面请求。

#import "ViewController.h"
#import "KVOViewController.h"
#import "CheckLoginIsSuccess.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface ViewController ()<KVOViewControllerProtocol>
@property (nonatomic, strong) KVOViewController * KVOVC;
@property (nonatomic, strong) CheckLoginIsSuccess * checkLoginServe;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passTF;
@property (weak, nonatomic) IBOutlet UILabel *faileLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passTFCenterY;
- (IBAction)login:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.faileLabel.hidden = YES;
    self.loginBtn.enabled = NO;
    self.loginBtn.layer.cornerRadius = 10;
    self.checkLoginServe = [[CheckLoginIsSuccess alloc] init];
    
    [self creatKVOVC];
    [self checkDataIsValid];
    [self loginCheck];
    [self keyBoardEvent];
}

#pragma mark - 检查数据的有效性。
- (void)checkDataIsValid{
    RACSignal *nameValid = [self.nameTF.rac_textSignal map:^id(NSString *text) {
        return (text.length > 3) ? @(YES) : @(NO);
    }];
    
    RACSignal *passValid = [self.passTF.rac_textSignal map:^id(NSString *text) {
        return (text.length > 5) ? @(YES) : @(NO);
    }];
    
    RAC(self.nameTF, backgroundColor) = [nameValid map:^id(NSNumber *number) {
        return [number boolValue] ? ([UIColor clearColor]) : ([UIColor magentaColor]);
    }];
    
    RAC(self.passTF, backgroundColor) = [passValid map:^id(NSNumber *number) {
        return [number boolValue] ? ([UIColor clearColor]) : ([UIColor magentaColor]);
    }];
    
    //combinLatest 如果没有返回值的话， 发送的参数是各个信号执行参数的数组。
    [[RACSignal combineLatest:@[nameValid, passValid]]
                subscribeNext:^(NSArray *arr) {
                    if ([arr[0] boolValue] && [arr[1] boolValue]) {
                        self.loginBtn.enabled = YES;
                    }else{
                        self.loginBtn.enabled = NO;
                    }
    }];

/*    //一个个信号单独执行。
    RACSignal *mergeSig = [RACSignal merge:@[nameValid, passValid]];
    [mergeSig subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
*/
}

#pragma mark - 进行登录检测
- (void)loginCheck{
    @weakify(self);
    [[[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    doNext:^(id x) {
        @strongify(self);
        self.loginBtn.enabled = NO;
    }]
    flattenMap:^RACStream *(id value) {
        @strongify(self);
        return [self creatAPISignal];
    }]
    subscribeNext:^(NSNumber *number) {
        @strongify(self);
        self.loginBtn.enabled = YES;
        if ([number boolValue]) {
//            [self performSegueWithIdentifier:@"kvo" sender:self];
            [self.navigationController pushViewController:self.KVOVC animated:YES];
        }else{
            self.faileLabel.hidden = NO;
            [self faileLabelShake];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.faileLabel.hidden = YES;
            });
        }
    }];
}

#pragma mark - 失败提示晃动 
- (void)faileLabelShake{
    CAKeyframeAnimation * keyAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    keyAni.values = @[@(0), @(-10.0 / 180 * M_PI), @(0), @(10.0 / 180 * M_PI)];
    keyAni.repeatCount = 10;
    keyAni.duration = 0.2;
    [self.faileLabel.layer addAnimation:keyAni forKey:nil];
}

#pragma mark - 键盘弹出与消失
- (void)keyBoardEvent{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidChangeFrameNotification object:nil]
    subscribeNext:^(NSNotification *notification) {
        NSDictionary *dic = notification.userInfo;
        CGRect rect = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if (rect.origin.y - 30 <= self.view.center.y) {
            self.passTFCenterY.constant = -15;
        }else{
            self.passTFCenterY.constant = 0;
        }
    }];
}


#pragma mark - 创建一个API信号
- (RACSignal *)creatAPISignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.checkLoginServe loginName:self.nameTF.text andPassword:self.passTF.text andblock:^(BOOL isSuccess) {
            [subscriber sendNext:@(isSuccess)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


#pragma mark - 实例化 KVOVC 实现协议。
- (void)creatKVOVC{
    self.KVOVC = [self.storyboard instantiateViewControllerWithIdentifier:@"kvo"];
    _KVOVC.delegate = self;
    [[self rac_signalForSelector:@selector(delegateBtnClick:) fromProtocol:@protocol(KVOViewControllerProtocol)] subscribeNext:^(id x) {
        NSArray * arr = x[0];
        NSLog(@"%@", arr[2]);
    }];
    NSLog(@"创建成功");
}

//#pragma mark - KVOVC delegate
//- (void)delegateBtnClick:(NSArray *)arr{
//    NSLog(@"kvc页面btn按钮被点击");
//}


















- (IBAction)login:(id)sender {
//    [self performSegueWithIdentifier:@"kvo" sender:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
