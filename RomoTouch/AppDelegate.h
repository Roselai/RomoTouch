//
//  AppDelegate.h
//  RomoTouch
//
//  Created by Jongwon Lee on 3/11/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

- (NSArray *)initializeTabBarItems;


@end

