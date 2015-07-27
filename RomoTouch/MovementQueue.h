//
//  MovementQueue.h
//  RomoTouch
//
//  Created by Jongwon Lee on 4/6/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RomoMovement.h"
#import "RomoExpression.h"



@interface MovementQueue : NSObject


- (void)initializeQueue;

- (RomoMovement *)getFirstMove;
- (RomoExpression *)getFirstEmotion;

@end
