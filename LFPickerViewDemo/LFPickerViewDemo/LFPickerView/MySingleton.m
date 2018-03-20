//
//  MySingleton.m
//  LFPickerViewDemo
//
//  Created by ios开发 on 2017/7/10.
//  Copyright © 2017年 ios开发. All rights reserved.
//

#import "MySingleton.h"

static MySingleton *mySing = nil;

@implementation MySingleton

+ (instancetype) shareMySingletion {
    if (mySing == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mySing = [[MySingleton alloc] init];
        });
    }
    return mySing;
}

// alloc 分配内存空间的时候
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (mySing==nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mySing=[super allocWithZone:zone];
        });
    }
    return mySing;
}
// 复制 拷贝的时候
+ (id)copyWithZone:(struct _NSZone *)zone{
    return mySing;
}

- (id)getObjectFormJsonString:(NSString *)jsonString {
    NSError *error = nil;
    if (jsonString) {
        id result = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if (error == nil) {
            return result;
        }else {
            return nil;
        }
    }
    return nil;
}


+ (void)saveLoacalWithField:(NSString *)fieldName value:(id)value {
    NSUserDefaults *defaus = [NSUserDefaults standardUserDefaults];
    [defaus setObject:value forKey:@"fileName"];
    [defaus synchronize];
}

+ (id)getsaveLoacalField:(NSString *)fieldName {
    NSUserDefaults *defaus = [NSUserDefaults standardUserDefaults];
    return [defaus objectForKey:fieldName];
}


@end
