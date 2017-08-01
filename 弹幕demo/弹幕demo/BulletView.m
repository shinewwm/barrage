//
//  BulletView.m
//  弹幕demo
//
//  Created by 王网明 on 17/8/1.
//  Copyright © 2017年 王网明. All rights reserved.
//

#import "BulletView.h"

#define padding 10

#define PhotoHeight 30

@interface BulletView ()

@property (nonatomic, strong) UILabel *lbComment;

@property (nonatomic, strong) UIImageView *photoImage;

@end

@implementation BulletView

#pragma mark 懒加载
- (UIImageView *)photoImage{
    if (!_photoImage) {
        _photoImage = [UIImageView new];
        _photoImage.clipsToBounds = YES;
        _photoImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_photoImage];
    }
    return _photoImage;
}

- (UILabel *)lbComment{
    if (!_lbComment) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}

/**初始化*/
- (instancetype)initWithComment:(NSString *)comment{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 15;
        
        //计算弹幕的实际宽度
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [comment sizeWithAttributes:attr].width;
        
        //弹幕view的大小
        self.bounds = CGRectMake(0, 0, width + 2 * padding + PhotoHeight, 30);
        
        //弹幕的内容和大小
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(padding + PhotoHeight, 0, width, 30);
        
        self.photoImage.frame = CGRectMake(-padding, -padding, PhotoHeight + padding, PhotoHeight + padding);
        self.photoImage.layer.cornerRadius = (PhotoHeight + padding) / 2;
        self.photoImage.layer.borderColor = [UIColor orangeColor].CGColor;
        self.photoImage.layer.borderWidth = 1;
        self.photoImage.image = [UIImage imageNamed:@"1"];
    }
    return self;
}

//开始动画
- (void)startAnimation{
    
    //根据弹幕的长度执行动画效果
    //根据 v = s / t
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    if (self.moveStauteBlock) {
        self.moveStauteBlock(Start);
    }
    //计算完全进入的时间
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDuration =CGRectGetWidth(self.bounds) / speed;
    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStauteBlock) {
            self.moveStauteBlock(End);
        }
    }];
}

- (void)enterScreen{
    if (self.moveStauteBlock) {
        self.moveStauteBlock(Enter);
    }
}

//结束动画
- (void)endAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

@end
