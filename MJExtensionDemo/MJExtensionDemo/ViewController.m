//
//  ViewController.m
//  MJExtensionDemo
//
//  Created by ios开发 on 2018/2/27.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "ViewController.h"
#import "LFCar.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self dicToModel];
//    [self stringToModel];
//    [self complexDicToModel];
//    [self complexDicContentArrToModel];
//    [self keyValues2object4];
    LFCar *car = [[LFCar alloc] init];
    car.name = @"red bag";
    car.price = 200.8;
    
    NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"bag.data"];
    //归档
    [NSKeyedArchiver archiveRootObject:car toFile:file];
    //解档
    LFCar *decodedCar = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    NSLog(@"%@ %f",decodedCar.name,decodedCar.price);
}


//字典转模型
- (void) dicToModel {
    //简单的字典
    NSDictionary *dict_user = @{
                                @"name" : @"Jack",
                                @"icon" : @"lufy.png",
                                @"age" : @20,
                                @"height" : @"1.55",
                                @"money" : @100.9,
                                @"sex" : @(SexFemale),/* 枚举需要使用NSNumber包装 */
                                @"gay" : @YES
                                };
    User *user = [User mj_objectWithKeyValues:dict_user];
    NSLog(@"%@  %u  %@",user.name,user.sex,user.icon);
    
}


- (void) stringToModel {
    NSString *jsonStr = @"{\"name\":\"Jack\", \"icon\":\"lufy.png\", \"age\":20}";
    User *user = [User mj_objectWithKeyValues:jsonStr];
    NSLog(@"%@  %u  %@",user.name,user.age,user.icon);
}

- (void)complexDicToModel {
    NSDictionary *dict_m8m = @{
                               @"text" : @"Agree!Nice weather!",
                               @"user" : @{
                                       @"name" : @"Jack",
                                       @"icon" : @"lufy.png"
                                       },
                               @"retweetedStatus" : @{
                                       @"text" : @"Nice weather!",
                                       @"user" : @{
                                               @"name" : @"Rose",
                                               @"icon" : @"nami.png"
                                               }
                                       }
                               };
    
    Status *status = [Status mj_objectWithKeyValues:dict_m8m];
    NSString *text = status.text;
    NSString *name = status.user.name;
    NSString *icon = status.user.icon;
    NSLog(@"mj-----text=%@, name=%@, icon=%@", text, name, icon);
    NSString *text2 = status.retweetedStatus.text;
    NSString *name2 = status.retweetedStatus.user.name;
    NSString *icon2 = status.retweetedStatus.user.icon;
    NSLog(@"mj-----text2=%@, name2=%@, icon2=%@", text2, name2, icon2);
    
}

- (void)complexDicContentArrToModel {
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"statuses" : @[
                                   @{
                                       @"text" : @"今天天气真不错！",
                                       
                                       @"user" : @{
                                               @"name" : @"Rose",
                                               @"icon" : @"nami.png"
                                               }
                                       },
                                   
                                   @{
                                       @"text" : @"明天去旅游了",
                                       
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               }
                                       }
                                   
                                   ],
                           
                           @"ads" : @[
                                   @{
                                       @"image" : @"ad01.png",
                                       @"url" : @"http://www.小码哥ad01.com"
                                       },
                                   @{
                                       @"image" : @"ad02.png",
                                       @"url" : @"http://www.小码哥ad02.com"
                                       }
                                   ],
                           
                           @"totalNumber" : @"2014",
                           @"previousCursor" : @"13476589",
                           @"nextCursor" : @"13476599"
                           };
    resultModel *model = [resultModel mj_objectWithKeyValues:dict];
    NSLog(@"resultModel %lld ",model.nextCursor,model.previousCursor);
    // 4.打印statuses数组中的模型属性
    for (Status *status in model.statuses) {
        NSString *text = status.text;
        NSString *name = status.user.name;
        NSString *icon = status.user.icon;
        MJExtensionLog(@"text=%@, name=%@, icon=%@", text, name, icon);
    }
    
    // 5.打印ads数组中的模型属性
    for (ADModel *ad in model.ads) {
        MJExtensionLog(@"image=%@, url=%@", ad.image, ad.url);
    }
    
}

- (void)keyValues2object4 {
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"id" : @"20",
                           @"desciption" : @"好孩子",
                           @"name" : @{
                                   @"newName" : @"lufy",
                                   @"oldName" : @"kitty",
                                   @"info" : @[
                                           @"test-data",
                                           @{@"nameChangedTime" : @"2013-08-07"}
                                           ]
                                   },
                           @"other" : @{
                                   @"bag" : @{
                                           @"name" : @"小书包",
                                           @"price" : @100.7
                                           }
                                   }
                           };
    
    // 2.将字典转为MJStudent模型
    Student *stu = [Student mj_objectWithKeyValues:dict];
    
    // 3.打印MJStudent模型的属性
    MJExtensionLog(@"ID=%@, desc=%@, oldName=%@, nowName=%@, nameChangedTime=%@", stu.ID, stu.desc,  stu.oldName, stu.nowName, stu.nameChangedTime);
    MJExtensionLog(@"bagName=%@, bagPrice=%f", stu.bag.name, stu.bag.price);
}


- (void)arrayToModel {
    NSArray *dictArray = @[
                           @{
                               @"name" : @"Jack",
                               @"icon" : @"lufy.png"
                               },
                           @{
                               @"name" : @"Rose",
                               @"icon" : @"nami.png"
                               }
                           ];
    NSArray *userArray = [User mj_objectArrayWithKeyValuesArray:dictArray];
    for (User *user in userArray) {
        NSLog(@"name=%@, icon=%@", user.name, user.icon);
    }
}

//模型转字典
- (void)modelToDict {
    User *user = [[User alloc] init];
    user.name = @"jack";
    user.icon = @"lufy.png";
    
    NSDictionary *userDic = user.mj_keyValues;
    NSLog(@"%@",userDic);
}

//模型数组 转 字典数组
- (void)modelArrayToDicArray {
    User *user1 = [[User alloc] init];
    user1.name = @"Jack";
    user1.icon = @"lufy.png";
    User *user2 = [[User alloc] init];
    user2.name = @"Rose";
    user2.icon = @"nami.png";
    NSArray *userArray = @[user1, user2];
    
    NSArray *dictArray = [User mj_keyValuesArrayWithObjectArray:userArray];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

@implementation Student

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id",@"desc":@"desciption",@"oldName":@"name.oldName",@"nowName":@"name.newName",@"nameChangedTime":@"name.info[1].nameChangedTime",@"bag":@"other.bag"};
}

@end

@implementation Bag
@end


@implementation resultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"statuses" : @"Status", @"ads":@"ADModel"};
}

@end



@implementation User


@end

@implementation Status

@end

@implementation ADModel

@end



