//
//  MovementQueue.m
//  RomoTouch
//
//  Created by Shukti Azad on 4/6/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#import "macros.m"
#import "MovementQueue.h"

@implementation MovementQueue
{
    NSMutableArray* motionQueue;
    NSMutableArray* emotionQueue;
    NSMutableArray* heartQueue;
    
}

RomoMovement *rm;
RomoExpression *re;

- (void)initializeQueue {
    
   
    motionQueue = [[NSMutableArray alloc] init];
    emotionQueue = [[NSMutableArray alloc] init];
    re = [RomoExpression alloc];
    
    /*
     addEmotion(<#express#>, <#emotion#>, <#duration#>)
     addCloseEyes(<#duration#>)
     
    provide either duration or distance for driving, not both
    addMove(<#time#>, <#speed#>, <#radius#>, <#angle#>, <#dist#>)
    addDriveStraight(<#time#>, <#speed#>, <#dist#>)
    addDriveWRadius(<#time#>, <#speed#>, <#radius#>, <#dist#>)
    addRotation(<#speed#>, <#angle#>)
    addTurn(<#speed#>, <#radius#>, <#angle#>)
    addTilt(<#angle#>)
    addPause(<#time#>)
    stopMoving
    
     *** Units ****
     
     Distance   : meters
     Duration   : seconds
     Speed      : meters/seconds
     Angle      : degrees [-180, 180]
     
     */
    
    
    // transition: START -> Scenario 1
    addEmotion(RMCharacterExpressionNone, RMCharacterEmotionCurious, 1.0);
    addTilt(95);                       // make sure face/device is upright, 90 deg is too forward
    addPause(1.0);                      // pause for 1 sec
    addEmotion(RMCharacterExpressionCurious, RMCharacterEmotionCurious, 0.0);
    addRotation(0.1, -30);              // rotate 30 deg to the right
    addRotation(0.1, 60);               // rotate 30 degrees to the left
    addRotation(0.1, -30);              // rotate to face front
    addDriveStraight(0.0, 0.3, 0.7);    // drive forward for 0.5 m
    
    
    // 1. scenario_sight
    addEmotion(RMCharacterExpressionNone, RMCharacterEmotionScared, 2.0);
    addTilt(120);                       // tilt head backwards
    addDriveStraight(0.0, -0.6, 0.1);   // drive backwards
    addCloseEyes(1.0);
    addPause(1.0);                      // paus for 1.0 sec
    
    // transition: Scenario 1 -> 2
    addTilt(100);                       // make sure face/device is upright, 90 deg is too forward
    addRotation(0.3, -130);             // rotate 150 deg cw
    addEmotion(RMCharacterExpressionNone, RMCharacterEmotionCurious, 1.0);
    addDriveStraight(0.0, 0.3, 0.41);   // drive forward for distance 0.41 meters
    
    // 2. scenario_hearing
    addRotation(0.3, -30);
    addEmotion(RMCharacterExpressionAngry, RMCharacterEmotionSad, 1.0);
    addDriveWRadius([re expressionDuration:@"Angry"]-1.0, 0.7 ,0.0, 0.0);
    addEmotion(33, RMCharacterEmotionSad, 2.0); // rExpression 33, romo covers ears
    //stopMoving;
    
    // transition: Scenario 2 -> 3
    addRotation(0.3, -100);
    addTilt(100);
    addEmotion(RMCharacterExpressionExcited, RMCharacterEmotionExcited, 0.0);
    addPause([re expressionDuration:@"Excited"]-1.0);    // pause for 3 seconds
    addDriveStraight(1.0, 0.4, 0);               // drive forward until expression excited ends
    
    // 3. scenario smell
    addEmotion(RMCharacterExpressionSniff, RMCharacterEmotionHappy, 0.0);
    addPause([re expressionDuration:@"Sniff"]/2);
    addDriveStraightWithTime([re expressionDuration:@"Sniff"]/2, 0.3);
    addTilt(80);
    addEmotion(RMCharacterExpressionSniff, RMCharacterEmotionHappy, 0.0);
    addPause([re expressionDuration:@"Sniff"]);
    addTilt(110);
    addPause(0.5);
    addEmotion(RMCharacterExpressionSneeze, RMCharacterEmotionSad, 0.0);
    addTilt(90);
    addPause([re expressionDuration:@"Sneeze"]); // pause for duration of expression sneeze
    addTilt(130);
    addPause([re expressionDuration:@"Holding Breath"]-2.0);
    addEmotion(RMCharacterExpressionHoldingBreath, RMCharacterEmotionSad, 0.0);
    addDriveStraight(2.0, -0.2, 0.0);
   // stopMoving;

    // transition: Scenario 3 -> 4
    addDriveStraight(0.0, 0.3, 0.7);    // drive forward for 0.5 m
    
    
    //scenario taste
    addRotation(0.1, -30);              // rotate 30 deg to the right
    addEmotion(RMCharacterExpressionWant, RMCharacterEmotionHappy, 0.0);
    addPause([re expressionDuration:@"Want"]);
    addRotation(0.1, 60);               // rotate 30 degrees to the left
    addEmotion(34, RMCharacterEmotionIndifferent, 0.0);
    addPause([re expressionDuration:@"Want"]);
    addRotation(0.1, -30);              // rotate to face front
    

    /*
 
    addRotation(0.2, 135);
    addDriveStraightWithDistance(0.3, 0.4);
    addTurn(0.2, 0.2, 180);
    addRotation(0.2, -90);
    addTurn(0.2, 0.2, 180);
    addDriveStraightWithDistance(0.3, 0.4);
    addRotation(0.2, -45);
    stopMoving;
    */
}

