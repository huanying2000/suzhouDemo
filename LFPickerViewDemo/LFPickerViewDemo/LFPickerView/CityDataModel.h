//
//  CityDataModel.h
//  LFPickerViewDemo
//
//  Created by ios开发 on 2017/7/10.
//  Copyright © 2017年 ios开发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class Province,City,District;
@interface CityDataModel : NSObject
/*省份模型数组*/

@property (nonatomic,strong) NSArray <Province *> *province;



@end


@interface Province : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSArray <City *>*city;

@end


@interface City : NSObject
//城市名称
@property (nonatomic,copy) NSString *name;

/**
 *  县级模型数组
 */
@property (nonatomic, strong) NSArray<District *> *district;

@end


@interface District : NSObject
//县级市名字
@property (nonatomic,copy) NSString *name;
//邮编
@property (nonatomic,copy) NSString *zipcode;

@end
