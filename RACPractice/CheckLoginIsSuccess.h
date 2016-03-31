//
//  CheckLoginIsSuccess.h
//  RACPractice
//
//  Created by 9188iMac on 16/3/30.
//  Copyright © 2016年 9188iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@interface CheckLoginIsSuccess : NSObject
- (void)loginName:(NSString *)name andPassword:(NSString *)pass andblock:(void(^)(BOOL isSuccess))isSuccessBlock;
@end
