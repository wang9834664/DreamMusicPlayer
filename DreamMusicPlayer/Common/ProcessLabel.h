//
//  ProcessLabel.h
//  TestHighLightLabel
//
//  Created by 王 越红 on 12-12-18.
//  Copyright (c) 2012年 cienet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessLabel : UIView
{
    //当前行歌词
    NSString *message_;
    //定时器
    NSTimer *timer_;
    //当前行播放时间
    float playTime_;
    //总进度
    int totalLength_;
    //当前进度
    int currentLength_;
    //进度scroll
    UIScrollView *labelScrollView_;
    //parent view
    UIView *parentView_;
}
@property (nonatomic, copy)NSString *message;
@property (nonatomic, assign)float playTime;
@property (nonatomic, retain)UIScrollView *labelScrollView;
@property (nonatomic, retain)UIView *parentView;

//停止或者播放音乐时显示播放进度
- (void)startProcess;
//手动拖动到某个位置播放音乐时显示播放进度
- (void)startProcessWithTime:(float)startTime;
//暂停播放并返回播放进度
- (float)pauseProcess;
//停止播放进度
- (void)stopProcess;
//重新播放
- (void)reStartProcess;

@end
