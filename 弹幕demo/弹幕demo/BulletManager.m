//
//  BulletManager.m
//  弹幕demo
//
//  Created by 王网明 on 17/8/1.
//  Copyright © 2017年 王网明. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager ()

//数据源
@property (strong, nonatomic) NSMutableArray *dataSource;

//弹幕使用过程中的数组变量
@property (nonatomic, strong) NSMutableArray *inUseSource;

//屏幕里出现的滚动弹幕View数组
@property (nonatomic, strong) NSMutableArray *bulletViews;

//停止动画
@property (nonatomic,assign) BOOL bStopAnimation;

//弹道行数
@property (nonatomic,assign) NSInteger bulletNum;

@end

@implementation BulletManager

#pragma mark 懒加载

- (instancetype)init{
    if (self = [super init]) {
        self.bStopAnimation = YES;
    }
    return self;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)inUseSource{
    if (!_inUseSource) {
        _inUseSource = [NSMutableArray array];
    }
    return _inUseSource;
}

- (NSMutableArray *)bulletViews{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

- (void)startWithNumber:(NSInteger)num withbulletArray:(NSMutableArray *)bulletArray{
    if (!self.bStopAnimation) {
        return;
    }
    self.bulletNum = num;
    [self.dataSource addObjectsFromArray:bulletArray];
    self.bStopAnimation = NO;
    [self.inUseSource removeAllObjects];
    [self.inUseSource addObjectsFromArray:self.dataSource];
    
    [self initButtleComment:num];
}

/**初始化弹幕(弹道)*/
- (void)initButtleComment:(NSInteger)num{
//    NSMutableArray *ballisticArray = [NSMutableArray arrayWithArray:@[@(0), @(1), @(2)]];
    NSMutableArray *ballisticArray = [NSMutableArray array];
    for (int i = 0; i < (int)num; i++) {
        [ballisticArray addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < num; i++) {
        if (self.inUseSource > 0) {
            //通过随机数获取弹幕轨迹
            NSInteger index = arc4random()%ballisticArray.count;
            int ballistic = [[ballisticArray objectAtIndex:index] intValue];
            [ballisticArray removeObjectAtIndex:index];
            
            NSString *comment = [self.inUseSource firstObject];
            [self.inUseSource removeObjectAtIndex:0];
            
            [self creatBulletView:comment ballistic:ballistic];
        }
    }
}

- (void)creatBulletView:(NSString *)comment ballistic:(int)ballistic{
    if (self.bStopAnimation) {
        return;
    }
    BulletView *bView = [[BulletView alloc] initWithComment:comment];
    bView.ballistic = ballistic;
    
    __weak typeof (bView) weakView = bView;
    __weak typeof (self) weakSelf = self;
    bView.moveStauteBlock = ^(MoveStatus status){
        if (self.bStopAnimation) {
            return ;
        }
        switch (status) {
            case Start:{
                //弹幕开始进入屏幕
                [weakSelf.bulletViews addObject:weakView];
                break;
            }
            case Enter:{
                //弹幕完全进入屏幕，判断是否还有未显示的弹幕
                NSString *comment = [weakSelf nextComment];
                if (comment) {
                    [weakSelf creatBulletView:comment ballistic:ballistic];
                }
                break;
            }
            case End:{
                //飞出屏幕，删除释放内存
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView endAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                
                if (weakSelf.bulletViews.count == 0) {
                    //说明屏幕上已经没有弹幕
                    self.bStopAnimation = YES;
                    [weakSelf startWithNumber:self.bulletNum withbulletArray:self.dataSource];
                }
                
                break;
            }
            default:
                break;
        }
    };
    if (self.showOnTheViewControllerBlock) {
        self.showOnTheViewControllerBlock(bView);
    }
}

- (NSString *)nextComment{
    if (self.inUseSource.count == 0) {
        return nil;
    }
    NSString *comment = [self.inUseSource firstObject];
    if (comment) {
        [self.inUseSource removeObjectAtIndex:0];
    }
    return comment;
}

- (void)stop{
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view endAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

@end
