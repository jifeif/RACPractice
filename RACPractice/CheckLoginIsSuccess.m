//
//  CheckLoginIsSuccess.m
//  RACPractice
//
//  Created by 9188iMac on 16/3/30.
//  Copyright © 2016年 9188iMac. All rights reserved.
//

#import "CheckLoginIsSuccess.h"
#import "GDataXMLNode.h"
@interface CheckLoginIsSuccess ()
@end


@implementation CheckLoginIsSuccess

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}


- (void)loginName:(NSString *)name andPassword:(NSString *)pass andblock:(void(^)(BOOL isSuccess))isSuccessBlock{
    if ([name isEqualToString:@"1234"] && [pass isEqualToString:@"123456"]) {
        isSuccessBlock(YES);
    }else{
        isSuccessBlock(NO);
    }
}

@end
