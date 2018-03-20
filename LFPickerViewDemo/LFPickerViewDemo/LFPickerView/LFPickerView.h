//
//  LFPickerView.h
//  LFPickerViewDemo
//
//  Created by ios开发 on 2017/7/10.
//  Copyright © 2017年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFPickerViewDelegate <NSObject>

@optional

- (void)PickerSelectorIndixString:(NSString *)str;

@end

typedef NS_ENUM(NSInteger,ARRAYTYPE) {
    GenderArray,
    HeightArray,
    weightArray,
    DeteArray,
    AreaArray
};


@interface LFPickerView : UIView

@property (nonatomic,assign) ARRAYTYPE arrayType;

@property (nonatomic,strong) NSArray *customArr;

@property (nonatomic,strong) UILabel *selectLbl;

@property (nonatomic,weak) id <LFPickerViewDelegate>delegate;


@end
