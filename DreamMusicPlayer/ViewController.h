//
//  ViewController.h
//  DreamMusicPlayer
//
//  Created by 越红 王 on 12-12-22.
//  Copyright (c) 2012年  cienet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
//音乐播放状态
@class ProcessLabel;
@class MusicObject;
@interface ViewController : UIViewController<UIScrollViewDelegate, AVAudioPlayerDelegate>
{
    //当前播放行
    int currentPlayLine_;
    //显示歌词
    UIScrollView *lyricsScrollView_;
    
    UILabel *tmpLabel_;
    
    //音乐播放状态
    BOOL musicPlaying_;
    
    //播放进度
    ProcessLabel *processLabel_;
    
    //上次播放时间
    float beforeProcessTime_;
    
    //dragging row
    int draggingRow_;
    //dragging time
    float draggingTime_;
    
    AVAudioPlayer *tmpPlayer_;

    //播放音乐文件信息
    MusicObject *musicObject_;
    
    //time line
    UIView *timeLineView_;  
    
    //play and pause Button
    UIButton *playOrPauseButton_;
}
@property (nonatomic, retain) ProcessLabel *processLabel;
@property (nonatomic, retain) AVAudioPlayer *tmpPlayer;
@property (nonatomic, retain) IBOutlet UIButton *playOrPauseButton;
@property (nonatomic, retain) IBOutlet UIScrollView *lyricsScrollView;
@property (nonatomic, retain) IBOutlet UIView *timeLineView;
@property (nonatomic, retain) MusicObject *musicObject;
- (IBAction)playOrPause:(id)sender;
@end

