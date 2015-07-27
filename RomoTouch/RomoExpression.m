//
//  RomoMovement.m
//  RomoTouch
//
//  Created by Jongwon Lee on 4/6/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//
#import "macros.m"
#import "RomoExpression.h"

@implementation RomoExpression
{
    NSString *file;
    NSDictionary *plistContent;
    
}

@synthesize emotionBGColor, expressionBGColor, emotions, expressions, expressionDuration, eyesClosed, emotionDuration, rEmotion, rExpression;

RMCharacterEmotion emotion;
RMCharacterExpression expression;


- (id) init {
    self = [super init];
    return self;
}


- (id) initWithExpression:(RMCharacterExpression)expression
                  Emotion:(RMCharacterEmotion)emotion
          EmotionDuration:(float)duration

{
    self = [super init];
    if (self) {
        
        self.rExpression = expression;
        self.rEmotion = emotion;
        self.emotionDuration = duration;
    }
    
    return self;
}

-(id)initWithEyesClosed:(BOOL)closed
               Duration:(float)duration {
    self = [super init];
    if (self) {
        self.emotionDuration = duration;
        self.eyesClosed = closed;
    }
    return self;
}

-(float)expressionDuration:(NSString *)expression {
    
    
    file = [[NSBundle mainBundle] pathForResource:@"RomoExpressionDurations" ofType:@"plist"];
    plistContent = [NSDictionary dictionaryWithContentsOfFile:file];
    expressionDuration = [[plistContent valueForKey:expression] floatValue];
    expressionDuration += 0.05;
    return expressionDuration;

}



//starts from 1
-(NSArray *)emotions
{
    return emotions = @[@"",@"Curious", @"Excited", @"Happy", @"Sad", @"Scared", @"Sleepy", @"Sleeping", @"Indifferent", @"Bewildered", @"Delighted"];
    
}

-(NSArray *)expressions{
    
    return expressions = @[@"None",@"Angry",@"Bored",@"Curious",@"Dizzy",@"Embarrassed",@"Excited",@"Exhausted",@"Happy",@"Holding Breath",@"Laugh",@"Looking Around",@"Love",@"Ponder",@"Sad",@"Scared",@"Sleepy",@"Sneeze",@"Talking",@"Yawn",@"Startled",@"Chuckle",@"Proud",@"Let Down",@"Want",@"Hiccup",@"Fart",@"Bewildered",@"Yippee",@"Sniff",@"Smack",@"Wee",@"Struggling",@"Cover Ears"];
    
}




-(UIColor *)emotionBGColor
{
    switch(rEmotion) {
        case RMCharacterEmotionCurious:
            emotionBGColor = UA_rgb(219, 218, 118);
            break;
        case RMCharacterEmotionExcited :
            emotionBGColor = UA_rgb(150, 211, 108);
            break;
        case RMCharacterEmotionHappy:
            emotionBGColor = UA_rgb(126, 204, 129);
            break;
        case RMCharacterEmotionSad:
            emotionBGColor = UA_rgb(128, 183, 232);
            break;
        case RMCharacterEmotionScared:
            emotionBGColor = UA_rgb(208, 194, 87);
            break;
        case RMCharacterEmotionSleepy:
            emotionBGColor = UA_rgb(186, 206, 208);
            break;
        case RMCharacterEmotionSleeping:
            emotionBGColor = UA_rgb(186, 206, 208);
            break;
        case RMCharacterEmotionIndifferent:
        case RMCharacterEmotionBewildered:
        case RMCharacterEmotionDelighted:
            emotionBGColor = UA_rgb(138, 213, 220);
            break;
        default:
            emotionBGColor = UA_rgb(126, 204, 129);
            break;
            
    }
    return emotionBGColor;
    
}

-(UIColor *)expressionBGColor
{
    //updated colors to correlate with penguin 6/12/15
    //no equivalent for Penguin frustrated (228,153,231)
    switch (rExpression) {
        case RMCharacterExpressionHappy:
            expressionBGColor = UA_rgb(126, 204, 129);
            break;
        case RMCharacterExpressionLetDown:
        case RMCharacterExpressionSad:
            expressionBGColor = UA_rgb(128, 183, 232);
            break;
        case RMCharacterExpressionAngry:
            expressionBGColor = UA_rgb(255, 135, 133);
            break;
        case RMCharacterExpressionExhausted:
            expressionBGColor = UA_rgb(253, 159, 104);
            break;
        case RMCharacterExpressionScared:
            expressionBGColor = UA_rgb(208, 194, 87);
            break;
        case RMCharacterExpressionExcited:
            expressionBGColor = UA_rgb(150, 211, 108);
            break;
        case RMCharacterExpressionStartled:
            expressionBGColor = UA_rgb(254, 220, 128);
            break;
        case RMCharacterExpressionSleepy:
            expressionBGColor = UA_rgb(186, 206, 208);
            break;
        case RMCharacterExpressionStruggling:
            expressionBGColor = UA_rgb(228, 153, 231);
            break;
        case RMCharacterExpressionCurious:
            expressionBGColor = UA_rgb(219, 218, 118);
            break;
        case RMCharacterExpressionDizzy:
            expressionBGColor = UA_rgb(242, 208, 151);
            break;
        case RMCharacterExpressionSniff:
            expressionBGColor = UA_rgb(207, 228, 140);
            break;
        case RMCharacterExpressionSneeze:
            expressionBGColor = UA_rgb(231, 170, 190);
            break;
        case RMCharacterExpressionWant:
            expressionBGColor = UA_rgb(109, 212, 167);
            break;
        case RMCharacterExpressionNone:
        default:
            expressionBGColor = UA_rgb(138, 213, 220);
            break;
            
    }
    return expressionBGColor;
}



@end
