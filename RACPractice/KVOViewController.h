//
//  KVOViewController.h
//  RACPractice
//
//  Created by 9188iMac on 16/3/30.
//  Copyright © 2016年 9188iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KVOViewControllerProtocol <NSObject>
@optional
- (void)delegateBtnClick:(NSArray *)arr;
@end

@interface KVOViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *delegateBtn;
@property (nonatomic, weak) id<KVOViewControllerProtocol> delegate;
@end
