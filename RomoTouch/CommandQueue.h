//
//  CommandQueue.h
//  RomoTouch2
//
//  Created by Jongwon Lee on 4/22/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandQueue : NSObject
{
    NSMutableArray* queue;
}

- (void)initializeQueue;
- (NSString *)popFirst;
- (int) getSize;

- (void)insertLast:(NSString *)cmdStr;
- (void)insertFirst:(NSString *)cmdStr;
- (void)insertWithIndex:(int)idx withStr:(NSString *)cmdStr;

@end