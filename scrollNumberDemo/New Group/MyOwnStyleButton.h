//
//  MyOwnStyleButton.h
//  scrollNumberDemo
//
//  Created by pupupula_gsy on 2018/9/14.
//  Copyright © 2018年 pupupula_gsy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonStyleType) {
    CircleButtonWithoutLabel = 0,
    RectangleButtonWithLabel = 1,
};

@interface MyOwnStyleButton : UIButton

/**
 是否被勾选
 */
@property (nonatomic, assign) BOOL isSelected;



- (instancetype)initWithFrame:(CGRect)frame type:(ButtonStyleType)type;

- (void)buttonClickAction:(MyOwnStyleButton *)sender;

@end
