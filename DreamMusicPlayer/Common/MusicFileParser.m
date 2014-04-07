//
//  MusicFileParser.m
//  TestHighLightLabel
//
//  Created by 王 越红 on 12-12-20.
//  Copyright (c) 2012年 cienet. All rights reserved.
//

#import "MusicFileParser.h"

@implementation MusicFileParser
static MusicFileParser *musicFileParser;
+ (MusicFileParser*)defaultInstance{
    if (nil == musicFileParser) {
        musicFileParser = [[self alloc] init];
    }
    return musicFileParser;
}
//解析歌词文件
- (MusicObject*)parseMusicLyrics:(NSString*)fileName{
    NSString *musicFileName = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSError *error = nil;
    NSString *musicFileStr = [NSString stringWithContentsOfFile:musicFileName encoding:NSUTF8StringEncoding error:&error];
    
    NSArray *data = [musicFileStr componentsSeparatedByString:@"\n"];    
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] initWithCapacity:data.count];
    NSMutableArray *lyricsArray = [[NSMutableArray alloc] initWithCapacity:data.count];
    
    for (int i = 0; i < data.count; i++) {
        NSString *str = [data objectAtIndex:i];
        NSRange range = [str rangeOfString:@"]"];
        //time
        NSString *time = [str substringToIndex:range.location];
        time = [time substringFromIndex:1];
        [timeArray addObject:time];
        
        NSString *lyrics = [str substringFromIndex:range.location + 1];
        [lyricsArray addObject:lyrics];        
    }
    MusicObject *musicObj = [[[MusicObject alloc] init] autorelease];
    musicObj.lyricsTime = timeArray;
    [timeArray release];
    musicObj.lyrics = lyricsArray;
    [lyricsArray release];
    musicObj.name = fileName;  
    musicObj.musicDuration = 261.17225f;
    return musicObj;    
}
@end
