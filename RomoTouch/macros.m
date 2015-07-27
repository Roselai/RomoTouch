//
//  macros.m
//  RomoTouch
//
//  Created by Shukti Shaikh on 4/14/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEBUG 1

#ifdef DEBUG
#warning LOGGING ENABLED
#define DebugLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DebugLog(...) do { } while (0)
#endif

//UIColor
#define UA_rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define UA_rgb(r,g,b) UA_rgba(r, g, b, 1.0f)

//Romo background color
#define setromoBGColor(r,g,b) [self.romo setFillColor:UA_rgb(r,g,b) percentage:100.0f]

#define setRomoBGColor(r,g,b) [self.Romo setFillColor:UA_rgb(r,g,b) percentage:100.0f]

#define setBGColor(r,g,b) [self setFillColor:UA_rgb(r,g,b) percentage:100.0f]

#define setFillColor(r, g, b) [[RMCharacter alloc] setFillColor:UA_rgb(r,g,b) percentage:100.0]


//movement queue
#define addMove(time,speed,radius,angle,dist) [motionQueue addObject:[[RomoMovement alloc]initWithDuration:time Speed:speed Radius:radius Angle:angle Distance:dist]]

#define addDriveStraight(time,speed,dist) [motionQueue addObject:[[RomoMovement alloc]initWithDuration:time Speed:speed Radius:9999 Angle:0.0 Distance:dist]]

#define addDriveStraightWithTime(time,speed) [motionQueue addObject:[[RomoMovement alloc]initWithDuration:time Speed:speed Radius:9999 Angle:0.0 Distance:0.0]]

#define addDriveStraightWithDistance(speed,dist) [motionQueue addObject:[[RomoMovement alloc]initWithDuration:0.0 Speed:speed Radius:9999 Angle:0.0 Distance:dist]]

#define addDriveStraightWithoutSpeed(time,dist) [motionQueue addObject:[[RomoMovement alloc]initWithDuration:time Speed:0.0 Radius:9999 Angle:0.0 Distance:dist]]

#define addDriveWRadius(time,speed,radius,dist) [motionQueue addObject:[[RomoMovement alloc]initWithDuration:time Speed:speed Radius:radius Angle:0.0 Distance:dist]]

#define addTurn(speed,radius,angle) [motionQueue addObject:[[RomoMovement alloc]initWithDuration:0.0 Speed:speed Radius:radius Angle:angle Distance:0.0]]

#define addRotation(speed,angle) [motionQueue addObject:[[RomoMovement alloc]initWithDuration:0.0 Speed:speed Radius:0.0 Angle:angle Distance:0.0]]

#define addTilt(angle) [motionQueue addObject:[[RomoMovement alloc] initWithTiltAngle:angle]]

#define addPause(time) [motionQueue addObject:[[RomoMovement alloc]initWithDuration:time Speed:0.0 Radius:0.0 Angle:0.0 Distance:0.0]]

#define stopMoving [motionQueue addObject:[[RomoMovement alloc]initWithDuration:0.0 Speed:0.0 Radius:0.0 Angle:0.0 Distance:0.0]]



#define addEmotion(express,emotion,duration) [emotionQueue addObject:[[RomoExpression alloc] initWithExpression:express Emotion:emotion EmotionDuration:duration]]

#define addCloseEyes(duration) [emotionQueue addObject:[[RomoExpression alloc] initWithEyesClosed:YES Duration:duration]];



//Romo expression times

#define sad_T [re expressionDuration:@"Sad"]