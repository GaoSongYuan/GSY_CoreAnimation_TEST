//
//  NumberScrollView.m
//  scrollNumberDemo
//
//  Created by pupupula_gsy on 2018/8/29.
//  Copyright © 2018年 pupupula_gsy. All rights reserved.
//

#import "NumberScrollView.h"

#define JFLog(format,...) printf("%s 第%d行 %s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])

@interface NumberScrollView() {
    NSMutableArray *numbersText;
    NSMutableArray *numbersTextNew; // new
    NSMutableArray *scrollLayers;
    NSMutableArray *scrollLabels;
}

/*
 @property (strong, nonatomic) NSNumber *value;
 
 @property (strong, nonatomic) UIColor *textColor;
 @property (strong, nonatomic) UIFont *font;
 @property (assign, nonatomic) CFTimeInterval duration;
 @property (assign, nonatomic) CFTimeInterval durationOffset;
 @property (assign, nonatomic) NSUInteger density; // 密度
 @property (assign, nonatomic) NSUInteger minLength;
 @property (assign, nonatomic) BOOL isAscending; // 上升
 
 - (void)startAnimation;
 - (void)stopAnimation;
 */

@end

@implementation NumberScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self commonInit];
    return self;
}

- (void)commonInit {
    self.duration = 1.5;
    self.durationOffset = .2;
    self.density = [self.value000new integerValue] - [self.value integerValue]; // 滚动的数字的密度 5
    self.minLength = 0;
    self.isAscending = NO; // 默认不是上升
    
    self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.textColor = [UIColor blackColor];
    
    numbersText = [NSMutableArray new];
    numbersTextNew = [NSMutableArray new]; // new
    scrollLayers = [NSMutableArray new];
    scrollLabels = [NSMutableArray new];
}

#pragma mark - setValue 设置数字的值 - prepareAnimations
- (void)setValue:(NSNumber *)value { // 旧值
    _value = value;
//    [self prepareAnimations];
}
- (void)setValue000new:(NSNumber *)value000new { // new
    _value000new = value000new;
}

#pragma mark - 开始动画 跳转到准备动画+创建动画
- (void)startAnimation {
    [self prepareAnimations];
    [self createAnimations];
}

#pragma mark - 结束动画
- (void)stopAnimation {
    for(CALayer *layer in scrollLayers){
        // MARK: 根据key移除layer动画
        [layer removeAnimationForKey:@"NumberScrollAnimatedView"];
    }
}

#pragma mark - 准备动画
- (void)prepareAnimations {
    // 先删除所有的元素
    for(CALayer *layer in scrollLayers){
        [layer removeFromSuperlayer];
    }
    [numbersText removeAllObjects];
    [numbersTextNew removeAllObjects]; // new
    [scrollLayers removeAllObjects];
    [scrollLabels removeAllObjects];
    
    // MARK: 先删除所有的元素，在进行创建数字text、创建滚动layer
    [self createNumbersText];
    [self createScrollLayers];
}

#pragma mark - 创建数字text
- (void)createNumbersText {
    NSString *textValue = [self.value stringValue]; // 原本出现的数字
    NSString *textValueNew = [self.value000new stringValue]; // 将要出现的最终数字
    
    NSInteger temp = (NSInteger)self.minLength - (NSInteger)[textValue length]; // 所设定的最小长度 与 出现数字的长度 的差值
    for (NSInteger i = 0; i < temp; i++) {
        [numbersText addObject:@"0"]; // 如果有差值，用0补位
    }
    for (NSUInteger i = 0; i < [textValue length]; i++) {
        [numbersText addObject:[textValue substringWithRange:NSMakeRange(i, 1)]]; // 截取字符串添加到 numbersText (每一个数字放入到numbersText中)
    }
    
    JFLog(@"numbersText = %@",numbersText);
    
//    NSInteger temp1 = (NSInteger)self.minLength - (NSInteger)[textValueNew length]; // 所设定的最小长度 与 出现数字的长度 的差值
//    for (NSInteger i = 0; i < temp1; i++) {
//        [numbersTextNew addObject:@"0"]; // 如果有差值，用0补位
//    }
//    for (NSUInteger i = 0; i < [textValueNew length]; i++) {
//        [numbersTextNew addObject:[textValueNew substringWithRange:NSMakeRange(i, 1)]]; // 截取字符串添加到 numbersText (每一个数字放入到numbersText中)
//    }
//    JFLog(@"numbersTextNew = %@",numbersTextNew);
}

