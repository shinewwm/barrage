//
//  ViewController.m
//  弹幕demo
//
//  Created by 王网明 on 17/8/1.
//  Copyright © 2017年 王网明. All rights reserved.
//

#import "ViewController.h"
#import "BulletView.h"
#import "BulletManager.h"

@interface ViewController ()

@property (nonatomic, strong) BulletManager *bulManager;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1~~~~~~~~~~~~~~~~~~~~~~",@"弹幕2~~~~~~~~~~",@"弹幕3~~~~~~~~~~~~~~~",@"弹幕4",@"弹幕5~~~~~~~~~~~~~~~~~~~",@"弹幕6~~~~~~~~~~~~~~~~",@"弹幕7~~~~~~~~~~~~~~",@"弹幕8~~~~~~~~~~~",@"弹幕9~~~~~~~~~~~~~~~~~~~~~~~~~~",@"弹幕10~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",@"弹幕11~~~~~~~~~~~~~~~~"]];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bulManager = [[BulletManager alloc] init];
    __weak typeof(self) weakSelf = self;
    self.bulManager.showOnTheViewControllerBlock = ^(BulletView *bulView){
        [weakSelf addBulletViewToController:bulView];
    };
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.backgroundColor = [UIColor greenColor];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:startBtn];
    startBtn.frame = CGRectMake(50, 50, 50, 20);
    [startBtn addTarget:self action:@selector(startBarrage) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [endBtn setTitle:@"结束" forState:UIControlStateNormal];
    endBtn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:endBtn];
    endBtn.frame = CGRectMake(50, 100, 50, 20);
    [endBtn addTarget:self action:@selector(endBarrage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startBarrage{
    NSLog(@"弹幕开始了--");
    if (self.dataSource == nil || self.dataSource.count == 0) {
        return;
    }
    [self.bulManager startWithNumber:2 withbulletArray:self.dataSource];
}

- (void)endBarrage{
    NSLog(@"弹幕结束了--");
    [self.bulManager stop];
}

- (void)addBulletViewToController:(BulletView *)view{
    view.frame = CGRectMake(screenWidth, 300 + view.ballistic * 40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}

@end
