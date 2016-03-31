//
//  KVOViewController.m
//  RACPractice
//
//  Created by 9188iMac on 16/3/30.
//  Copyright © 2016年 9188iMac. All rights reserved.
//

#import "KVOViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface KVOViewController ()
@property (nonatomic, assign) NSInteger age;
- (IBAction)delegateMethod:(id)sender;
@end

@implementation KVOViewController

- (void)viewDidLoad {
    _age = 3;
    [super viewDidLoad];
    [self valueChange];
}

#pragma mark -KVO
- (void)valueChange{
    __weak typeof(self) w_self = self;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, (uint64_t)1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        w_self.age += 3;
    });
    
    [RACObserve(self, age) subscribeNext:^(id x) {
        NSLog(@"age = %d", [x intValue]);
    }];
}



//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    
//}

- (IBAction)delegateMethod:(id)sender {
    if(self.delegate && [_delegate respondsToSelector:@selector(delegateBtnClick:)]) {
        [_delegate delegateBtnClick:@[@"1", @"2", @"3"]];
    }
}
- (void)dealloc
{
    NSLog(@"....");
}
@end
