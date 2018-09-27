//
//  MyOwnStyleButton.m
//  scrollNumberDemo
//
//  Created by pupupula_gsy on 2018/9/14.
//  Copyright © 2018年 pupupula_gsy. All rights reserved.
//

#import "MyOwnStyleButton.h"

static CGRect frame;
static CGRect bounds;

@interface MyOwnStyleButton ()
@property (nonatomic, strong) CAShapeLayer *layer0;
@property (nonatomic, assign) BOOL isBtnSelected;
@property (nonatomic, assign) ButtonStyleType type;
@end

@implementation MyOwnStyleButton
- (instancetype)initWithFrame:(CGRect)frame00 type:(ButtonStyleType)type {
    if (self = [super initWithFrame:frame00]) {
        self.isBtnSelected = NO;
        self.type = type;
        self.adjustsImageWhenHighlighted = NO; // 取消高亮
        [self addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
//        frame.origin = frame00.origin;
        frame = CGRectMake(frame00.origin.x, frame00.origin.y, 20, 20);
        bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 20, 20);
        
        switch (type) {
            case CircleButtonWithoutLabel: // 圆形按钮，不包含label
                [self drawCircle]; // 画圆
                break;
                
            default: // 方形按钮，包含label
                [self drawRectangle]; // 画矩形
                [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
                break;
        }
    }
    return self;
}

#pragma mark - 按钮点击
- (void)buttonClickAction:(MyOwnStyleButton *)sender {
    NSLog(@" - click - ");
    if (self.type == 0) { // 圆形
        [self buttonTransform]; // 按钮缩放
    }
    self.isBtnSelected = !self.isBtnSelected;
    
    [self checkAnimation:sender]; // 对号出现消失动画
    if (sender.isBtnSelected) { // 选中状态
        self.layer0.fillColor = [UIColor colorWithRed:255.0/255.0 green:225.0/255.0 blue:38.0/255.0 alpha:1].CGColor;
    } else { // 未选中状态
        self.layer0.fillColor = [UIColor clearColor].CGColor;
    }
    
}

#pragma mark - 按钮缩放方法
- (void)buttonTransform {
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/6.0 animations:^{
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/6.0 relativeDuration:1/6.0 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

#pragma mark - 画圆
- (void)drawCircle {
    /*
     *画实线圆
     */
    CAShapeLayer *solidLayer =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLayer.lineWidth = 2.0f ;
    solidLayer.strokeColor = [UIColor blackColor].CGColor; // 线的颜色
    solidLayer.fillColor = [UIColor clearColor].CGColor; // 填充颜色
    self.layer0 = solidLayer;
    CGPathAddEllipseInRect(solidPath, nil, bounds);
    solidLayer.path = solidPath;
    CGPathRelease(solidPath);
    [self.layer addSublayer:solidLayer];
}

#pragma mark - 画方形
- (void)drawRectangle {
    // 线的路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:5];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.lineWidth = 2.0f;
    pathLayer.strokeColor = [UIColor blackColor].CGColor;
    pathLayer.fillColor = [UIColor clearColor].CGColor; // 默认为blackColor
    self.layer0 = pathLayer;
    pathLayer.path = path.CGPath;
    [self.layer addSublayer:pathLayer];
}

#pragma mark - 画对号
-(void)checkAnimation:(MyOwnStyleButton *)btn{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    CAShapeLayer *shape = [CAShapeLayer layer];
    if (btn.isBtnSelected) {  // 对号出现动画
        NSLog(@"btn selected = yes 选中状态");
        CGFloat temp = frame.size.width;
        [self showLineOrHiddenLineWithUIBezierPath:path1 CAShapeLayer:shape firstPoint:CGPointMake(temp * 2.7/10, temp * 5.4/10) lastPoint:CGPointMake(temp * 7.8/10, temp * 3.8/10) lineColor:[UIColor blackColor] lineWidth:2.0];
    }
    else { // 对号消失动画
        NSLog(@"btn selected = no 未选中状态");
        CGFloat temp = frame.size.width;
        [self showLineOrHiddenLineWithUIBezierPath:path1 CAShapeLayer:shape firstPoint:CGPointMake(temp * 7.8/10, temp * 3.8/10) lastPoint:CGPointMake(temp * 2.7/10, temp * 5.4/10) lineColor:[UIColor whiteColor] lineWidth:2.5];
    }
}

#pragma mark - 对号出现或消失
- (void)showLineOrHiddenLineWithUIBezierPath:(UIBezierPath *)path CAShapeLayer:(CAShapeLayer *)shape firstPoint:(CGPoint)firstPoint lastPoint:(CGPoint)lastPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth{
    // 绘制一条折线,其实就是增加一个端点
    CGFloat temp = frame.size.width;
    [path moveToPoint:firstPoint];
    [path addLineToPoint:CGPointMake(temp * 4.5/10, temp * 7/10)];//添加一条子路径
    [path addLineToPoint:lastPoint];//添加两条子路径
    
    shape.lineWidth = lineWidth;
    shape.strokeColor = lineColor.CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.lineCap = kCALineCapRound;
    shape.lineJoin = kCALineJoinRound;
    
    shape.path = path.CGPath;
    [self.layer0 addSublayer:shape];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.1f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    [shape addAnimation:checkAnimation forKey:@"checkAnimation"];
}


@end
