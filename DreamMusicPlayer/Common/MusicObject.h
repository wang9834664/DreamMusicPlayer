//
//  MusicObject.h
//  TestHighLightLabel
//
//  Created by 王 越红 on 12-12-20.
//  Copyright (c) 2012年 cienet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicObject : NSObject
{
    //歌名
    NSString *name_;
    
    //歌词数组
    NSArray *lyrics_;
    
    //每句歌词播放时间
    NSArray *lyricsTime_;
    
    //歌曲总播放时长
    float musicDuration_;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSArray *lyrics;
@property (nonatomic, retain) NSArray *lyricsTime;
@property (nonatomic, assign) float musicDuration;
@end
