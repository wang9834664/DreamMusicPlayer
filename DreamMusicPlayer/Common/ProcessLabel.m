//
//  ProcessLabel.m
//  TestHighLightLabel
//
//  Created by 王 越红 on 12-12-18.
//  Copyright (c) 2012年 cienet. All rights reserved.
//

#import "ProcessLabel.h"
#import "MyMusicUtil.h"
@interface ProcessLabel(privite)
//初始化进度
- (void)initProcess;
//开始定时器
- (void)startTimer;
//停止定时器
- (void)stopTimer;
//重绘
-(void)reDrawScrollView;
@end
@implementation ProcessLabel
@synthesize message = message_;
@synthesize labelScrollView = labelScrollView_;
@synthesize parentView = parentView_;
@synthesize playTime = playTime_;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = 1001;
    }
    return self;
}
- (void)dealloc
{
    [message_ release];
    message_ = nil;    
    [labelScrollView_ release];
    labelScrollView_ = nil;
    [parentView_ release];
    parentView_ = nil;
    //停止定时器
    [self stopTimer];
    [super dealloc];
}
//初始化进度
- (void)initProcess
{
    
    
    UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, totalLength_, self.frame.size.height)];
    [textField setBackgroundColor:[UIColor clearColor]];
    textField.textColor = [UIColor blueColor];
    textField.text = self.message;
    textField.font = DEFAULT_FONT;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, currentLength_, self.frame.size.height)];
    
    scrollView.scrollEnabled = NO;
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:textField];
    [textField release];
    
    self.labelScrollView = scrollView;
    [scrollView release];
    
    [self.parentView addSubview:self.labelScrollView];
}
//开始定时器
- (void)startTimer{
     timer_ = [NSTimer scheduledTimerWithTimeInterval:playTime_ / totalLength_ target:self selector:@selector(reDrawScrollView) userInfo:NO repeats:YES];
}
//停止定时器
- (void)stopTimer{
    if (timer_ && [timer_ isValid]) {
        [timer_ invalidate];
        timer_ = nil;
    }
}
//停止或者播放音乐时显示播放进度
- (void)startProcess{
    
    CGSize size = [self.message sizeWithFont:DEFAULT_FONT];
    totalLength_ = size.width;
    currentLength_ = 1;
    [self initProcess];
    
    //停止定时器
    [self stopTimer];
    
    //开始定时器
    [self startTimer];   
}
//手动拖动到某个位置播放音乐时显示播放进度
- (void)startProcessWithTime:(float)startTime{ 
    
    CGSize size = [self.message sizeWithFont:DEFAULT_FONT];
    totalLength_ = size.width;
    currentLength_ = (startTime / playTime_) * totalLength_;
    [self initProcess];    
}
//重绘
-(void)reDrawScrollView
{
    if (currentLength_ >= totalLength_) {
        [self.labelScrollView removeFromSuperview];
        //停止定时器
        [self stopTimer];
        return;
    }
    currentLength_++;
    self.labelScrollView.frame = CGRectMake(0, 0, currentLength_, self.frame.size.height);
}
//暂停播放并返回播放进度
- (float)pauseProcess{
    //停止定时器
    [self stopTimer];
    return (float)(totalLength_ - currentLength_) * (playTime_ / totalLength_);
}
//重新播放
- (void)reStartProcess{
    //开始定时器
    [self startTimer];
}
//停止播放进度
- (void)stopProcess{
    [self.labelScrollView removeFromSuperview];
    //停止定时器
    [self stopTimer];
}

@end
