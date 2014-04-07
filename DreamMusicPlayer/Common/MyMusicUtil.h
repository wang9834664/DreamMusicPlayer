//
//  MyMusicUtil.h
//  TestHighLightLabel
//
//  Created by 王 越红 on 12-12-18.
//  Copyright (c) 2012年 cienet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyTimeLine.h"
#import "AppDelegate.h"
#import "MusicObject.h"
#import "MusicFileParser.h"
#define DEFAULT_FONT [UIFont systemFontOfSize:16]
#define DEFAULT_FONT_HEIGHT 25
#define DEFAULT_SCROLLVIEW_WIDTH 280
#define DEFAULT_SCROLLVIEW_HEADER_HEIGHT 180
#define DEFAULT_SCROLLVIEW_FOOTER_HEIGHT 180
#define DEFAULT_SCROLLVIEW_OFFSET 0
#define DEFAULT_LINE_FRAME CGRectMake(0, 0, DEFAULT_SCROLLVIEW_WIDTH, DEFAULT_FONT_HEIGHT)
#define MUSIC_START_TIME @"start"
#define MUSIC_END_TIME @"end"
#define TIME_LABEL_TAG 1001

@interface MyMusicUtil : NSObject
//计算两行歌词之前的时长,用来启用定时任务
//如果当前是第一行歌词,直接取第一行歌词的时间
+ (float)getNextRowIntervalFromIndex:(int)row withMusicObject:(MusicObject*)musicObj;

//根据时间字符串解析出时间的毫秒值
//timeStr  03:12.49
+ (float)parseMilliTimeWithString:(NSString*)timeStr;

//取当前行歌词的时间
+ (float)getCurrentRowStartTimeAtIndex:(int)row withAllTimeArray:(NSArray*)allTime;
+ (NSString *)parseStringWithMilliTime:(float)milliTime;
@end
