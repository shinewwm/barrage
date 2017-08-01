//
//  BulletView.h
//  弹幕demo
//
//  Created by 王网明 on 17/8/1.
//  Copyright © 2017年 王网明. All rights reserved.
//

#import <UIKit/UIKit.h>
#define screenWidth [UIScreen mainScreen].bounds.size.width

typedef NS_ENUM(NSInteger, MoveStatus){
    Start,
    Enter,
    End
};

@interface BulletView : UIView

/**弹道*/
@property (nonatomic,assign) int ballistic;

/**弹幕状态回调*/
@property (copy, nonatomic) void(^moveStauteBlock)(MoveStatus status);

/**初始化comment*/
- (instancetype)initWithComment:(NSString *)comment;

/**开始动画*/
- (void)startAnimation;

/**结束动画*/
- (void)endAnimation;

@end