#pragma mark - 创建滚动layer
- (void)createScrollLayers {
    CGFloat width = roundf(CGRectGetWidth(self.frame) / numbersText.count); // 四舍五入 每一个数字的宽度
    CGFloat height = CGRectGetHeight(self.frame);
    
    // 设置滑动图层
    for(NSUInteger i = 0; i < numbersText.count; ++i){
        CAScrollLayer *layer = [CAScrollLayer layer];
        layer.frame = CGRectMake(roundf(i * width), 0, width, height);
        [scrollLayers addObject:layer];
        [self.layer addSublayer:layer];
    }
    
    for(NSUInteger i = 0; i < numbersText.count; ++i){
        CAScrollLayer *layer = scrollLayers[i];
        NSString *numberText = numbersText[i];
//        NSString *numberText = numbersTextNew[i];
        [self createContentForLayer:layer withNumberText:numberText];
    }
}

#pragma mark - createContentForLayer
// 根据每一个数字，创建对应的滑动图层，会多次调用
- (void)createContentForLayer:(CAScrollLayer *)scrollLayer withNumberText:(NSString *)numberText {
    NSInteger number = [numberText integerValue]; // 拿到数字
    NSMutableArray *textForScorll = [NSMutableArray new]; // 存放用来滚动的垃圾数字
    
    for (NSUInteger i = 0; i < self.density + 1; i++) { // self.density 滚动的数字的密度
        [textForScorll addObject:[NSString stringWithFormat:@"%lu",(number + i) % 10]];
    }
    
    [textForScorll addObject:numberText]; // 放入最终的需要显示的正确数字
    
    if (!self.isAscending) {
        // 逆向遍历数组 ??? 
        textForScorll = [[[textForScorll reverseObjectEnumerator] allObjects] mutableCopy];
    }
    
    CGFloat height = 0;
    for (NSString *text in textForScorll) {
        UILabel *textLabel = [self createLabel:text];
        textLabel.frame = CGRectMake(0, height, CGRectGetWidth(scrollLayer.frame), CGRectGetHeight(scrollLayer.frame));
        [scrollLayer addSublayer:textLabel.layer];
        [scrollLabels addObject:textLabel];
        height = CGRectGetMaxY(textLabel.frame);
    }
}

#pragma mark - 创建label - 设置label字体等属性
- (UILabel *)createLabel:(NSString *)text {
    UILabel *view = [UILabel new];
    view.textColor = self.textColor;
    view.font = self.font;
    view.textAlignment = NSTextAlignmentCenter;
    
    view.text = text;
    
    return view;
}

#pragma mark - 创建动画
- (void)createAnimations {
    CFTimeInterval duration = self.duration - ([numbersText count] * self.durationOffset);
    CFTimeInterval offset = 0;
    
    for(CALayer *scrollLayer in scrollLayers){
        CGFloat maxY = [[scrollLayer.sublayers lastObject] frame].origin.y;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
        animation.duration = duration + offset;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        if(self.isAscending){
            animation.fromValue = [NSNumber numberWithFloat:-maxY];
            animation.toValue = @0;
        }
        else{
            animation.fromValue = @0;
            animation.toValue = [NSNumber numberWithFloat:-maxY];
        }
        
        [scrollLayer addAnimation:animation forKey:@"JTNumberScrollAnimatedView"];
        
        offset += self.durationOffset;
    }
}

@end















