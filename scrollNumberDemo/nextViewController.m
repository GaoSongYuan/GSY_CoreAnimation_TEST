//
//  nextViewController.m
//  scrollNumberDemo
//
//  Created by pupupula_gsy on 2018/8/31.
//  Copyright © 2018年 pupupula_gsy. All rights reserved.
//

#import "nextViewController.h"

static CGRect frame;

static NSInteger number = 2;
//static NSInteger number;
//static NSInteger times = 5;

@interface nextViewController ()
@property (nonatomic,strong) UIView *bagView;
@property (nonatomic,strong) UIView *scrollView;
@property (nonatomic,strong) NSMutableArray *labelArray;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CAShapeLayer *layer;

@property (nonatomic, strong) UIButton *nextButton;
@end

@implementation nextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bagView = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 100, 300, 90)];
    self.bagView.backgroundColor = [UIColor cyanColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 105, 90 * 5)];
    self.scrollView.backgroundColor = [UIColor redColor];

    self.labelArray = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, i * 90, 100, 90);
        label.backgroundColor = [UIColor yellowColor];
        label.text = [NSString stringWithFormat:@"%d",i];
        [self.labelArray addObject:label];
        [self.scrollView addSubview:label];
    }
    
    [self.bagView addSubview:self.scrollView];
    [self.view addSubview:self.bagView];
    
    // 默认显示中间的 即第二个label
    CGRect frame = self.scrollView.frame;
    frame.origin.y = -number * 90;
    self.scrollView.frame = frame;
    
    
    // 添加按钮
    [self.view addSubview:self.button];
//    [self.button.imageView addSubview:<#(nonnull UIView *)#>]
//    [self drawCircle]; // 画矩形
}

- (void)change:(NSInteger)time {
    CGFloat offsetY = 90;
    NSLog(@"time = %ld",time);

    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         // 全部label上移 offsetY
                         for (int i = 0; i < self.labelArray.count; i++) {
                             UILabel *tempLabel = self.labelArray[i];
                             CGRect frame = tempLabel.frame;
                             frame.origin.y = tempLabel.frame.origin.y - offsetY;
                             tempLabel.frame = frame;
                         }
                     }
                     completion:^(BOOL finished) {
                         
                         [self.labelArray removeObjectAtIndex:0];
                         [self.labelArray[0] removeFromSuperview];
                         
                         UILabel *temp = [self.labelArray lastObject];
                         UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, temp.frame.origin.y + temp.frame.size.height, temp.frame.size.width, temp.frame.size.height)];
                         tempLabel.backgroundColor = [UIColor greenColor];
                         tempLabel.text = @"999";
                         [self.scrollView addSubview:tempLabel];
                         [self.labelArray addObject:tempLabel];
                         
                         // 递归
                         if (time <= 1) {
                             return;
                         } else {
                             [self change:time - 1];
                         }
                     }];
    
    NSLog(@"%@",self.labelArray);
}


#pragma mark - 选中动画
#pragma mark - 懒加载
- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 80, 80)];
        _button.adjustsImageWhenHighlighted = NO; // 取消高亮
        [_button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        frame = _button.frame;
        _button.imageView.frame = _button.frame;
        [self drawCircle]; // 画圆
//        [self drawRectangle]; // 画矩形
    }
    return _button;
}
//- (UIButton *)nextButton {
//    if (!_button) {
//        _button = [UIButton alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
//    }
//}

#pragma mark - 按钮点击
- (void)buttonClickAction:(UIButton *)sender {
    NSLog(@" - click - ");
    [self buttonTransform]; // 按钮缩放
    self.button.selected = !self.button.selected;
    if (sender.selected) { // 选中状态
        self.layer.fillColor = [UIColor colorWithRed:255.0/255.0 green:225.0/255.0 blue:38.0/255.0 alpha:1].CGColor;
    } else { // 未选中状态
        self.layer.fillColor = [UIColor clearColor].CGColor;
    }
    [self checkAnimation:sender]; // 对号出现消失动画
}

#pragma mark - 按钮缩放方法
- (void)buttonTransform {
    self.button.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/6.0 animations:^{
            self.button.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/6.0 relativeDuration:1/6.0 animations:^{
            self.button.transform = CGAffineTransformMakeScale(1.0, 1.0);
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
    self.layer = solidLayer;
    CGPathAddEllipseInRect(solidPath, nil, self.button.bounds);
    solidLayer.path = solidPath;
    CGPathRelease(solidPath);
    [self.button.layer addSublayer:solidLayer];
}

#pragma mark - 画方形
- (void)drawRectangle {
    // 线的路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.button.bounds cornerRadius:5];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.lineWidth = 2.0f;
    pathLayer.strokeColor = [UIColor blackColor].CGColor;
    pathLayer.fillColor = [UIColor clearColor].CGColor; // 默认为blackColor
    self.layer = pathLayer;
    pathLayer.path = path.CGPath;
    [self.button.layer addSublayer:pathLayer];
}

#pragma mark - 画对号
-(void)checkAnimation:(UIButton *)btn{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    CAShapeLayer *shape = [CAShapeLayer layer];
    if (btn.selected) {  // 对号出现动画
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
    [self.button.layer addSublayer:shape];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.1f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    [shape addAnimation:checkAnimation forKey:@"checkAnimation"];
}





- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
