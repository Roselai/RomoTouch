//
//  ViewController.h
//  RomoTouch
//
//  Created by Jongwon Lee on 3/11/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMCore/RMCore.h>
#import "PenguinViewController.h"

@interface ViewController : UIViewController {

    PenguinViewController *_penguinVC;
    
    UITextField *_ipField;
    UITextField *_portField;
    UITextField *_idField;
    UITextField *_pwField;
    
    NSString *userID;
    NSString *userPW;
}

@property (nonatomic, retain) IBOutlet PenguinViewController *penguinVC;

@property (nonatomic, retain) IBOutlet UITextField *ipField;
@property (nonatomic, retain) IBOutlet UITextField *portField;
@property (nonatomic, retain) IBOutlet UITextField *idField;
@property (nonatomic, retain) IBOutlet UITextField *pwField;

-(IBAction) connect;
-(IBAction) runWithtoutServer;


@end

