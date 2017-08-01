//
//  BulletManager.h
//  弹幕demo
//
//  Created by 王网明 on 17/8/1.
//  Copyright © 2017年 王网明. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BulletView;

@interface BulletManager : NSObject

@property (nonatomic, copy) void(^showOnTheViewControllerBlock)(BulletView *view);

- (void)startWithNumber:(NSInteger)num withbulletArray:(NSMutableArray *)bulletArray;

- (void)stop;

@end
