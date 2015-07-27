//
//  ExpressionViewController.h
//  romoDrive
//
//  Created by Tabassum Azad on 4/14/15.
//  Copyright (c) 2015 NYIT Roboticists. All rights reserved.
//

#import "RomoExpression.h"
#import <UIKit/UIKit.h>

@interface ExpressionViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic,strong) RMCharacter *Romo;
@property (nonatomic,strong) RomoExpression *re;

@end
