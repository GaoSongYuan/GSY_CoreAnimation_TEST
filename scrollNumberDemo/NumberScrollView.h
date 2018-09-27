//
//  NumberScrollView.h
//  scrollNumberDemo
//
//  Created by pupupula_gsy on 2018/8/29.
//  Copyright © 2018年 pupupula_gsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberScrollView : UIView

@property (strong, nonatomic) NSNumber *value;
@property (strong, nonatomic) NSNumber *value000new;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;
@property (assign, nonatomic) CFTimeInterval duration;
@property (assign, nonatomic) CFTimeInterval durationOffset;
@property (assign, nonatomic) NSUInteger density; // 密度
@property (assign, nonatomic) NSUInteger minLength; // 所显示的数字的最小长度
@property (assign, nonatomic) BOOL isAscending; // 上升

- (void)startAnimation;
- (void)stopAnimation;

@end
