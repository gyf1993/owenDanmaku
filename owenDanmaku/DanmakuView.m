//
//  DanmakuView.m
//  owenDanmaku
//
//  Created by gyf on 16/5/24.
//  Copyright © 2016年 owen. All rights reserved.
//

#import "DanmakuView.h"
#define DanmakuTime 5
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface DanmakuView()
{
    NSMutableArray *_channelArray;
    NSInteger _channelCount;
}
@end
@implementation DanmakuView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        _channelArray = [NSMutableArray new];
        _channelCount = (NSInteger)((SCREEN_HEIGHT - 50)/40);
        for (int i =0; i<_channelCount; i++) {
            NSNumber *number = [NSNumber numberWithBool:YES];
            [_channelArray setObject:number atIndexedSubscript:i];
        }
    }
    return self;
}
- (void)addDanmaku:(NSString *)text
{
    NSDictionary *dictAttribute = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictAttribute context:nil];
    CGFloat width = (int)rect.size.width + 1;
    UILabel *newBullet = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, width, 40)];
    newBullet.text = text;
    newBullet.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    int i = 0;
    for (i = 0; i<_channelArray.count; i++) {
        NSObject *object = _channelArray[i];
        if ([object isKindOfClass:[NSNumber class]]) {
            [self addSubview:newBullet];
            [_channelArray setObject:newBullet atIndexedSubscript:i];
            newBullet.frame = CGRectMake(SCREEN_WIDTH,  i * 40, width, 40);
            //UIViewAnimationOptionCurveLinear使整个动画过程匀速进行
            [UIView animateWithDuration:DanmakuTime delay:0 options:(UIViewAnimationOptionCurveLinear) animations:^{
                newBullet.frame = CGRectMake(0 - width,  i * 40,width, 40);
            } completion:^(BOOL finished) {
                [newBullet removeFromSuperview];
            }];
            break;
        }else if ([object isKindOfClass:[UILabel class]])
        {
            UILabel *bullet = (UILabel*)object;
            if ([self canBulletSendInTheChannel:bullet newBullet:newBullet]) {
                [self addSubview:newBullet];
                [_channelArray setObject:newBullet atIndexedSubscript:i];
                newBullet.frame = CGRectMake(SCREEN_WIDTH,  i * 40, width, 40);
                [UIView animateWithDuration:DanmakuTime delay:0 options:(UIViewAnimationOptionCurveLinear) animations:^{
                    newBullet.frame = CGRectMake(0 - width, i * 40,width, 40);
                } completion:^(BOOL finished) {
                    [newBullet removeFromSuperview];
                }];
                break;
            }
        }
    }
}
//判断弹幕是否碰撞方法
- (BOOL)canBulletSendInTheChannel:(UILabel *)bullet newBullet:(UILabel *)newBullet
{
    //获取动画中，控件的frame
    CGRect rect = [bullet.layer.presentationLayer frame];
    if (rect.origin.x>SCREEN_WIDTH - bullet.frame.size.width) {
        //弹道当前弹幕还没完全显示在屏幕中，返回NO
        return NO;
    }else if (rect.size.width == 0)
    {
        //刚刚添加的控件，有可能取到frame的值全为0，也要返回NO
        return NO;
    }
    else if (bullet.frame.size.width > newBullet.frame.size.width) {
        //排除了以上两种情况，比较弹幕的宽度（也就是比较速度）,新弹幕宽度小也就是永远追不上上一条弹幕,返回YES
        return YES;
    }else
    {
        //time为新弹幕从出现到屏幕最左边的时间（此时弹幕整体都在屏幕内，并不是弹幕消失的时间）
        CGFloat time = SCREEN_WIDTH/(SCREEN_WIDTH+newBullet.frame.size.width)*DanmakuTime;
        //endX为此时老弹幕的frame的x值
        CGFloat endX = rect.origin.x - time/DanmakuTime*(SCREEN_WIDTH + bullet.frame.size.width);
        if (endX < -bullet.frame.size.width) {
            //若此时老弹幕已经完全从屏幕中消失，返回YES
            return YES;
        }
    }
    return NO;
}
@end
