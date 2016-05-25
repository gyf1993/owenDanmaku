//
//  ViewController.m
//  owenDanmaku
//
//  Created by gyf on 16/5/6.
//  Copyright © 2016年 owen. All rights reserved.
//

#import "ViewController.h"
#import "DanmakuView.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface ViewController ()
{
    DanmakuView *_danmakuView;
    NSTimer *_timer;
    NSArray *_array;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _array = @[@"说不出再见",@"6666666666666",@"hello danmaku",@"10 owen wow!!!",@"england",@"这场伟大的比赛",@"30年莱斯特城死忠路过。。。",@"这场比赛太精彩",@"切尔西进球了",@"哈利路亚"];
    
    _danmakuView = [[DanmakuView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_danmakuView];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    btn.frame= CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT - 60, 100, 40);
    [btn setTitle:@"send" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(sendAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sendDanmaku) userInfo:nil repeats:YES];
}
- (void)sendDanmaku
{
    for (int i=0; i<6; i++) {
        int k = rand()%10;
        [_danmakuView addDanmaku:_array[k]];
    }
}
- (void)sendAction
{
    [_danmakuView addDanmaku:@"send a danmaku"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
