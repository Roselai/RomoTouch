//
//  ViewController.m
//  RomoTouch
//
//  Created by Jongwon Lee on 3/11/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize penguinVC = _penguinVC;
@synthesize ipField = _ipField;
@synthesize portField = _portField;
@synthesize idField = _idField;
@synthesize pwField = _pwField;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _penguinVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PenguinVCID"];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)connect {
    NSString *ip = [NSString stringWithFormat:@"%@", _ipField.text];
    UInt32 portNum = [_portField.text intValue];
    userID = [NSString stringWithFormat:@"%@", _idField.text];
    userPW = [NSString stringWithFormat:@"%@", _pwField.text];
    [self withIP:ip wihtPortNum:portNum withID:userID withPW:userPW];
}

- (void)withIP:(NSString *)_ip wihtPortNum:(UInt32)_portNum withID:(NSString *)_id withPW:(NSString *)_pw {
    
}

- (IBAction)runWithtoutServer {
    [self presentViewController:_penguinVC animated:YES completion:nil];
}

@end
