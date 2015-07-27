//
//  CommandQueue.m
//  RomoTouch2
//
//  Created by Jongwon Lee on 4/22/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#import "CommandQueue.h"

@implementation CommandQueue

- (void)initializeQueue {
    
    queue = [[NSMutableArray alloc] init];
}

- (NSString *)popFirst {
    if([queue count] > 0) {
        NSString *retStr = [queue objectAtIndex:0];
        [queue removeObjectAtIndex:0];
        return retStr;
    }
    else
        return nil;
}

- (int) getSize {
    return [queue count];
}

- (void)insertLast:(NSString *)cmdStr {
    [queue addObject:cmdStr];
}

- (void)insertFirst:(NSString *)cmdStr {
    [queue insertObject:cmdStr atIndex:0];
}

- (void)insertWithIndex:(int)idx withStr:(NSString *)cmdStr {
    [queue insertObject:cmdStr atIndex:idx];
}



@end
