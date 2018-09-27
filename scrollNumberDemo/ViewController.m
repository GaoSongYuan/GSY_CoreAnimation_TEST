//
//  ViewController.m
//  scrollNumberDemo
//
//  Created by pupupula_gsy on 2018/8/28.
//  Copyright © 2018年 pupupula_gsy. All rights reserved.
//

#import "ViewController.h"
#import "DPScrollNumberLabel.h"

#import "NumberScrollView.h"

#import "MyOwnStyleButton.h"

static NSInteger number = 6;
static CGRect frame;

@interface ViewController () // <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) DPScrollNumberLabel *scrollLabel;
//@property (nonatomic,strong) NumberScrollView *scrollView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *bagView;
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,assign) BOOL isSelect;

@property (nonatomic, strong) MyOwnStyleButton *myButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isSelect = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 100, 300, 90)];
    scrollView.backgroundColor = [UIColor cyanColor];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * 50);
    
    for (int i = 0; i < 50; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, i * 90, 100, 90);
        label.backgroundColor = [UIColor yellowColor];
        label.text = [NSString stringWithFormat:@"%d",i];
        [scrollView addSubview:label];
    }
    
    self.scrollView = scrollView;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentOffset = CGPointMake(0, number * 90); // 默认显示
    
    
    
    // 按钮图片
    self.btn.adjustsImageWhenHighlighted = NO; // 取消高亮
    frame = self.btn.frame;
    [self.btn addTarget:self action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
    [self.btn addTarget:self action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    // 自定义button
    self.myButton.titleLabel.text = @"123";
    self.myButton.titleLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.myButton];
}

- (MyOwnStyleButton *)myButton {
    if (!_myButton) {
        _myButton = [[MyOwnStyleButton alloc] initWithFrame:CGRectMake(100, 300, 180, 30) type:CircleButtonWithoutLabel];
    }
    return _myButton;
}

#pragma mark - 数字转动
- (IBAction)add2:(id)sender {
    [self addWith:3];
}
- (IBAction)add5:(id)sender {
    [self addWith:7];
}
- (IBAction)reduce2:(id)sender {
    [self addWith:-2];
}
- (IBAction)reduce5:(id)sender {
    [self addWith:-5];
}

- (void)addWith:(NSInteger)add {
    number = number + add;
    CGFloat offsetY = number * 90;
    if (offsetY >= self.scrollView.contentSize.height || offsetY <= 0) {
        offsetY = 0;
        number = 0;
    }
    [UIView animateWithDuration:0.75 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, offsetY);
    }];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    number--;
//    CGFloat offsetY = number * 90;
//    if (offsetY >= self.scrollView.contentSize.height || offsetY <= 0) {
//        offsetY = 0;
//        number = 0;
//    }
//
//    [UIView animateWithDuration:0.75 animations:^{
//        self.scrollView.contentOffset = CGPointMake(0, offsetY);
//    }];
//}

#pragma mark - 选中动画
//按钮的按下事件 按钮缩小
- (void)pressedEvent:(UIButton *)btn {
    [self changeBtnWith:-5];
    
    [self checkAnimation:btn];
}
//按钮的松开事件 按钮复原 执行响应
- (void)unpressedEvent:(UIButton *)btn {
    [self changeBtnWith:5];
}

// 按钮缩放方法
- (void)changeBtnWith:(NSInteger)changeNum {
    CGPoint center = self.btn.center;
    CGFloat w = self.btn.frame.size.width;
    CGFloat h = self.btn.frame.size.height;
    [UIView animateWithDuration:0.01 animations:^{
        CGRect frame = self.btn.frame;
        frame.size = CGSizeMake(w + changeNum, h + changeNum);
        self.btn.frame = frame;
        
        CGPoint center1 = self.btn.center;
        center1.x = center.x;
        center1.y = center.y;
        self.btn.center = center1;
    }];
}

// 画圆


// 画方形

// 画对号
-(void)checkAnimation:(UIButton *)btn{
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    CAShapeLayer *shape = [CAShapeLayer layer];
    
    self.btn.selected = !self.btn.selected;
    if (btn.selected) {
        NSLog(@"btn selected = yes 选中状态");
        
        // 绘制一条折线,其实就是增加一个端点
        CGFloat temp = frame.size.width;
        [path1 moveToPoint:CGPointMake(temp * 2.7/10, temp * 5.4/10)];
        [path1 addLineToPoint:CGPointMake(temp * 4.5/10, temp * 7/10)];//添加一条子路径
        [path1 addLineToPoint:CGPointMake(temp * 7.8/10, temp * 3.8/10)];//添加两条子路径
        
        shape.lineWidth = 2;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.strokeColor = [UIColor blackColor].CGColor;
        shape.lineCap = kCALineCapRound;
        shape.lineJoin = kCALineJoinRound;
        
        shape.path = path1.CGPath;
        [self.btn.layer addSublayer:shape];
        
        CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        checkAnimation.duration = 0.5f;
        checkAnimation.fromValue = @(0.0f);
        checkAnimation.toValue = @(1.0f);
        //    checkAnimation.delegate = self.view;
        [shape addAnimation:checkAnimation forKey:@"checkAnimation"];
        
    }
    else {
        NSLog(@"btn selected = no 未选中状态");
        path1 = nil;
        [shape removeAllAnimations];
        [shape removeFromSuperlayer];
    }

//    // 绘制一条折线,其实就是增加一个端点
//    UIBezierPath *path1 = [UIBezierPath bezierPath];
//    CGFloat temp = self.btn.bounds.size.width;
//    [path1 moveToPoint:CGPointMake(temp * 2.7/10, temp * 5.4/10)];
//    [path1 addLineToPoint:CGPointMake(temp * 4.5/10, temp * 7/10)];//添加一条子路径
//    [path1 addLineToPoint:CGPointMake(temp * 7.8/10, temp * 3.8/10)];//添加两条子路径
//
////    [path1 moveToPoint:CGPointMake(10, 12)];
////    [path1 addLineToPoint:CGPointMake(15, 15)];//添加一条子路径
////    [path1 addLineToPoint:CGPointMake(30, 10)];//添加两条子路径
//
//    CAShapeLayer *shape = [CAShapeLayer layer];
//
//    shape.lineWidth = 2;
//    shape.fillColor = [UIColor clearColor].CGColor;
//    shape.strokeColor = [UIColor blackColor].CGColor;
//    shape.lineCap = kCALineCapRound;
//    shape.lineJoin = kCALineJoinRound;
//
//    shape.path = path1.CGPath;
//    [self.btn.layer addSublayer:shape];
//
//    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    checkAnimation.duration = 0.01f;
//    checkAnimation.fromValue = @(0.0f);
//    checkAnimation.toValue = @(1.0f);
////    checkAnimation.delegate = self.view;
//    [shape addAnimation:checkAnimation forKey:@"checkAnimation"];
    
    
}





@end
