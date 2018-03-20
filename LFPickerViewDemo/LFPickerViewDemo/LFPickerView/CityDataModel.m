//
//  CityDataModel.m
//  LFPickerViewDemo
//
//  Created by ios开发 on 2017/7/10.
//  Copyright © 2017年 ios开发. All rights reserved.
//

#import "CityDataModel.h"

@implementation CityDataModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"province":[Province class]};
}

@end

@implementation Province

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"city":[City class]};
}

@end

@implementation City

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"district" : [District class]};
}

@end


@implementation District

@end
