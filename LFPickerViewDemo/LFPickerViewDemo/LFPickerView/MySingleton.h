//
//  MySingleton.h
//  LFPickerViewDemo
//
//  Created by ios开发 on 2017/7/10.
//  Copyright © 2017年 ios开发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityDataModel.h"

@interface MySingleton : NSObject

+ (instancetype) shareMySingletion;


//城市模型
@property (nonatomic,strong) CityDataModel *cityModel;

/*Json 转为OC对象*/
- (id)getObjectFormJsonString:(NSString *)jsonString;

/**
 *  保存字段对应的值到本地
 *
 *  @param fieldName 字段
 *  @param value     值
 */
+(void)saveLoacalWithField:(NSString *)fieldName value:(id)value;


/**
 *  得到保存到本地对应字段的值
 *
 *  @param fieldName 字段
 *
 *  @return 值
 */
+(id)getsaveLoacalField:(NSString *)fieldName;

@end