- (void)initializeEmotionQueue {
    
    
    emotionQueue = [[NSMutableArray alloc] init];
    
//    // 4. scenario taste
//
//    addEmotion(RMCharacterExpressionPonder, RMCharacterEmotionBewildered, 0.0);
//    addEmotion(RMCharacterExpressionLookingAround, RMCharacterEmotionExcited, 0.0);
//    addEmotion(RMCharacterExpressionWant, RMCharacterEmotionExcited, 1.0);
//    addEmotion(RMCharacterExpressionHappy, RMCharacterEmotionHappy, 0.0);
//    addEmotion(RMCharacterExpressionNone, RMCharacterEmotionIndifferent, 2.0);
//    
//
//    
//    
//    // 5. scenario Vestibular
//    addEmotion(RMCharacterExpressionExhausted, RMCharacterEmotionSleepy, 0.0);
    
    
    // END: scenario happy
    
    
    //heartShape
//    addEmotion(RMCharacterExpressionLove, RMCharacterEmotionExcited, 5.0);
//    addEmotion(RMCharacterExpressionLove, RMCharacterEmotionExcited, 5.0);
    
}

-(void)heartShape{
    //heart shape
    
//    [heartQueue addObject:[[RomoExpression alloc] initWithExpression:RMCharacterExpressionLove Emotion:RMCharacterEmotionExcited EmotionDuration:5.0]];
//    [heartQueue addObject:[[RomoMovement alloc] initWithDuration:0.0 Speed:0.4 Radius:0.0 Angle:135 Distance:0.0]];
//    [heartQueue addObject:[[RomoMovement alloc] initWithDuration:0.0 Speed:0.4 Radius:0.0 Angle:0.0 Distance:0.4]];
//    [heartQueue addObject:[[RomoMovement alloc] initWithDuration:0.0 Speed:0.4 Radius:0.2 Angle:180 Distance:0.0]];
//    [heartQueue addObject:[[RomoMovement alloc] initWithDuration:0.0 Speed:0.4 Radius:0.0 Angle:135 Distance:0.0]];
    
   
}


- (RomoMovement *)getFirstMove {
    if([motionQueue count] > 0) {
        
        RomoMovement *rm = [motionQueue objectAtIndex:0];
        [motionQueue removeObjectAtIndex:0];
        return rm;
    }
    
    else
        return nil;
}



- (RomoExpression *)getFirstEmotion {
    if([emotionQueue count] > 0) {
    
        RomoExpression *re = [emotionQueue objectAtIndex:0];
        [emotionQueue removeObjectAtIndex:0];
        return re;
    }
    
    else
        return nil;
    
    
}




@end
