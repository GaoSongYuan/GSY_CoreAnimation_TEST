//
//  thirdViewController.m
//  scrollNumberDemo
//
//  Created by pupupula_gsy on 2018/9/17.
//  Copyright © 2018年 pupupula_gsy. All rights reserved.
//

#import "thirdViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface thirdViewController ()

- (IBAction)backBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *cyanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong)CALayer *myLayer;

@end

@implementation thirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //平移动画
//    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
//    positionAnimation.fromValue = [NSNumber numberWithDouble:0.f];
//    positionAnimation.toValue = [NSNumber numberWithDouble:SCREEN_WIDTH];
//    positionAnimation.duration = 2;
//    positionAnimation.repeatCount = MAXFLOAT;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.imageView.layer addAnimation:positionAnimation forKey:@"CQPosition"];
//    });
    
//    [self pageAnimation];
    
    //创建layer
    CALayer *myLayer=[CALayer layer];
    //设置layer的属性
    myLayer.bounds=CGRectMake(0, 0, 50, 80);
    myLayer.backgroundColor=[UIColor yellowColor].CGColor;
    myLayer.position=CGPointMake(50, 50);
    myLayer.anchorPoint=CGPointMake(0, 0);
    myLayer.cornerRadius=20;
    //添加layer
    [self.view.layer addSublayer:myLayer];
    self.myLayer=myLayer;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    // 平移 - 创建核心动画
//    CABasicAnimation *anima = [CABasicAnimation animation];
//    anima.keyPath = @"position";
//    anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
//    anima.removedOnCompletion = NO; // 不删除动画
//    anima.fillMode = kCAFillModeForwards;
//    [self.myLayer addAnimation:anima forKey:nil];
    
//    // 3D旋转
//    //1.创建动画
//    CABasicAnimation *anima=[CABasicAnimation animationWithKeyPath:@"transform"];
//    //1.1设置动画执行时间
//    anima.duration=2.0;
//    //1.2修改属性，执行动画
//    anima.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2+M_PI_4, 1, 1, 0)];
//    //1.3设置动画执行完毕后不删除动画
//    anima.removedOnCompletion=NO;
//    //1.4设置保存动画的最新状态
//    anima.fillMode=kCAFillModeForwards;
//    //2.添加动画到layer
//    [self.myLayer addAnimation:anima forKey:nil];
    
    // 关键帧动画
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(200, 100)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(200, 200)];
    NSValue *value4=[NSValue valueWithCGPoint:CGPointMake(100, 200)];
    NSValue *value5=[NSValue valueWithCGPoint:CGPointMake(100, 100)];
    keyAnima.values=@[value1,value2,value3,value4,value5];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=4.0;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.cyanImageView.layer addAnimation:keyAnima forKey:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    //平移动画
//    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
//    positionAnimation.fromValue = [NSNumber numberWithDouble:0.f];
//    positionAnimation.toValue = [NSNumber numberWithDouble:SCREEN_WIDTH];
//    positionAnimation.duration = 2;
//    positionAnimation.repeatCount = MAXFLOAT;
//    [self.imageView.layer addAnimation:positionAnimation forKey:@"CQPosition"];
}

// 缩放 + 旋转
- (void)doubleChange {
    // 缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"]; //选中的这个keyPath就是缩放
    scaleAnimation.fromValue = [NSNumber numberWithDouble:0.5]; //一开始时是0.5的大小
    scaleAnimation.toValue = [NSNumber numberWithDouble:1.5];  //结束时是1.5的大小
    scaleAnimation.duration = 1; //设置时间
    scaleAnimation.repeatCount = MAXFLOAT; //重复次数
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.imageView.layer addAnimation:scaleAnimation forKey:@"CQScale"]; //添加动画
    });
    
    //风车旋转动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithDouble:0.f];
    rotationAnimation.toValue = [NSNumber numberWithDouble:2 * M_PI];
    rotationAnimation.duration = 2.f;
    rotationAnimation.repeatCount = MAXFLOAT;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.cyanImageView.layer addAnimation:rotationAnimation forKey:@"CQRotation"];
    });
}

// 翻页动画
- (void)pageAnimation {
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.type = @"pageCurl";//翻页
    transition.repeatCount = MAXFLOAT;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.imageView.layer addAnimation:transition forKey:nil];
    });
}

// key frame 根据values移动的动画 指定path
- (void)keyFrame {
    // key frame 根据values移动的动画
    CAKeyframeAnimation *catKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint originalPoint = self.imageView.layer.frame.origin;
    CGFloat distance =  50;
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(originalPoint.x + distance, originalPoint.y + distance)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(originalPoint.x + 2 * distance, originalPoint.y + distance)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(originalPoint.x + 2 * distance, originalPoint.y +  2 * distance)];
    NSValue *value4 = [NSValue valueWithCGPoint:originalPoint];
    catKeyAnimation.values = @[value4, value1, value2, value3, value4];
    catKeyAnimation.duration = 2;
    catKeyAnimation.repeatCount = MAXFLOAT;
    catKeyAnimation.removedOnCompletion = NO;
    [self.imageView.layer addAnimation:catKeyAnimation forKey:nil];
    
    //指定path
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 200, 200, 200)];
    //指定path的动画
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(100, 100)];
    [path2 addLineToPoint:CGPointMake(100, 200)];
    [path2 addLineToPoint:CGPointMake(200, 200)];
    [path2 addLineToPoint:CGPointMake(200, 100)];
    [path2 addLineToPoint:CGPointMake(100, 100)];
    
    CAKeyframeAnimation *penguinAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    penguinAnimation.path = path2.CGPath;
    penguinAnimation.duration = 2;
    penguinAnimation.repeatCount = MAXFLOAT;
    penguinAnimation.removedOnCompletion = NO;
    [self.cyanImageView.layer addAnimation:penguinAnimation forKey:nil];
}

// 组动画
- (void)groupAnimation {
    //创建组动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 3;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.removedOnCompletion = NO;
    /* beginTime 可以分别设置每个动画的beginTime来控制组动画中每个动画的触发时间，时间不能够超过动画的时间，默认都为0.f */
    
    //缩放动画
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation1.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1.5],[NSNumber numberWithFloat:1.0]];
    animation1.beginTime = 0.f;
    
    //按照圆弧移动动画
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(300, 200)];
    [bezierPath addQuadCurveToPoint:CGPointMake(200, 300) controlPoint:CGPointMake(300, 300)];
    [bezierPath addQuadCurveToPoint:CGPointMake(100, 200) controlPoint:CGPointMake(100, 300)];
    [bezierPath addQuadCurveToPoint:CGPointMake(200, 100) controlPoint:CGPointMake(100, 100)];
    [bezierPath addQuadCurveToPoint:CGPointMake(300, 200) controlPoint:CGPointMake(300, 100)];
    animation2.path = bezierPath.CGPath;
    animation2.beginTime = 0.f;
    
    //透明度动画
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation3.fromValue = [NSNumber numberWithDouble:0.0];
    animation3.toValue = [NSNumber numberWithDouble:1.0];
    animation3.beginTime = 0.f;
    
    //添加组动画
    animationGroup.animations = @[animation1, animation2,animation3];
    [self.imageView.layer addAnimation:animationGroup forKey:nil];
    
}


// dismiss modal
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
