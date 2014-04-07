//
//  ViewController.m
//  DreamMusicPlayer
//
//  Created by 越红 王 on 12-12-22.
//  Copyright (c) 2012年  cienet. All rights reserved.
//

#import "ViewController.h"
#import "ProcessLabel.h"
#import "MyMusicUtil.h"
#import <AudioToolbox/AudioToolbox.h>
#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface ViewController()
//初始化播放按钮
- (void)initPlayAndPauseButton;
//初始化拖动时间线
- (void)initDraggingTimeLine;
//初始化歌词显示的view
- (void)initLyricsScrollView;
//如果之前是音乐播放状态则继续播放
- (void)continuePlayMuisc;
@end

@implementation ViewController
@synthesize tmpPlayer = tmpPlayer_;
@synthesize processLabel = processLabel_;
@synthesize playOrPauseButton = playOrPauseButton_;
@synthesize lyricsScrollView = lyricsScrollView_;
@synthesize timeLineView = timeLineView_;
@synthesize musicObject = musicObject_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
    self.lyricsScrollView = nil;
    self.processLabel = nil;
    self.playOrPauseButton = nil;
    self.timeLineView = nil;
    self.musicObject = nil;
    [super viewDidUnload];
}

- (void)dealloc{
    self.lyricsScrollView = nil;
    self.processLabel = nil;
    self.playOrPauseButton = nil;
    self.timeLineView = nil;
    self.musicObject = nil;
    [super dealloc];
}
//初始化播放按钮
- (void)initPlayAndPauseButton{
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(140, 400, 32, 32)];;

    [playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    self.playOrPauseButton = playButton;
    [playButton release];
}
//初始化拖动时间线
- (void)initDraggingTimeLine{
    
    //时间线timeParentView
    UIView *timeParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, 320, 20)];
    [timeParentView setBackgroundColor:[UIColor clearColor]];
    timeParentView.hidden = YES;
    
    MyTimeLine *myTimeLine = [[MyTimeLine alloc] initWithFrame:CGRectMake(0, 7, 320, 6)];
    [myTimeLine setBackgroundColor:[UIColor clearColor]];
    [timeParentView addSubview:myTimeLine];
    [myTimeLine release];
    
    //时间线上的时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 0, 50, 10)];;
    timeLabel.text = MUSIC_START_TIME;
    timeLabel.tag = TIME_LABEL_TAG;
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    timeLabel.font = [UIFont systemFontOfSize:9];
    timeLabel.textColor = [UIColor purpleColor];
    timeLabel.textAlignment = UITextAlignmentRight;
    [timeParentView addSubview:timeLabel];
    
    self.timeLineView = timeParentView;
    [self.view addSubview:timeParentView];
    [timeParentView release];
}
//初始化歌词显示的view
- (void)initLyricsScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20, 280, 360)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    //滚动速度放慢
    scrollView.decelerationRate = 0.0;
    NSArray *lyricsData = self.musicObject.lyrics;
    
    //初始化内容区域大小
    scrollView.contentSize = CGSizeMake(DEFAULT_SCROLLVIEW_WIDTH, lyricsData.count * DEFAULT_FONT_HEIGHT + DEFAULT_SCROLLVIEW_HEADER_HEIGHT + DEFAULT_SCROLLVIEW_FOOTER_HEIGHT);
    
    //初始化头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_SCROLLVIEW_WIDTH, DEFAULT_SCROLLVIEW_HEADER_HEIGHT)];
    [scrollView addSubview:headerView];
    [headerView release];
    
    //循环初始化歌词
    for (int i = 0; i < lyricsData.count; i++) {       
        
        //初始化每行的View
        UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, i * DEFAULT_FONT_HEIGHT + DEFAULT_SCROLLVIEW_HEADER_HEIGHT, DEFAULT_SCROLLVIEW_WIDTH, DEFAULT_FONT_HEIGHT)];
        parentView.backgroundColor = [UIColor clearColor];
        parentView.tag = 2000 + i;
        
        //初始化每行的歌词
        UILabel *label = [[UILabel alloc] initWithFrame:DEFAULT_LINE_FRAME];
        label.text = [lyricsData objectAtIndex:i];
        label.textColor = [UIColor whiteColor];
        label.font = DEFAULT_FONT;
        label.backgroundColor = [UIColor clearColor];   
        
        [parentView addSubview:label];
        [label release];
        
        [scrollView addSubview:parentView];
        [parentView release];
    }
    
    //初始化尾部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, DEFAULT_SCROLLVIEW_HEADER_HEIGHT + lyricsData.count * DEFAULT_FONT_HEIGHT, DEFAULT_SCROLLVIEW_WIDTH, DEFAULT_SCROLLVIEW_FOOTER_HEIGHT)];
    [scrollView addSubview:footerView];
    [footerView release];
    
    [self.view addSubview:scrollView];
    self.lyricsScrollView = scrollView;
    [scrollView release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    //初始化歌曲信息
    self.musicObject = [[MusicFileParser defaultInstance] parseMusicLyrics:@"iloveu"];
    //初始化拖动时间线
    [self initDraggingTimeLine];
    //初始化歌词显示的view
    [self initLyricsScrollView];
    //初始化播放按钮
    [self initPlayAndPauseButton];
    
    //    NSLog(@"%0.2f", [MyMusicUtil parseMilliTimeWithString:@"04:10.20"]);
    //    NSLog(@"%@", [MyMusicUtil parseStringWithMilliTime:261.17225f]);
    //#if 0
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,
//                            sizeof (audioRouteOverride),
//                            &audioRouteOverride);
//    UInt32 category = kAudioSessionCategory_AmbientSound;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
//                            sizeof (category),
//                            &category);
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"beauty" ofType:@"mp3"];
	NSURL *musicUrl = [NSURL fileURLWithPath:filepath];   
    NSError *error;
	AVAudioPlayer *tmpPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
	if (!tmpPlayer || error) {
		NSLog(@"init AVAudioPlayer failed!");
		return;
	}
    tmpPlayer.volume = 0.5;
    tmpPlayer.delegate = self;
    //261.17225   04:21:17
    NSLog(@"beauty.mp3 time length = [%0.5f] ", tmpPlayer.duration);
    self.tmpPlayer = tmpPlayer; 
    [tmpPlayer release];
    self.musicObject.musicDuration = self.tmpPlayer.duration;
    
    //初始化
    musicPlaying_ = NO;
    currentPlayLine_ = 0;
    self.processLabel = nil;
    draggingRow_ = 0;
    draggingTime_ = 0.0f;   

}
//播放 暂停事件
- (void)playOrPause:(id)sender{
    
    UIButton *button = (UIButton *)sender;  
    //当前如果是播放状态,则记录播放位置  更改按钮图标
    if (musicPlaying_) {        
        [button setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        //取消之前的延时事件
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startPlayProcess) object:nil];
        //暂停播放进度显示
        beforeProcessTime_ = [self.processLabel pauseProcess];
        [self.tmpPlayer pause];
    }
    else {
        [button setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        //如果是播放后暂停则接着之前进度播放
        if (self.processLabel) {    
            
            [self.processLabel reStartProcess];
            [self performSelector:@selector(startPlayProcess) withObject:nil afterDelay:beforeProcessTime_];
            
            int playLine = (currentPlayLine_ - 1) > 0? currentPlayLine_ - 1 :currentPlayLine_;
            //获取行开始时间
            float lineStartTime = [MyMusicUtil getCurrentRowStartTimeAtIndex:playLine withAllTimeArray:self.musicObject.lyricsTime];
            
            float linePlayTime = [MyMusicUtil getNextRowIntervalFromIndex:playLine withMusicObject:self.musicObject];
            
            self.tmpPlayer.currentTime = (lineStartTime + (linePlayTime - beforeProcessTime_));
            NSLog(@"reStartProcess line = [%d] nextTime = [%0.5f]  beforeProcessTime_ = [%0.5f]",playLine, lineStartTime, beforeProcessTime_);
            [self.tmpPlayer play];
        }
        //开始播放
        else{
            BOOL isSuccess = [self.tmpPlayer prepareToPlay];
            NSLog(@"isSuccess = [%@]", isSuccess?@"success":@"fail");
            [self.tmpPlayer play];
            [self startPlayProcess];
        }        
    }
    musicPlaying_ = !musicPlaying_;  
    
}
 //初始化播放进度显示
