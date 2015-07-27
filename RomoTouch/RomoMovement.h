//
//  RomoMovement.h
//  RomoTouch
//
//  Created by Jongwon Lee on 4/6/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RomoMovement : NSObject

@property (nonatomic) float duration;
@property (nonatomic) float speed;
@property (nonatomic) float radius;
@property (nonatomic) float angle;
@property (nonatomic) float distance;
@property (nonatomic) float headTiltAngle;
@property (nonatomic) float LEDPeriod;
@property (nonatomic) float LEDDutyCycle;
@property (nonatomic) float LEDBrightness;



- (id) init;
- (id) initWithDuration:(float)duration
                  Speed:(float)speed
                 Radius:(float)radius
                  Angle:(float)angle
               Distance:(float)distance;


-(id)initWithTiltAngle:(float)angle;

-(id)initLedWithPeriod:(float)period
             dutyCycle:(float)cycle
            brightness:(float)brightness;




@end
