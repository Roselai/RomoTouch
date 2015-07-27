//
//  PenguinViewController.h
//  RomoTouch
//
//  Created by Jongwon Lee on 3/11/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMcore/RMCore.h>
#import "MoveMentQueue.h"
#import <CoreLocation/CoreLocation.h>
#import "RomoMovement.h"
#import "RomoExpression.h"
#import "CommandQueue.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEAcousticModel.h>
#import <Slt/Slt.h>
#import <OpenEars/OEFliteController.h>
#import <OpenEars/OEEventsObserver.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEAcousticModel.h>

typedef enum {
    NetworkStateNotAvailable,
    NetworkStateConnectingToServer,
    NetworkStateConnected
} NetworkState;


// 4/6
@interface PenguinViewController : UIViewController <NSStreamDelegate, RMCoreDelegate, CLLocationManagerDelegate, OEEventsObserverDelegate> {

    UILabel *_emotionLabel;
    UILabel *_movementLabel;
    
    MovementQueue *movementQueue;
    
    //Romo Emotion lable
    UILabel *expressionLabel;
    UILabel *emotionLabel;
    UILabel *debugLabel;
    UILabel *_messageLabel;
    
    
    float eDuration;
    // EmotionQueue *eQueue;
    CommandQueue *eQueue;
    float mDuration;
    // MovementQueue *mQueue;
    CommandQueue *mQueue;
    
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    
    NSMutableData *_outputBuffer;
    NSMutableData *_inputBuffer;
    
    BOOL _inputOpened;
    BOOL _outputOpened;
    BOOL _okToWrite;
    NSMutableArray *_messages;
    
    NSString *ip;
    UInt32 port;
    
    NetworkState _networkState;
    
}

// 4/6
@property (nonatomic, strong) RMCoreRobot<HeadTiltProtocol, DriveProtocol, LEDProtocol> *robot;
@property (strong, nonatomic) OEFliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

//Tabassum -added Romo
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) RMCharacter *romo;
@property (nonatomic, strong) RomoExpression *re;
@property (nonatomic, strong) RomoMovement *rm;
@property (nonatomic, strong) RMCoreControllerPID *controller;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) CMMotionManager *manager;
@property (nonatomic, strong) NSString *speechHypothesis;
@property (nonatomic, strong) OEEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) NSNumber *magneticHeading;
@property (nonatomic, strong) NSNumber *trueHeading;



@end
