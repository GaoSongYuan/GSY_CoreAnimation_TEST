//
//  fourthViewController.m
//  scrollNumberDemo
//
//  Created by pupupula_gsy on 2018/9/26.
//  Copyright © 2018年 pupupula_gsy. All rights reserved.
//
//  立体旋转图片动画

#import "fourthViewController.h"

@interface fourthViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property(nonatomic,assign) int index;

@end

@implementation fourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 1;
}

// 上一张图片
- (IBAction)preAction:(id)sender {
    self.index--;
    if (self.index < 1) {
        self.index = 7;
    }
    self.imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"%d.jpg",self.index]];
    
    //创建核心动画
    CATransition *ca = [CATransition animation];
    //告诉要执行什么动画
    //设置过度效果
    ca.type = @"cube";
    //设置动画的过度方向（向左）
    ca.subtype = kCATransitionFromLeft;
    //设置动画的时间
    ca.duration = 2.0;
    //添加动画
    [self.imageView.layer addAnimation:ca forKey:nil];
}

// 下一张图片
- (IBAction)nextImageAction:(id)sender {
    self.index++;
    if (self.index > 7) {
         self.index = 1;
     }
     self.imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"%d.jpg",self.index]];

    //1.创建核心动画
    CATransition *ca = [CATransition animation];

    //1.1告诉要执行什么动画
    //1.2设置过度效果
    ca.type = @"cube";
    //1.3设置动画的过度方向（向右）
    ca.subtype = kCATransitionFromRight;
    //1.4设置动画的时间
    ca.duration = 2.0;
    //1.5设置动画的起点
    ca.startProgress = 0;
    //1.6设置动画的终点
    //    ca.endProgress=0.5;

    //2.添加动画
    [self.imageView.layer addAnimation:ca forKey:nil];
}





- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
