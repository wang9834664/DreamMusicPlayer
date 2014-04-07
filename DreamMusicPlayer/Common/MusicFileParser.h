//
//  MusicFileParser.h
//  TestHighLightLabel
//
//  Created by 王 越红 on 12-12-20.
//  Copyright (c) 2012年 cienet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicObject.h"

@interface MusicFileParser : NSObject

+ (MusicFileParser*)defaultInstance;

- (MusicObject*)parseMusicLyrics:(NSString*)fileName;
@end
