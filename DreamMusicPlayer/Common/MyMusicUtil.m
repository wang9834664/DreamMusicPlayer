//
//  MyMusicUtil.m
//  TestHighLightLabel
//
//  Created by 王 越红 on 12-12-18.
//  Copyright (c) 2012年 cienet. All rights reserved.
//

#import "MyMusicUtil.h"


@implementation MyMusicUtil
//计算两行音乐之间的播放时长,用来启用定时任务
//如果当前播放最后一行,直接按整个音乐的时长
+ (float)getNextRowIntervalFromIndex:(int)row withMusicObject:(MusicObject*)musicObj {
    
    NSArray *lyricsTime = musicObj.lyricsTime;
    NSString *prevTimeStr = [lyricsTime objectAtIndex:row];
    float prevTime = [MyMusicUtil parseMilliTimeWithString:prevTimeStr];
    //最后一行
    if ((row + 1) >= lyricsTime.count ) {
        //需要读取歌曲的总时间来确定
        return musicObj.musicDuration - prevTime;
    } 
    
    NSString *nextTimeStr = [lyricsTime objectAtIndex:row + 1];
    float nextTime = [MyMusicUtil parseMilliTimeWithString:nextTimeStr];
    return nextTime - prevTime;
}

//根据起始时间数组 获取当前正在播放行的起始时间秒值
+ (float)getCurrentRowStartTimeAtIndex:(int)row withAllTimeArray:(NSArray*)allTime {
    NSString *currentTimeStr = [allTime objectAtIndex:row];
    return [MyMusicUtil parseMilliTimeWithString:currentTimeStr];    
}
//根据时间字符串解析出毫秒值
//timeStr(分:秒:毫秒)  @"01:01.01"  ==>>   61.01秒
+ (float)parseMilliTimeWithString:(NSString*)timeStr{
    
    //分
    float minute = [[timeStr substringToIndex:2] floatValue];
    //秒
    float second = [[[timeStr substringFromIndex:3] substringToIndex:2] floatValue];
    //毫秒
    float milliSecond = [[timeStr substringFromIndex:6] floatValue];
    //    NSLog(@"minute [%d] second [%d] milliSecond [%d]", minute, second, milliSecond);
    return minute * 60 + second + milliSecond / 100;
}
//根据毫秒值解析出时间字符串
//timeStr  61.01秒  ==>>   @"01:01.01"(分:秒:毫秒)
+ (NSString *)parseStringWithMilliTime:(float)milliTime{
    
    //分
    int minute = milliTime / 60;
    //秒
    int second = milliTime - (minute * 60);
    //毫秒
    int milliSecond = (int)(milliTime * 100) % 100;
    NSString *minuteStr = [[NSString alloc] initWithFormat:@"%d", 100 + minute];
    NSString *secondStr = [[NSString alloc] initWithFormat:@"%d", 100 + second];
    NSString *milliSecondStr = [[NSString alloc] initWithFormat:@"%d", 100 + milliSecond];
    
    return [[NSString alloc] initWithFormat:@"%@:%@:%@", [minuteStr substringFromIndex:1], [secondStr substringFromIndex:1], [milliSecondStr substringFromIndex:1]];
}
@end
