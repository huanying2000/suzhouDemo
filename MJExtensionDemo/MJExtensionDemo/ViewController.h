//
//  ViewController.h
//  MJExtensionDemo
//
//  Created by ios开发 on 2018/2/27.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJExtension.h"

@interface ViewController : UIViewController


@end


typedef enum {
    SexMale,
    SexFemale
}Sex;

@interface User : NSObject

@property (nonatomic,copy) NSString *name;
@property (copy, nonatomic) NSString *icon;/* 头像 */
@property (assign, nonatomic) unsigned int age;/* 年龄 */
@property (copy, nonatomic) NSString *height;/* 身高 */
@property (strong, nonatomic) NSNumber *money;/* 资产 */
@property (assign, nonatomic) Sex sex;/* 性别 */

@end

@interface Status : NSObject

@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) User *user;
@property (nonatomic,strong) Status *retweetedStatus;

@end

@interface ADModel : NSObject

@property (nonatomic,copy) NSString *image;

@property (nonatomic,copy) NSString *url;

@end

@interface resultModel : NSObject

@property (nonatomic,strong) NSMutableArray *statuses;
@property (nonatomic,strong) NSMutableArray *ads;
@property (nonatomic,strong) NSNumber *totalNumber;
@property (nonatomic,assign) long long previousCursor;
@property (nonatomic,assign) long long nextCursor;

@end

@interface Bag : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) CGFloat price;

@end

@interface Student : NSObject

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *otherName;
@property (copy, nonatomic) NSString *nowName;
@property (copy, nonatomic) NSString *oldName;
@property (copy, nonatomic) NSString *nameChangedTime;
@property (copy, nonatomic) NSString *desc;
@property (strong, nonatomic) Bag *bag;

@end


