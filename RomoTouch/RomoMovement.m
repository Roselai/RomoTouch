//
//  RomoMovement.m
//  RomoTouch
//
//  Created by Jongwon Lee on 4/6/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//
#import "macros.m"
#import "RomoMovement.h"

@implementation RomoMovement

@synthesize speed, radius, angle, distance, headTiltAngle, LEDBrightness,LEDDutyCycle,LEDPeriod,
  duration;




- (id) init {
    self = [super init];
    return self;
}

- (id) initWithDuration:(float)_duration
                  Speed:(float)_speed
                 Radius:(float)_radius
                  Angle:(float)_angle
               Distance:(float)_distance {
    
    self = [super init];
    if (self){
    self.duration =_duration;
    self.speed = _speed;
    self.radius =_radius;
    self.angle =_angle;
    self.distance =_distance;
    }
    return self;

}



-(id)initWithTiltAngle:(float)_angle {
    self = [super init];
    if (self) {
        self.headTiltAngle = _angle;
        }
    return self;
}


-(id)initLedWithPeriod:(float)period
             dutyCycle:(float)cycle
            brightness:(float)brightness
{
    self = [super init];
    if (self) {
        LEDPeriod = period;
        LEDDutyCycle = cycle;
        LEDBrightness = brightness;
    }
    
    return self;
}



@end
