//
//  RomoExpression.h
//  RomoTouch
//
//  Created by Jongwon Lee on 3/30/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//
#import "macros.m"
#import <Foundation/Foundation.h>
#import <RMCharacter/RMCharacter.h>

@interface RomoExpression : NSObject

@property (nonatomic) int rExpression;
@property (nonatomic) int rEmotion;
//@property (nonatomic, strong) NSString* emotionName;
//@property (nonatomic, strong) NSString* expressionName;
@property (nonatomic, readonly) UIColor* expressionBGColor;
@property (nonatomic, readonly) UIColor* emotionBGColor;
@property (nonatomic, strong) NSArray* emotions;
@property (nonatomic, strong) NSArray* expressions;
@property (nonatomic) float expressionDuration;
@property (nonatomic) float emotionDuration;
@property (nonatomic) BOOL eyesClosed;


- (id) init;

- (id) initWithExpression:(RMCharacterExpression)expression
                  Emotion:(RMCharacterEmotion)emotion
          EmotionDuration:(float)duration;

- (id) initWithEyesClosed:(BOOL)closed
                 Duration:(float)duration;

-(float)expressionDuration:(NSString *)expression;

-(NSArray *)emotions;
-(NSArray *)expressions;

@end