- (void)initProcessLabel: (int)row{
    //获取时间
    float nextTime = [MyMusicUtil getNextRowIntervalFromIndex:row withMusicObject:self.musicObject];
    UIView *parentView = [self.lyricsScrollView viewWithTag:2000 + row];
    
    ProcessLabel *processLabelTmp = [[ProcessLabel alloc] initWithFrame:DEFAULT_LINE_FRAME];
    processLabelTmp.parentView = parentView;
    processLabelTmp.message = [self.musicObject.lyrics objectAtIndex:row];
    processLabelTmp.playTime = nextTime;    
    self.processLabel = processLabelTmp;
    [processLabelTmp release];
    
}
//开始播放延时方法
- (void)startPlayProcess{
    
    //播放结束
    if (currentPlayLine_ >= [self.musicObject.lyrics count]) {        
        //初始化
        currentPlayLine_ = 0;
        musicPlaying_ = NO;
        self.processLabel = nil;
        //按钮图标置为播放图标
        [self.playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        return;
    }
    //重新定位scrollview 的原点
    [UIView beginAnimations:@"scrollviewoffset" context:nil];
    [UIView setAnimationDuration:1];
    self.lyricsScrollView.contentOffset = CGPointMake(0, DEFAULT_SCROLLVIEW_OFFSET + currentPlayLine_ * DEFAULT_FONT_HEIGHT);
    [UIView commitAnimations]; 
    
    //初始化进度显示
    [self initProcessLabel:currentPlayLine_];
    
    //播放进度显示
    [self.processLabel startProcess];    
    
    //获取时间
    float nextTime = [MyMusicUtil getNextRowIntervalFromIndex:currentPlayLine_ withMusicObject:self.musicObject];
    
    //递归调用
    [self performSelector:@selector(startPlayProcess) withObject:nil afterDelay:nextTime];
    currentPlayLine_++;
}
//根据当前的偏移量来计算是第几行歌词
- (int)getDraggingRow:(float)offsetY{
    
    return offsetY / DEFAULT_FONT_HEIGHT;
}
//如果之前是音乐播放状态则继续播放
- (void)continuePlayMuisc{
    currentPlayLine_ = draggingRow_ + 1;
    if (currentPlayLine_ >= [self.musicObject.lyrics count]) {
        [self.tmpPlayer stop];
        //初始化
        currentPlayLine_ = 0;
        musicPlaying_ = NO;
        self.processLabel = nil;
        //按钮图标置为播放图标
        [self.playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        return;
    }
    if (musicPlaying_) {
        [self.processLabel reStartProcess];
        [self performSelector:@selector(startPlayProcess) withObject:nil afterDelay:beforeProcessTime_];
        
        int playLine = (currentPlayLine_ - 1) > 0? currentPlayLine_ - 1 :currentPlayLine_;
        //获取行开始时间
        float lineStartTime = [MyMusicUtil getCurrentRowStartTimeAtIndex:playLine withAllTimeArray:self.musicObject.lyricsTime];
        
        float linePlayTime = [MyMusicUtil getNextRowIntervalFromIndex:playLine withMusicObject:self.musicObject];
        
        self.tmpPlayer.currentTime = (lineStartTime + (linePlayTime - beforeProcessTime_));
//        NSLog(@"reStartProcess line = [%d] nextTime = [%0.5f]  beforeProcessTime_ = [%0.5f]",playLine, lineStartTime, beforeProcessTime_);
        [self.tmpPlayer play];
    }
}

#pragma scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    //    NSLog(@"scrollViewWillBeginDragging...");
    self.timeLineView.hidden = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSLog(@"scrollViewDidScroll... ");
    
    //取消之前的延时事件
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startPlayProcess) object:nil];
    //停止播放进度显示
    [self.processLabel stopProcess];
    
    //时间线上的时间
    UILabel *timeLabel = (UILabel*)[self.timeLineView viewWithTag:TIME_LABEL_TAG];
    
    //根据当前的偏移量来计算是第几行歌词
    draggingRow_ = [self getDraggingRow: scrollView.contentOffset.y];
    //歌词尾
    if (draggingRow_ >= self.musicObject.lyricsTime.count) {
        timeLabel.text = MUSIC_END_TIME;
        return;
    }
    //歌词头
    if ((int)self.lyricsScrollView.contentOffset.y == 0) {
        timeLabel.text = MUSIC_START_TIME;
        return;
    }
    
    //获取时间
    float nextTime = [MyMusicUtil getNextRowIntervalFromIndex:draggingRow_ withMusicObject:self.musicObject];   
    
    //每一像素的偏移值
    float offsetTimeForPix = nextTime / DEFAULT_FONT_HEIGHT;
    
    //相对行的偏移量
    int rowOffset = scrollView.contentOffset.y - draggingRow_ * DEFAULT_FONT_HEIGHT;
    
    //时间偏移量
    draggingTime_ = rowOffset * offsetTimeForPix;    
 
    //时间偏移量 + 当前行的时间 转换为分秒
    NSString *parseTime = [MyMusicUtil parseStringWithMilliTime:draggingTime_ + [MyMusicUtil getCurrentRowStartTimeAtIndex:draggingRow_ withAllTimeArray:self.musicObject.lyricsTime]];
    
    timeLabel.text = parseTime;
    
    //初始化进度显示
    [self initProcessLabel:draggingRow_];

    //播放进度从某时间点开始显示
    [self.processLabel startProcessWithTime:draggingTime_];
    
    //暂停播放进度显示
    beforeProcessTime_ = nextTime - draggingTime_;
//    NSLog(@"draggingTime_ = [%0.5f] beforeProcessTime_ = [%0.5f]", draggingTime_, beforeProcessTime_);
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //    NSLog(@"scrollViewWillEndDragging...");
    self.timeLineView.hidden = YES;
    
}
//停止拖动时从拖动点开始播放
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"scrollViewDidEndDragging... %f", scrollView.contentOffset.y);
    
    [self continuePlayMuisc];
}
//滚动停止时从滚动停止点开始播放
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    NSLog(@"scrollViewDidEndDecelerating... %f", scrollView.contentOffset.y);
    [self continuePlayMuisc];
}
#pragma mark -
#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	
    
}
@end
