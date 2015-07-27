//
//  PenguinViewController.m
//  RomoTouch
//
//  Created by Shukti Azad on 3/11/15.
//  Copyright (c) 2015 Jongwon Lee. All rights reserved.
//

#define ARC4RANDOM_MAX 0x100000000
#import "macros.m"
#import "PenguinViewController.h"

@interface PenguinViewController ()

@end

@implementation PenguinViewController

{
    
    NSString *driveMotion;
    UIAlertView *alert;
    NSMutableArray *flakesArray;
   // NSMutableArray *cloudsArray;
    NSMutableArray *endPointArray;
    NSMutableArray *animationArray;
    NSMutableArray *flowersArray;
    NSMutableArray *imagesArray;
    UIView *snowFallView;
    NSArray *frames;
    NSDictionary *image;
    NSDictionary *frame;
    NSString *frameXPos;
    NSString *frameYPos;
    NSString *frameWidth;
    NSString *frameHeight;
    NSString *imageName;
    NSString *frameRotated;
    NSMutableDictionary *allImages;
    UIImageView *animationImageView;
    NSMutableArray *animationImages;
 
    /*
    float angle;
    float speed;
    float radius;
    float angleToTurn;
    float currentHeading;
    float headingPrecision;
    float minAngleValue;
    float maxAngleValue;
     */
    }




@synthesize rm, re, locationManager, manager, controller, speechHypothesis, audioPlayer,magneticHeading, trueHeading ;

RMCharacterExpression expression;
RMCharacterEmotion emotion;
RMCoreDriveCommand driveCommand;



- (id)init
{
    if (!(self = [super init]))
    {
        return (nil);
    }
    
    self.title = NSLocalizedString(@"Main", @"Button 1");
    self.tabBarItem.image = [UIImage imageNamed:@"first"];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"TOP_BAR_TITLE", @"Navigation Bar Title");
    
    return (self);
}



#pragma mark - View Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 4/6
    [RMCore setDelegate:self];
    

    // debug label
    CGRect emotionLabelRect = CGRectMake(0.0, CGRectGetHeight(self.view.frame)-120, CGRectGetWidth(self.view.frame), 40.0);
    _emotionLabel = [[UILabel alloc] initWithFrame:emotionLabelRect];
    _emotionLabel.backgroundColor = [UIColor clearColor];
    _emotionLabel.textAlignment = NSTextAlignmentCenter;
    _emotionLabel.textColor = [UIColor whiteColor];
    _emotionLabel.font = [UIFont systemFontOfSize:20];
    
    CGRect movementLabelRect = CGRectMake(0.0, CGRectGetHeight(self.view.frame)-90, CGRectGetWidth(self.view.frame), 40.0);
    _movementLabel = [[UILabel alloc] initWithFrame:movementLabelRect];
    _movementLabel.backgroundColor = [UIColor clearColor];
    _movementLabel.textAlignment = NSTextAlignmentCenter;
    _movementLabel.textColor = [UIColor whiteColor];
    _movementLabel.font = [UIFont systemFontOfSize:20];
    
    
    //UILabel for Romo character expression
    expressionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width , 65)];
    [expressionLabel setTextColor:[UIColor whiteColor]];
    [expressionLabel setBackgroundColor:[UIColor clearColor]];
    [expressionLabel setFont:[UIFont fontWithName: @"Chewy" size: 45.0f]];
    [expressionLabel setTextAlignment:NSTextAlignmentCenter];
    
    //UILabel for Romo character emotion
    emotionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width , 65)];
    [emotionLabel setTextColor:[UIColor whiteColor]];
    [emotionLabel setBackgroundColor:[UIColor clearColor]];
    [emotionLabel setFont:[UIFont fontWithName: @"Chewy" size: 45.0f]];
    [emotionLabel setTextAlignment:NSTextAlignmentCenter];
    
    //UILabel for debug
    debugLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 60)];
    [debugLabel setTextColor:[UIColor blackColor]];
    [debugLabel setBackgroundColor:[UIColor clearColor]];
    [debugLabel setFont:[UIFont systemFontOfSize:15]];
    [debugLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self initializeRomoNotifications];
   // [self initializeLocationManager];
   // [self checkLocationManager];
   // [self speechRecognition];
    
    
    self.romo = [RMCharacter Romo];
    
    rm =[RomoMovement alloc];
    re =[RomoExpression alloc];
    movementQueue = [MovementQueue alloc];
    
    [movementQueue initializeQueue];
    
    [self addGestureRecognizers];
    
    eDuration = -1.f;
    eQueue = [CommandQueue alloc];    //eQueue = [EmotionQueue alloc];
    [eQueue initializeQueue];
    
    mDuration = -1.f;
    mQueue = [CommandQueue alloc];
    [mQueue initializeQueue];
    
    [self connect];
    }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.romo addToSuperview:self.view];
    [self.view addSubview:_emotionLabel];
    [self.view addSubview:_movementLabel];
    [self.view addSubview:expressionLabel];
    [self.view addSubview:emotionLabel];
    [self.view addSubview:debugLabel];
   // [self testDuration];
    
//test methods
//[self tasteAnimation];
//[self romoCoversEarsForDuration:5.0];
//[self startBloom];
//[self testAnimation];
//[self winter];
 

}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.romo removeFromSuperview];
    [emotionLabel removeFromSuperview];
    [expressionLabel removeFromSuperview];
    [debugLabel removeFromSuperview];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    [animationImageView removeFromSuperview];
    
  
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RMCharacterDidFinishExpressingNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RMCharacterDidBeginExpressingNotification" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    [self.romo removeFromSuperview];
    [emotionLabel removeFromSuperview];
    [expressionLabel removeFromSuperview];
    [debugLabel removeFromSuperview];
    [animationImageView removeFromSuperview];
    
}



-(void)testDuration{
   // NSString *expressionDuration = @"Sniff_/2";
    NSExpression *e = [NSExpression expressionWithFormat:@"((20/10)-1)*100"];
    NSNumber *result = [e expressionValueWithObject:nil context:nil];
    NSLog(@"%@", result);
    // Output: 100
}

-(void)fetchJSONData:(NSString *)path
            {

    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"RMCharacter.bundle/%@",path] ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    NSError *error;
    allImages = [[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization
                                       JSONObjectWithData:jsonData
                                       options:kNilOptions
                                       error:&error]];
                
     if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
        
    } else {
        
        
        
        frames = allImages[@"frames"];
        
        
        for ( image in frames ){

            frame = image[@"frame"];
            imageName = image[@"filename"];
            frameRotated = image[@"rotated"];
            frameXPos = image[@"frame"][@"x"];
            frameYPos = image[@"frame"][@"y"];
            frameWidth = image[@"frame"][@"w"];
            frameHeight = image[@"frame"][@"h"];

        }
          }
        
            
    }




# pragma mark - custom animations



-(NSMutableArray *)romoAnimationWithImages:(NSString *)imageFile{

    UIImage *romoSprite = [UIImage imageNamed:[NSString stringWithFormat:@"RMCharacter.bundle/%@@2x.png",imageFile]];
   
    [self fetchJSONData:[NSString stringWithFormat:@"%@",imageFile]];
    animationImages = [[NSMutableArray alloc] init];
    
    UIImage *newImage;
    UIImage *newSize;
    CGRect myImageArea;
    UIImage *resizedImage;
    CGImageRef drawImage = NULL;
    CGImageRef im = NULL;
    //NSLog(@"Number of images:%i",frameCount);
    
    int i = 0;
    
    for (image in frames) {
        
        float x =       [image[@"frame"][@"x"]intValue];
        float y =       [image[@"frame"][@"y"]intValue];
        float w =       [image[@"frame"][@"w"]intValue];
        float h =       [image[@"frame"][@"h"]intValue];
        BOOL rotated =  [image[@"rotated"]boolValue]; //0 = false, 1 = true
        
       // NSLog(@"rotated:%@",frameRotated);
        
        if (rotated == 1 ) //rotated
        {
            
            myImageArea = CGRectMake(x,y,h,w);//height and width switched
            drawImage = CGImageCreateWithImageInRect(romoSprite.CGImage, myImageArea);
            newImage = [[UIImage alloc]initWithCGImage:drawImage];
            newSize = [self resizeImage:newImage newSize:CGSizeMake(h/4, w/4)]; // height and width are switched
            resizedImage = [self imageRotatedByDegrees:newSize deg:-90];
            im = resizedImage.CGImage;
             CGImageRelease(drawImage);
            
        }
        else if (rotated == 0)// not rotated
        {
        myImageArea = CGRectMake(x, y, w, h);
        drawImage = CGImageCreateWithImageInRect(romoSprite.CGImage, myImageArea);
        newImage = [[UIImage alloc]initWithCGImage:drawImage];
       resizedImage = [self resizeImage:newImage newSize:CGSizeMake(w/4, h/4)];
    
        im = resizedImage.CGImage;
            CGImageRelease(drawImage);
        
                    }
        [animationImages addObject:CFBridgingRelease(im)];
      // NSLog(@"image added at index:%i",i);
        

        animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - resizedImage.size.width/2, CGRectGetMidY(self.view.bounds) - resizedImage.size.height/2, resizedImage.size.width, resizedImage.size.height)];
        
        i++;
        }
    
    return animationImages;
   
}
-(void)tasteAnimation{
    
    NSMutableArray * imgArray1 = [self romoAnimationWithImages:@"Romo_Expression_7_2"]; //want
    NSMutableArray * imgArray2 = [self romoAnimationWithImages:@"Romo_Expression_7_1"]; // happy expression
    
    //remove images from imgArray1
  // [imgArray1 removeObjectsInRange:NSMakeRange(0, 15)];
    NSLog(@"Total Images:%lu",(unsigned long)imgArray1.count);
    
    [imgArray2 removeObjectsInRange:NSMakeRange(imgArray2.count-5, 5)];
    
    //combine imgArray1 & imgArray2 & imgArray 3
    NSMutableArray *combinedImages = [[NSMutableArray alloc] init];
    [combinedImages addObjectsFromArray:imgArray1];
    [combinedImages addObjectsFromArray:imgArray2];
    NSLog(@"Total Images:%lu",(unsigned long)combinedImages.count);
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.calculationMode = kCAAnimationDiscrete;
    animation.duration = 6.5;
    //animation.speed = 0.8;
    animation.values = combinedImages;
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    [animation setValue:@"taste" forKey:@"id"];
    [animationImageView.layer addAnimation:animation forKey:nil];

    //animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    animationImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:animationImageView];
    [self.view setBackgroundColor:UA_rgb(221, 255, 218)];
    [self.romo removeFromSuperview];
    
        [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
        {
                        [self.view setBackgroundColor:UA_rgb(188, 214, 140)];
        } completion:^(BOOL finished)
        {
            if(finished){
                // [animationImageView.layer removeAllAnimations];
            }
                else
                return;
    
        }];
}

-(void)romoDizzy {
    NSMutableArray * imgArray1 = [self romoAnimationWithImages:@"Romo_Expression_7_2"]; //want
    NSMutableArray * imgArray2 = [self romoAnimationWithImages:@"Romo_Expression_7_1"]; // happy expression
    
    //remove images from imgArray1
    // [imgArray1 removeObjectsInRange:NSMakeRange(0, 15)];
    NSLog(@"Total Images:%lu",(unsigned long)imgArray1.count);
    
    [imgArray2 removeObjectsInRange:NSMakeRange(imgArray2.count-5, 5)];
    
    //combine imgArray1 & imgArray2 & imgArray 3
    NSMutableArray *combinedImages = [[NSMutableArray alloc] init];
    [combinedImages addObjectsFromArray:imgArray1];
    [combinedImages addObjectsFromArray:imgArray2];
    NSLog(@"Total Images:%lu",(unsigned long)combinedImages.count);
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.calculationMode = kCAAnimationDiscrete;
    animation.duration = 6.5;
    //animation.speed = 0.8;
    animation.values = combinedImages;
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    [animation setValue:@"taste" forKey:@"id"];
    [animationImageView.layer addAnimation:animation forKey:nil];
    
    //animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    animationImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:animationImageView];
    [self.view setBackgroundColor:UA_rgb(221, 255, 218)];
    [self.romo removeFromSuperview];
    
    [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         [self.view setBackgroundColor:UA_rgb(188, 214, 140)];
     } completion:^(BOOL finished)
     {
         if(finished){
             // [animationImageView.layer removeAllAnimations];
         }
         else
             return;
         
     }];

}


-(void)testAnimation{
    
    //load the images to use in animation
    NSMutableArray * imgArray1 = [self romoAnimationWithImages:@"Romo_Expression_24_1"]; //want
    NSMutableArray * imgArray2 = [self romoAnimationWithImages:@"Romo_Expression_8_1"]; // happy expression
    NSMutableArray * imgArray3 = [self romoAnimationWithImages:@"Romo_Expression_8_2"]; // happy expression
   // NSMutableArray * imgArray4 = [self romoAnimationWithImages:@"Romo_Emotion_Transition_3_1"]; //happy emotion
    
    //remove images from imgArray1
   [imgArray1 removeObjectsInRange:NSMakeRange(0, 9)]; // 10 frames removed beginning of array
    [imgArray1 removeObjectsInRange:NSMakeRange(imgArray1.count-12, 12)]; // 12 frames removed from end of array
    NSLog(@"Total Images:%lu",(unsigned long)imgArray1.count);
    
    //remove images from imgArray2
    [imgArray2 removeObjectAtIndex:0]; // first frame removed from beginning of array
    NSLog(@"Total Images:%lu",(unsigned long)imgArray2.count);
    
    //remove images from imgArray3
    [imgArray3 removeObjectsInRange:NSMakeRange(0, imgArray3.count-1)];
    NSLog(@"Total Images:%lu",(unsigned long)imgArray3.count);

    
    //combine imgArray1 & imgArray2 & imgArray 3
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [images addObjectsFromArray:imgArray1];
    [images addObjectsFromArray:imgArray2];
    [images addObjectsFromArray:imgArray3];
    //[images addObjectsFromArray:imgArray4];
    NSLog(@"Total Images:%lu",(unsigned long)images.count);
    
//CFTimeInterval currentTime = CACurrentMediaTime();
   // CFTimeInterval currentTimeInSuperLayer = [animationImageView.layer convertTime:currentTime fromLayer:nil];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.calculationMode = kCAAnimationDiscrete;
    animation.duration = 6.4;
    //animation.speed = 0.8;
    animation.values = images;
    animation.repeatCount = 1;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.delegate = self;
    [animation setValue:@"wow" forKey:@"id"];
    [animationImageView.layer addAnimation:animation forKey:nil];
    
//    CAKeyframeAnimation *blink = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
//    blink.calculationMode = kCAAnimationDiscrete;
//    blink.beginTime =  6.5;
//    blink.duration = 0.9;
//    //blink.timeOffset = 2.0;
//    //blink.speed = 5.0;
//    blink.values = imgArray4;
//    blink.repeatCount = 1;
//    blink.autoreverses = YES;
//    blink.removedOnCompletion = NO;
//    blink.fillMode = kCAFillModeForwards;
//    blink.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    blink.delegate = self;
//    [blink setValue:@"blink" forKey:@"id"];
//  //  [animationImageView.layer addAnimation:blink forKey:@"nil"];
//
//        CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
//        group.animations = @[ animation, blink];
//        group.duration = 50.0;
//        group.repeatCount =1.0;
//        [group setRemovedOnCompletion:NO];
//        [group setFillMode:kCAFillModeForwards];
//        group.delegate = self;
//        [group setValue:@"romoTest" forKey:@"id"];
//    
//       [animationImageView.layer addAnimation:group forKey:nil];


    
    animationImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:animationImageView];
    [self.view setBackgroundColor:UA_rgb(221, 255, 218)];
    [self.romo removeFromSuperview];
    
    [UIView animateWithDuration:animation.duration animations:^{
        self.view.layer.backgroundColor = UA_rgb(126, 204, 129).CGColor;
    } completion:NULL];
    
    // Old method, no autoreverse
    //animationImageView.transform = CGAffineTransformMakeScale(-1, 1); //Flipped
    //animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    //animationImageView.animationImages = images;
    // animationImageView.animationDuration = 6.5;
    //animationImageView.animationRepeatCount = 1;
    //[animationImageView startAnimating ];
    //[self.view addSubview:animationImageView];
    // [self.romo removeFromSuperview];
    //[self.view setBackgroundColor:UA_rgb(235, 255, 238)];
    //[animationImageView startAnimating ];
    

}



-(void)createClouds {
     int numberOfClouds = arc4random() % 3;
    NSLog(@"Number of clouds:%i",numberOfClouds);
    
    NSMutableArray *clouds = [[NSMutableArray alloc] initWithCapacity:numberOfClouds];
    
    for (int i=0; i < numberOfClouds ; i++) {
        // generate image
        NSArray *imageArray = @[@"cloud_1", @"cloud_2", @"cloud_3"];
        NSUInteger randomIndex = arc4random() % [imageArray count];
        NSString *imageFileName = imageArray[randomIndex];
        
        UIImage *cloudImg = [UIImage imageNamed:imageFileName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cloudImg];
        [self.view addSubview:imageView];
        [clouds addObject:imageView];
    }
}

-(void) springClouds {
    int numberOfClouds = arc4random() % 3;
    NSLog(@"Number of clouds:%i",numberOfClouds);
    
    NSMutableArray *clouds = [[NSMutableArray alloc] initWithCapacity:numberOfClouds];
    
    for (int i=0; i < numberOfClouds ; i++) {
        // generate image
        NSArray *imageArray = @[@"cloud_1", @"cloud_2", @"cloud_3"];
        NSUInteger randomIndex = arc4random() % [imageArray count];
        NSString *imageFileName = imageArray[randomIndex];
        
        UIImage *cloudImg = [UIImage imageNamed:imageFileName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cloudImg];
        [self.view addSubview:imageView];
        [clouds addObject:imageView];
    }

    
    
    static BOOL isFirst = YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

       // [self createClouds];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.duration= 4.0;
    animation.speed =  ((double)arc4random() / ARC4RANDOM_MAX)* (0.2- 0.01)+ 0.01;
    
    for (UIImageView *imageView in clouds) {
        CGPoint p;
        p.x = -(self.view.frame.size.width);
        p.y = arc4random_uniform(screenHeight-400);
        
        CGPoint startPoint;
        startPoint.x = p.x;
        startPoint.y = p.y;
        animation.fromValue = [NSValue valueWithCGPoint:startPoint];
        CGPoint endPoint;
        endPoint.y = p.y;
        endPoint.x = self.view.frame.size.width + (self.view.frame.size.width/2);
        animation.toValue = [NSValue valueWithCGPoint:endPoint];
       [imageView.layer addAnimation:animation forKey:nil];
        imageView.layer.position = CGPointMake(endPoint.x, endPoint.y);
        
        animation.beginTime = CACurrentMediaTime() + 0.5;
        
        [imageView.layer addAnimation:animation forKey:@"basic"];
        imageView.layer.position = CGPointMake(startPoint.x, startPoint.y);
    }

    isFirst = NO;
   // [NSTimer scheduledTimerWithTimeInterval:animation.duration target:self selector:@selector(springClouds) userInfo:nil repeats:NO];
}

-(void)winter{
    
[self romoShiver];
[self startToSnow];
    
//teeth chatter, SOURCE: https://www.youtube.com/watch?v=uPMcfdG3IU4
//[self playSound:@"shiver" ofType:@"mp3" Loop:INFINITY volume:9 allowMixing:YES];
    
//wind, SOURCE:http://soundbible.com/1810-Wind.html
[self playSound:@"wind" ofType:@"mp3" Loop:INFINITY volume:6 allowMixing:YES];
}

-(void)createFlowers {
     NSUInteger numberOfFlowers = arc4random_uniform(22) + 10;
   // int numberOfFlowers = 50;
    NSLog(@"Number of flowers:%lu",(unsigned long)numberOfFlowers);
    
    flowersArray = [[NSMutableArray alloc] initWithCapacity:numberOfFlowers];
    
    for (int i=0; i < numberOfFlowers ; i++) {
        // generate image
        NSArray *imageArray = @[@"flower_1" , @"flower_2", @"flower_3", @"flower_4", @"flower_5", @"flower_6", @"flower_7", @"flower_8", @"flower_9", @"flower_10", @"flower_11", @"flower_12", @"flower_13", @"flower_14", @"flower_15", @"flower_16", @"flower_17", @"flower_18", @"flower_19", @"flower_20", @"flower_21", @"flower_22"];
        NSUInteger randomIndex = arc4random() % [imageArray count];
        NSString *imageFileName = imageArray[randomIndex];
        
        UIImage *flowerImage = [UIImage imageNamed:imageFileName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:flowerImage];
       
        [flowersArray addObject:imageView];
    }
}

-(void) startBloom {

        [self createFlowers];
    
    
    float bloomDuration = 0.0;

    for (UIImageView *imageView in flowersArray) {
       //screen size
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        CGFloat yMidpoint = CGRectGetMidY(screenRect);
        CGFloat xMidpoint = CGRectGetMidX(screenRect);
        CGFloat xExclude = 125;
        CGFloat yExclude = 100;
        
      
        
        CGPoint startPoint;
        //set random starting point for flowers
        
        do {
            startPoint.x = arc4random_uniform(screenWidth);
            startPoint.y = arc4random_uniform(screenHeight);

        } while (((startPoint.x >= (xMidpoint- xExclude)) && (startPoint.x <= (xMidpoint + xExclude)) &&
                 (startPoint.y >= (yMidpoint- yExclude)) && (startPoint.y <= (yMidpoint + yExclude))));

        
      imageView.layer.position = CGPointMake(startPoint.x, startPoint.y);

        
        //bloom animation
        CABasicAnimation* bloom = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
      
        double randomDouble = ((double)arc4random() / ARC4RANDOM_MAX)* (1.0 - 0.5)+ 0.5;
        bloom.fromValue = [NSNumber numberWithDouble:0.0];
        bloom.toValue = [NSNumber numberWithDouble:randomDouble];

        
        bloomDuration = ((double)arc4random() / ARC4RANDOM_MAX)* (20.0 - 5.0)+ 5.0;
        bloom.duration = bloomDuration;
        bloom.autoreverses = NO;
        bloom.fillMode = kCAFillModeForwards;
        bloom.removedOnCompletion = NO;
        [bloom setValue:@"Bloom" forKey:@"id"];
        bloom.delegate = self;
        
        
        //fading animation will adjust the "opacity" value of the layer
        CABasicAnimation *fade =[CABasicAnimation animationWithKeyPath:@"opacity"];;
        fade.duration = 3.0;
        fade.beginTime = bloomDuration;
        fade.autoreverses=NO;
        //justify the opacity as you like (1=fully visible, 0=unvisible)
        fade.fromValue=[NSNumber numberWithFloat:1.0];
        fade.toValue=[NSNumber numberWithFloat:0.0];
        fade.fillMode = kCAFillModeForwards;
       fade.removedOnCompletion = NO;
        fade.delegate = self;
       
        
        CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
        group.animations = @[ bloom, fade];
        group.duration = bloom.duration + fade.duration;
        group.repeatCount = 1.0;
        group.delegate = self;
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        [group setValue:@"Bloom" forKey:@"id"];
       [imageView.layer addAnimation:group forKey:@"Bloom"];
         [self.view addSubview:imageView];
        
        bloomDuration = bloom.duration;
       // self.view.backgroundColor = [UIColor whiteColor];
}
    //}
    
    [NSTimer scheduledTimerWithTimeInterval:bloomDuration target:self selector:@selector(startBloom) userInfo:nil repeats:NO];
    
}

-(void)animationDidStart:(CAAnimation *)anim{
    //Add any future keyed animation operations when the animations begin.
    
      if([[anim valueForKey:@"id"] isEqual:@"Bloom"]) {
        [self.romo removeFromSuperview];
    }

}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    
   
   //Add any future keyed animation operations when the animations are stopped.

    if([[theAnimation valueForKey:@"id"] isEqual:@"Bloom"]) {
        NSLog(@"Bloom duration:%f",theAnimation.duration);
        
//        for (UIImageView *imageView in flowersArray) {
//            imageView.layer.opacity = 0.0;
//        }
//        [self startBloom];
    }
    
    if([[theAnimation valueForKey:@"id"] isEqual:@"wow"]) {
        NSLog(@"Wow duration:%f",theAnimation.duration);
        
        //keep the last frame present but remove the animation from the layer
        animationImageView.frame = [[animationImageView.layer presentationLayer] frame];
        [animationImageView.layer removeAnimationForKey:@"wow"];
        //[animationImageView removeFromSuperview];
          }
    
    if([[theAnimation valueForKey:@"id"] isEqual:@"taste"]) {
        NSLog(@"Taste duration:%f",theAnimation.duration);
        
        //keep the last frame present but remove the animation from the layer
        animationImageView.frame = [[animationImageView.layer presentationLayer] frame];
        [animationImageView.layer removeAnimationForKey:@"taste"];
    }
    
    if([[theAnimation valueForKey:@"id"] isEqual:@"sunRising"]) {
        NSLog(@"SunRising duration:%f",theAnimation.duration);
        
        //keep the last frame present but remove the animation from the layer
     //  animationImageView.frame = [[animationImageView.layer presentationLayer] frame];
        [animationImageView.layer removeAnimationForKey:@"sunRising"];
        [self springClouds];
    }

    
}

-(void)sunAnimation{
    
    UIImage *sunImage = [UIImage imageNamed:@"sun"];
    UIImage *resizedImage = [self resizeImage:sunImage newSize:CGSizeMake(sunImage.size.width/3, sunImage.size.height/3)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:resizedImage];
    [self.view addSubview:imageView];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.fromValue = @400 ;
    animation.toValue = @75;
    animation.duration = 4;
    animation.delegate = self;
    [animation setValue:@"sunRising" forKey:@"id"];
    [imageView.layer addAnimation:animation forKey:@"basic"];
    imageView.layer.position = CGPointMake(75, 75);
    [self.romo removeFromSuperview];
    self.view.backgroundColor = UA_rgb(102, 127, 197);
    
    [UIView animateWithDuration:animation.duration animations:^{
        self.view.layer.backgroundColor = UA_rgb(210, 220, 249).CGColor;
    } completion:NULL];
}


-(void)createFlakes {
  // int numberOfSnowflakes = arc4random() % 50;
    int numberOfSnowflakes = 50;
    NSLog(@"Number of flakes:%i",numberOfSnowflakes);
 
    flakesArray = [[NSMutableArray alloc] initWithCapacity:numberOfSnowflakes];
    
    for (int i=0; i < numberOfSnowflakes ; i++) {
        // generate image
        NSArray *imageArray = @[@"snowflake_1", @"snowflake_2", @"snowflake_3", @"snowflake_4", @"snowflake_5", @"snowflake_6", @"snowflake_7", @"snowflake_8", @"snowflake_9", @"snowflake_10", @"snowflake_11", @"snowflake_12", @"snowflake_13", @"snowflake_14", @"snowflake_15"];
        NSUInteger randomIndex = arc4random() % [imageArray count];
        NSString *imageFileName = imageArray[randomIndex];
        
        UIImage *flakeImg = [UIImage imageNamed:imageFileName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:flakeImg];
        
        [flakesArray addObject:imageView];
        [self.view addSubview:imageView];
    }
}

-(void) startToSnow {
    static BOOL isFirst = YES;
    
    if (!flakesArray)
        [self createFlakes];
    
    CABasicAnimation *snowFall = [CABasicAnimation
                                      animationWithKeyPath:@"transform.translation"];
    snowFall.repeatCount = INFINITY;
    snowFall.autoreverses = NO;
    
    
    for (UIImageView *v in flakesArray) {
        CGPoint p;
        p.x = arc4random_uniform(self.view.frame.size.width);
        p.y = arc4random_uniform(self.view.frame.size.height);
        
        CGPoint startPoint;
        startPoint.x = p.x;
        startPoint.y = -p.y;
        
        
        snowFall.duration = 20.0;
        snowFall.fromValue = [NSValue valueWithCGPoint:startPoint];
        CGPoint endPoint;
        endPoint.y = self.view.frame.size.height;
        endPoint.x = p.x;
        if (!endPointArray) {
            endPointArray = [[NSMutableArray alloc] init];
        }
        [endPointArray addObject:[NSValue valueWithCGPoint:endPoint]];
        
        snowFall.toValue = [NSValue valueWithCGPoint:endPoint];
       float speed = (v.frame.size.height/(51.0-(Float32)(arc4random()%7))*9.8)/6.0;
       snowFall.speed = arc4random()%2?speed:speed*1.5;
        
        if (!animationArray) {
            animationArray = [[NSMutableArray alloc] init];
        }
        [animationArray addObject:[snowFall copy]];
        
        
        [v.layer addAnimation:snowFall forKey:@"transform.translation"];
        //[self.view addSubview:v];
        //v.layer.fillMode = kCAFillModeRemoved;
        
        
        
    }
    
    isFirst = NO;
}

-(void)romoShiver {
    UIImage *romoWinter = [UIImage imageNamed:@"ROMO_winter.png"];
    CGSize windowSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    UIImage *newsize = [self imageWithImage:romoWinter scaledToSize:windowSize];
    UIImageView *romoView = [[UIImageView alloc] initWithImage:newsize];
    
    CABasicAnimation *shiver = [CABasicAnimation animationWithKeyPath:@"position.x"];
    shiver.additive = YES; // fromValue and toValue will be relative instead of absolute values
    shiver.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    
    shiver.toValue = [NSValue valueWithCGPoint:CGPointMake(10.0, 0)]; // y increases downwards on iOS
    shiver.autoreverses = YES; // Animate back to normal afterwards
    shiver.duration = 0.05; // The duration for one part of the animation (0.2 up and 0.2 down)
    shiver.repeatCount = INFINITY; // The number of times the animation should repeat
    shiver.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [romoView.layer addAnimation:shiver forKey:@"romoShiverAnimation"];
    
    
    [self.view addSubview:romoView];
    if (romoView) {
        [self.romo removeFromSuperview];
    }
    self.view.backgroundColor = UA_rgb(149, 188, 224);
    
}


-   (void)romoCoversEarsForDuration:(float)time{
    
    UIImage *romoHands = [UIImage imageNamed:@"ROMO_hand.png"];
    
    CGSize windowSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    UIImage *newsize = [self imageWithImage:romoHands scaledToSize:windowSize];
    UIImageView *romoView = [[UIImageView alloc] initWithImage:newsize];
    
    [self.romo setEmotion:RMCharacterEmotionSad];
    [self.view addSubview:romoView];
    
   [NSTimer scheduledTimerWithTimeInterval:time target:romoView selector:@selector(removeFromSuperview) userInfo:nil repeats:NO];
    
}

# pragma mark - Queue Methods

- (void)movementTimerRun {
   
    
     if([mQueue getSize] != 0) {
     NSString *currentCmd = [mQueue popFirst];
     _movementLabel.text = currentCmd;
     [self makeMove:currentCmd];
     mDuration = [self getDuration:currentCmd];
         
         if (mDuration != -1.f) {
             
         
     [NSTimer scheduledTimerWithTimeInterval:mDuration
     target:self
     selector:@selector(movementTimerRun)
     userInfo:nil
     repeats:NO];
         }
     }
     
     else {
     _movementLabel.text = @"mQueue Empty";
     mDuration = -1.f;
     }

     
    
    /*
   rm = [movementQueue getFirstMove];
    if( rm != nil) {
        
      //  [self makeMove];
        
        if ((rm.angle == 0.0) || (!rm.angle)) {
        
            
            [NSTimer scheduledTimerWithTimeInterval:rm.duration
                                         target:self
                                       selector:@selector(movementTimerRun)
                                       userInfo:nil
                                        repeats:NO];
            
        _movementLabel.text = driveMotion;
        }
        
        }
    
    else {
        _movementLabel.text = @"movementQueue is empty";
    }
     */
}

- (void)emotionTimerRun {
    
    
     if([eQueue getSize] != 0) {
     NSString *currentCmd = [eQueue popFirst];
     //_emotionLabel.text = currentCmd;
         
     [self makeEmotion:currentCmd withExpression:currentCmd];
     eDuration = [self getDuration:currentCmd];
         _emotionLabel.text = [NSString stringWithFormat:@"%f", eDuration];
         
     [NSTimer scheduledTimerWithTimeInterval:eDuration
     target:self
     selector:@selector(emotionTimerRun)
     userInfo:nil
     repeats:NO];
     }
     else {
     _emotionLabel.text = @"emotionQueue is empty";
     eDuration = -1.f;
     }

     /*
    
    re = [movementQueue getFirstEmotion];
    if( re != nil) {
        [self ];
        
        [NSTimer scheduledTimerWithTimeInterval:re.emotionDuration
                                         target:self
                                       selector:@selector(emotionTimerRun)
                                       userInfo:nil
                                        repeats:NO];
        
        _emotionLabel.text = [NSString stringWithFormat: @"Exp:%@, Dur:%8.2f", re.expressions[re.rExpression], re.emotionDuration];
            }
    else {
        _emotionLabel.text = @"emotionQueue is empty";
       
    }
      */
}


 
 - (void)makeMove:(NSString *) mCmd {
 _movementLabel.text = mCmd;
 
 // get tilt
 float tiltAngle = 90.0;
 NSString *tiltStr = [self extractString:mCmd
 toLookFor:@"TILT:"
 skipForwardX:5
 toStopBefore:@" "];
 if(tiltStr != nil) {
 tiltAngle = [tiltStr floatValue];
 [self.robot tiltToAngle:tiltAngle completion:nil];
 }
 
 // get type
 int mType = -1;
 NSString *typeStr = [self extractString:mCmd
 toLookFor:@"MOVE:"
 skipForwardX:5
 toStopBefore:@" "];
 if(typeStr != nil) {
 mType = [typeStr intValue];
 // NSLog(@"MOVE: %d", mType);
 }
 
 // get speed
 NSString *speedStr = [self extractString:mCmd
 toLookFor:@"SPEED:"
 skipForwardX:6
 toStopBefore:@" "];
 float speed = 0.f;
 if(speedStr != nil) {
 speed = [speedStr floatValue];
 // NSLog(@"Speed: %f", speed);
 }
 
 // get radius
 NSString *radiusStr = [self extractString:mCmd
 toLookFor:@"RADIUS:"
 skipForwardX:7
 toStopBefore:@" "];
 float radius = 0.f;
 if(radiusStr != nil) {
 radius = [radiusStr floatValue];
 // NSLog(@"Radius: %f", radius);
 }
 // get angle
 NSString *angleStr = [self extractString:mCmd
 toLookFor:@"ANGLE:"
 skipForwardX:6
 toStopBefore:@" "];
 float angle = 0.f;
 if(angleStr != nil) {
 angle = [angleStr floatValue];
 // NSLog(@"Angle: %f", angle);
 }
 // parse the type
 switch (mType) {
 case 0: {
 [self.robot driveForwardWithSpeed:speed];
 break;
 }
 case 1: {
 [self.robot driveBackwardWithSpeed:speed];
 break;
 }
 case 2: {
 [self.robot stopDriving];
 break;
 }
 case 3: {
 [self.robot driveWithRadius:radius speed:speed];
 break;
 }
 case 4: {
 [self.robot turnByAngle:angle withRadius:radius completion:nil];
 break;
 }
 case 5: {
 [self.robot turnByAngle:angle withRadius:radius
 finishingAction:RMCoreTurnFinishingActionStopDriving completion:nil];
 break;
 }
 case 6: {
 [self.robot turnByAngle:angle withRadius:radius speed:speed finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
     [self movementTimerRun];
 }];
 break;
 }
 case 7: {
 //            [self.robot turnToHeading: withRadius:<#(float)#> finishingAction:<#(RMCoreTurnFinishingAction)#> completion:<#^(BOOL success, float heading)completion#>];
 break;
 }
 case 8: {
 //            [self.robot turnToHeading:<#(float)#> withRadius:<#(float)#> speed:<#(float)#> forceShortestTurn:<#(BOOL)#> finishingAction:<#(RMCoreTurnFinishingAction)#> completion:<#^(BOOL success, float heading)completion#>];
 break;
 }
 default: {
 NSLog(@"mCmd Error");
 }
 }
 }
 
/*
 -(void) makeEmotion:(NSString *)eCmd {
 
 // Expression setting
 int emotionEnum = -2;
 NSString *emotionStr = [
 WEĖWWEextractString:eCmd
 toLookFor:@"EXPR:"
 skipForwardX:5
 toStopBefore:@" "];
 if(emotionStr != nil) {
 emotionEnum = [emotionStr intValue];
 // NSLog(@"Expression: %d", expressionEnum);
 }
 if(emotionEnum != -2) {
 [self emotionWithParam:emotionEnum];
 }
 }
 */

//Tabassum added for Romo Character

 -(void) makeEmotion:(NSString *)eCmd
      withExpression:(NSString *)exCmd{
 
 // Expression setting
 int emotionEnum = -2;
 int expressionEnum = -2;
     
 NSString *emotionStr = [self extractString:eCmd
 toLookFor:@"EMOT:"
 skipForwardX:5
 toStopBefore:@" "];
     
 NSString *expressionStr = [self extractString:exCmd
 toLookFor:@"EXPR:"
 skipForwardX:5
 toStopBefore:@" "];

 if((emotionStr != nil) && (expressionStr != nil)) {
 re.rEmotion = [emotionStr intValue];
 re.rExpression = [expressionStr intValue];
 // NSLog(@"Expression: %d", expressionEnum);
 }
 if((emotionEnum != -2) && (expressionEnum != -2)) {
     [self emotionWithParam:re.rEmotion expressionWithParam:re.rExpression];
 }
}
 
 
 - (NSString *)extractString:(NSString *)fullString
 toLookFor:(NSString *)lookFor
 skipForwardX:(NSInteger)skipForward
 toStopBefore:(NSString *)stopBefore {
 
 NSRange firstRange = [fullString rangeOfString:lookFor];
 if(firstRange.location != NSNotFound) {
 NSRange secondRange = [[fullString substringFromIndex:firstRange.location + skipForward] rangeOfString:stopBefore];
 if(secondRange.location != NSNotFound) {
 NSRange finalRange = NSMakeRange(firstRange.location + skipForward,
 secondRange.location + [stopBefore length] - 1);
 return [fullString substringWithRange:finalRange];
 }
 }
 return nil;
 }
 
 
 
 -(float) getDuration:(NSString *)cmd {
 // NSLog(@"getDuration: %@", cmd);
 float duration;
 NSString *attr = [self extractString:cmd
 toLookFor:@"DURATION:"    // length(DURATION:) == 9
 skipForwardX:9
 toStopBefore:@" "];
 if(attr != nil) {
 // NSLog(@"\n\n DURATION: %@",attr);
 duration = [attr floatValue];
 return duration;
 }
 else
 return -1.f;
 }


- (void)emotionWithParam:(int)currentEmotion expressionWithParam:(int)currentExpression {
    
    re.rExpression = currentExpression;
    re.rEmotion = currentEmotion;
    
        if (re.rExpression == 33) {
            [self romoCoversEarsForDuration:re.emotionDuration];
        }
        if (re.rExpression == 34){
            //enter custom animation
        }
    
        else if((re.rExpression >= 0 && re.rExpression <= 32) || (re.rEmotion > 0 && re.rEmotion <= 10 )){
            
            [self.romo setExpression:re.rExpression withEmotion:re.rEmotion];
            re.emotionDuration += [re expressionDuration:re.expressions[re.rExpression]];
            [self scenarioSound];
        }
    
}

/*
-(void)setEmotion{

   if ((re.rExpression) || (re.rEmotion)) {
       
       if ((re.rExpression == 33) && (re.rEmotion == RMCharacterEmotionSad)) {
            [self romoCoversEarsForDuration:re.emotionDuration];
           
       }
       else if (re.rExpression == 34){
           [self tasteAnimation];
       }
       else if(re.rExpression != 33 || (re.rExpression != 34)){
          
           [self.romo setExpression:re.rExpression withEmotion:re.rEmotion];
           re.emotionDuration += [re expressionDuration:re.expressions[re.rExpression]];
          // [self scenarioSound];
       }
       
       
    }
    
    else if (re.eyesClosed == YES ){
        [self.romo setLeftEyeOpen:NO rightEyeOpen:NO];
    }
   }


- (void)makeMove
{
    
        // drive forwards with duration and speed
     if ((rm.speed > 0.0) && ((rm.duration >0.0) || (rm.distance >0.0)) && (rm.angle == 0.0) && (rm.radius == 9999)) {
    
        if ((rm.distance > 0.0) && (rm.duration == 0.0)){
            //set time to new value
            [rm setDuration:ABS(rm.distance/rm.speed)];
            NSLog(@"motion duration:%f", rm.duration);
        }
        
        [self.robot driveForwardWithSpeed:rm.speed];
         driveCommand = RMCoreDriveCommandForward;
    }
    

    //drive backwards with speed and duration
    else if ((rm.speed < 0.0) && ((rm.duration > 0.0) || (rm.distance > 0.0)) && (rm.angle == 0.0) && (rm.radius = 9999)) {
        
        if ((rm.distance > 0.0) && (rm.duration == 0.0)){
            //set time to new value
            [rm setDuration:ABS((rm.distance/rm.speed))];
            NSLog(@"motion duration:%f", rm.duration);
        }
        [self.robot driveForwardWithSpeed:rm.speed];
        driveCommand = RMCoreDriveCommandBackward;
    }
    
    //drive with radius
    else if ((rm.speed != 0.0) && ((rm.duration > 0.0) || (rm.distance > 0.0)) && (rm.angle == 0.0) && (rm.radius !=9999 )) {
        
        if ((rm.distance > 0.0) && (rm.duration == 0.0)){
            //set time to new value
            [rm setDuration:ABS((rm.distance/rm.speed))];
            NSLog(@"motion duration:%f", rm.duration);
        }
        [self.robot driveWithRadius:rm.radius speed:rm.speed];
        driveCommand = RMCoreDriveCommandWithRadius;
    }
    
    //turnBy angle
    
    else if ((rm.speed > 0.0) && (rm.angle != 0.0) && (rm.distance == 0.0) && (rm.duration == 0.0)){
        
        
        [self.robot turnByAngle:rm.angle withRadius:rm.radius speed:rm.speed finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
            [self movementTimerRun];
        }];

       
    }
    
    else if(rm.headTiltAngle != 0.0)
    {
        [self.robot tiltToAngle:rm.headTiltAngle completion:nil];
        
    }

    else
        [self.robot stopDriving];
   
    
}
*/

#pragma mark - Custom Audio Methods


/* Use this method to play an audio file */
- (void)playSound:(NSString *)audio
           ofType:(NSString *)type
             Loop:(int)loop
           volume:(int)vol
      allowMixing:(BOOL)mixing
{
   if (mixing == YES) {
//        UInt32 allowMixing = true;
//        
//
//        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing);
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];

}
    
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:audio
//                                                               ofType:type];
//    NSURL *soundFileURL = [NSURL fileURLWithPath:path];
//   audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
//                                                    error:nil];
//    audioPlayer.numberOfLoops = loop;
//    audioPlayer.volume = vol;
//    [self.audioPlayer setDelegate:self];
//    [self.audioPlayer play];
    
    
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:audio ofType:type];
    NSError *soundError = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioFile] error:&soundError];
    if(self.audioPlayer == nil)
        NSLog(@"%@",soundError);
    else
    {
        //[self.audioPlayer setDelegate:AVAudioPlayer];
        [self.audioPlayer setVolume:vol];
        [self.audioPlayer setNumberOfLoops:loop];
        [self.audioPlayer play];
    }

}

-(void)scenarioSound{
    if (re.rExpression == RMCharacterExpressionAngry) {
        //        UInt32 allowMixing = true;
        //
        //        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing);
        [self playSound:@"alarmSound8" ofType:@"caf"  Loop:-1 volume:10 allowMixing:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:[re expressionDuration:@"Angry"]+1.0 target:self selector:@selector(stop) userInfo:nil repeats:NO];
        
    }
    else if (re.rEmotion == RMCharacterEmotionScared){
        //SOURCE : RMCharacterExpressionScared
        [self playSound:@"surprised" ofType:@"caf" Loop:0 volume:10 allowMixing:YES];
        
    }
    
}

-(void)vibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(vibrate) userInfo:nil repeats:YES];
}



#pragma mark - Optional Methods / Helper Methods



- (UIImage *)resizeImage:(UIImage*)_image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = _image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    //Calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    //Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    //Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    //Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)getRandomEmotion
{
    int numberOfEmotions = 10;
    // Choose a random expression from 1 to numberOfEmotions
    // That's different from the current emotion
    RMCharacterEmotion randomEmotion = (arc4random() % numberOfEmotions);
    re.rEmotion = randomEmotion;
    [self.romo setEmotion:randomEmotion];
    
    
}

-(void)getRandomExpression
{
    int numberOfExpressions = 33;
    // Choose a random expression from 1 to numberOfExpressions
    // That's different from the current expression
    RMCharacterExpression randomExpression = arc4random() % numberOfExpressions;
    re.rExpression = randomExpression;
    [self.romo setExpression:randomExpression];
}

-(void)takeScreenShot
{
    // create graphics context with screen size
    CGRect screenRect = //[[UIScreen mainScreen] bounds];
    CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    // grab reference to our window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // transfer content into our context
    [window.layer renderInContext:ctx];
    UIImage *screengrab = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // save screengrab to Camera Roll
    UIImageWriteToSavedPhotosAlbum(screengrab, nil, nil, nil);
}

- (UIImage *)imageWithImage:(UIImage *)_image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [_image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



-(NSString *)driveMotion {
    switch (driveCommand) {
        case RMCoreDriveCommandForward:
            driveMotion = @"Forward";
            break;
        case RMCoreDriveCommandBackward:
            driveMotion = @"Backward";
            break;
        case RMCoreDriveCommandStop:
            driveMotion = @"Stopped";
            break;
        case RMCoreDriveCommandTurn:
            driveMotion = @"Turned";
            break;
        case RMCoreDriveCommandWithRadius:
            driveMotion = @"wRadius";
            break;
        default:
            driveMotion = @"Unknown";
            break;
    }
    return driveMotion;
}



#pragma mark - OpenEarsEventsObserverDelegate

- (void)speechRecognition {
    OELanguageModelGenerator *lmGenerator = [[OELanguageModelGenerator alloc] init];
    
    //    NSArray *words = [NSArray arrayWithObjects:@"TURN", @"STOP", @"FORWARD", @"EXPRESSION", @"HAPPY", @"SAD", nil];
    
    NSDictionary *commands =  @{
                                ThisWillBeSaidOnce : @[
                                        @{ OneOfTheseWillBeSaidOnce : @[@"TURN", @"DRIVE", @"ROTATE", @"STOP"]},
                                        @{ThisWillBeSaidWithOptionalRepetitions : @[
                                                  @{ OneOfTheseWillBeSaidOnce : @[@"FORWARD", @"BACKWARD", @"AROUND", @"MOVING"]},
                                                  @{ OneOfTheseCanBeSaidOnce : @[@"NINETY", @"FOURTY-FIVE", @"ONE", @"TWO", @"THREE"]}
                                                  ]},
                                        @{ OneOfTheseCanBeSaidOnce : @[@"DEGREES", @"SECOND", @"SECONDS"]},
                                        ]
                                };
    ;
    
    NSString *name = @"romoCommands";
    //    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to create a Spanish language model instead of an English one.
    
    NSError *err = [lmGenerator generateGrammarFromDictionary:commands withFilesNamed:name forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]];
    
    NSString *lmPath = nil;
    NSString *dicPath = nil;
    
    if(err == nil) {
        lmPath = [NSString stringWithFormat:@"%@/romoCommands.%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0],@"gram"];
        
        //lmPath = [lmGenerator pathToSuccessfullyGeneratedLanguageModelWithRequestedName:@"romoCommands"];
        dicPath = [NSString stringWithFormat:@"%@/romoCommands.%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0],@"dic"];
        
        //dicPath = [lmGenerator pathToSuccessfullyGeneratedDictionaryWithRequestedName:@"commands"];
        
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    
    [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
    [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:TRUE]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to perform Spanish recognition instead of English.
    
    //speech synthesis
    //    self.fliteController = [[OEFliteController alloc] init];
    //    self.slt = [[Slt alloc] init];
    
    
    self.openEarsEventsObserver = [[OEEventsObserver alloc] init];
    [self.openEarsEventsObserver setDelegate:self];
}


- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    
     NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
   // long recScore = recognitionScore.integerValue;
    if ([hypothesis  isEqualToString:@"DRIVE FORWARD"] ) {
        
        [self.robot driveForwardWithSpeed:0.2];
    }
    if ([hypothesis isEqualToString:@"STOP MOVING"]){
            [self.robot stopDriving];
        }
    if ([hypothesis isEqualToString:@"DRIVE FORWARD TWO SECONDS"]) {
        [self.robot driveForwardWithSpeed:0.2];
        [self.robot performSelector:@selector(stopDriving) withObject:nil afterDelay:2.0];
    }
    if ([hypothesis isEqualToString:@"TURN AROUND"]) {
        [self.robot turnByAngle:180 withRadius:0.0 speed:0.2 finishingAction:RMCoreTurnFinishingActionStopDriving completion:nil];
    }

    
}

- (void) pocketsphinxDidStartListening {
    NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
    NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
    NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
    NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
    NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
    NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
    NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening setup wasn't successful and returned the failure reason: %@", reasonForFailure);
}

- (void) pocketSphinxContinuousTeardownDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening teardown wasn't successful and returned the failure reason: %@", reasonForFailure);
}

- (void) testRecognitionCompleted {
    NSLog(@"A test file that was submitted for recognition is now complete.");
}

#pragma mark - CLLocationManagerDelegate

- (void)initializeLocationManager {
    // Create location manager with filters set for battery efficiency.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLLocationAccuracyBest;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager headingAvailable]) {
        // Start updating location changes.
        [locationManager startUpdatingLocation];
        
        // Start heading updates.
        
        //locationManager.headingFilter = 6;
        [locationManager startUpdatingHeading];
        
    } else {
        NSLog(@"Can't report heading");
    }
    
}


- (void) checkLocationManager
{
    if(![CLLocationManager locationServicesEnabled])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Location Services turned off"
                                           message:@"You need to enable Location Services"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
        //[self showMessage:@"You need to enable Location Services"];
        //        return  FALSE;
    }
    if(![CLLocationManager isMonitoringAvailableForClass:CLCircularRegion.class])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Region monitoring is not available"
                                           message:@"Region monitoring is not available for this Class"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
        
        //[self showMessage:@"Region monitoring is not available for this Class"];
        //        return  FALSE;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
    {
        alert = [[UIAlertView alloc] initWithTitle:@"You need to authorize Location Services for the APP"
                                           message:@"You need to authorize Location Services for the APP"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
        
        // [self showMessage:@"You need to authorize Location Services for the APP"];
        //        return  FALSE;
    }
    //    return TRUE;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}



- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    
    if (newHeading.headingAccuracy > 0){
        
        magneticHeading = [NSNumber numberWithDouble:newHeading.magneticHeading];
        NSLog(@"mageticHeading:%f",[magneticHeading floatValue]);
        trueHeading = [NSNumber numberWithDouble:newHeading.trueHeading];
         NSLog(@"True Heading:%f",[trueHeading floatValue]);
        //debugLabel.text =[NSString stringWithFormat:@"%f",mageticHeading];
    
       // heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
        //NSLog(@"Heading:%f",heading);
        return;
    }
}

#pragma mark - Precision Turning Functions: FOR QUEUE

/*
-(void) queueTurnWithHeading:(float)angle
                      radius:(float)radius
                       speed:(float)speed
               withPrecision:(float)degrees
{
    headingPrecision = degrees;
    angleToTurn = 0.0;
    
    [self.robot turnToHeading:angle withRadius:radius speed:speed forceShortestTurn:YES finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
        if (success) {
            
            currentHeading = heading;
            //             if ((((currentHeading >= angleToTurn) && (currentHeading <= angleToTurn+headingPrecision))) || (((currentHeading <= angleToTurn) && (currentHeading >= angleToTurn-headingPrecision)))) {
            //                debugLabel.text  = [NSString stringWithFormat:@"cH:%f",currentHeading];
            //                [self movementTimerRun];
            
            // }
            // else
            [self queueTurnErrorHandling];
        
        }
    }];
}

-(void)queueTurnErrorHandling{
    

    minAngleValue = rm.angle - headingPrecision;
    maxAngleValue = rm.angle + headingPrecision;
    

    if ((currentHeading >= minAngleValue) && (currentHeading < maxAngleValue)) {
        debugLabel.text  = [NSString stringWithFormat:@"cH:%f",currentHeading];
        [self movementTimerRun];
    }
    
    
//    if ((((currentHeading >= rm.angle) && (currentHeading <= (rm.angle+headingPrecision)))) || (((currentHeading <= rm.angle) && (currentHeading >= (rm.angle-headingPrecision))))) {
//        debugLabel.text  = [NSString stringWithFormat:@"cH:%f",currentHeading];
//        [self movementTimerRun];
//    }

    
      // if ((rm.angle > 0.0) || (angleToTurn > 0.0)) {
    
    else if ((currentHeading <= minAngleValue) || (currentHeading >= maxAngleValue)) {
        
        if ((currentHeading > rm.angle) ) { //&& (currentHeading > 0.0)
            float difference = currentHeading - rm.angle;
           // if (difference > headingPrecision) {
                angleToTurn = -difference;
            
                
                [self.robot turnByAngle:angleToTurn
                             withRadius:rm.radius
                                  speed:rm.speed
                        finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
                            
                            minAngleValue = angleToTurn - headingPrecision;
                            maxAngleValue = angleToTurn + headingPrecision;

                            currentHeading = heading;
                            [self queueTurnErrorHandling];
                            
                        }];
            //}
        }
    
        else if (currentHeading < rm.angle ) { // && (currentHeading > 0.0
            float difference = rm.angle - currentHeading;
            //if (difference > headingPrecision) {
                angleToTurn = difference;
            
                           [self.robot turnByAngle:angleToTurn
                             withRadius:rm.radius
                                  speed:rm.speed
                        finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
                            
                            minAngleValue = angleToTurn - headingPrecision;
                            maxAngleValue = angleToTurn + headingPrecision;

                                currentHeading = heading;
                                [self queueTurnErrorHandling];
                            

                        }];
            //}
        }
    
}

       //} // end of positive angle input
    
//
////    //else if ((rm.angle < 0.0) || (angleToTurn < 0.0)){
////        
////        
////        if ((currentHeading < rm.angle) && (currentHeading < 0.0)) {
////            float difference = rm.angle - currentHeading;
////            if (difference > headingPrecision) {
////                angleToTurn = difference;
////                
////                [self.robot turnByAngle:angleToTurn
////                             withRadius:rm.radius
////                                  speed:rm.speed
////                        finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
////                            
////                            currentHeading = heading;
////                            [self queueTurnErrorHandling];
////                            
////                        }];
////            }
////        }
////        
////        else if ((currentHeading > rm.angle) && (currentHeading < 0.0)) {
////            float difference = currentHeading - rm.angle;
////            if (difference > headingPrecision) {
////                angleToTurn = -difference;
////                
////                
////                [self.robot turnByAngle:angleToTurn
////                             withRadius:rm.radius
////                                  speed:rm.speed
////                        finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
////                            
////                            currentHeading = heading;
////                            [self queueTurnErrorHandling];
////                            
////                        }];
////            }
////            
////        }
    }


    */


#pragma mark - precision Turning Functions

/*
- (void)turnToHeading:(float)_angle
                speed:(float)_speed
               radius:(float)_radius
        withPrecision:(float)_degrees
{
    
    headingPrecision = _degrees;
    currentHeading = 0.0;
    
    [self.robot turnToHeading:_angle withRadius:_radius speed:_speed forceShortestTurn:NO finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
        
        currentHeading = heading;
        [self turnErrorHandling];
        }];
}


-(void)turnErrorHandling{
    
    minAngleValue = angle - headingPrecision;
    maxAngleValue = angle + headingPrecision;
    
    if (angle > 0) {
        
        //check if within range
        if (maxAngleValue > 180.0) {
           maxAngleValue = -180.0 + (headingPrecision -  (180.0 - angle));
            if ((currentHeading >= minAngleValue && currentHeading <= 180.0) ||
                (currentHeading <= maxAngleValue && currentHeading >= -180.0)) {
                debugLabel.text  = [NSString stringWithFormat:@"Turn Complete:%f",currentHeading];
                angle = 0.0;
                angleToTurn = 0.0;
            }
            //if not within range, turn again
            else {
                if (currentHeading > maxAngleValue) {
                    angleToTurn = ((180+currentHeading) + (180 - angle));
                }
                else if (currentHeading < minAngleValue){
                    angleToTurn = currentHeading - angle;
                }
                angle = angleToTurn;
                [self.robot turnByAngle:angle
                             withRadius:radius
                                  speed:speed
                 finishingAction:RMCoreTurnFinishingActionStopDriving
                             completion:^(BOOL success, float heading) {
                                 currentHeading = heading;
                                 [self turnErrorHandling];
                             }];
            }
            
        }
        //check if within range
        else
            if ((currentHeading >= minAngleValue) && (currentHeading <= maxAngleValue) ) {
                debugLabel.text  = [NSString stringWithFormat:@"Turn Complete:%f",currentHeading];
                angle = 0.0;
                angleToTurn = 0.0;

            }
            //if not within range then turn again
            else {
                    angleToTurn = angle - currentHeading;
                [self.robot turnByAngle:angle
                             withRadius:radius
                                  speed:speed
                        finishingAction:RMCoreTurnFinishingActionStopDriving
                             completion:^(BOOL success, float heading) {
                                 currentHeading = heading;
                                 [self turnErrorHandling];
                             }];
                }
        
        
    }
    else if (angle < 0){
        
        if (minAngleValue <= -180) {
    
        
            if ((currentHeading <= maxAngleValue && currentHeading >= -180) ||
            (currentHeading >= minAngleValue && currentHeading <= 180)) {
            debugLabel.text  = [NSString stringWithFormat:@"Turn Complete:%f",currentHeading];
                angle = 0.0;
                angleToTurn = 0.0;

            }
            //if not within range, turn again
            else {
                if (currentHeading < minAngleValue) {
                    angleToTurn = ((180 - currentHeading) + (180 + angle));
                }
                else if (currentHeading > maxAngleValue){
                    angleToTurn = angle - currentHeading;
                }
                angle = angleToTurn;
                [self.robot turnByAngle:angle
                             withRadius:radius
                                  speed:speed
                        finishingAction:RMCoreTurnFinishingActionStopDriving
                             completion:^(BOOL success, float heading) {
                                 currentHeading = heading;
                                 [self turnErrorHandling];
                             }];
            }

            
        }
        else
            if (currentHeading >= minAngleValue && currentHeading <= maxAngleValue){
                debugLabel.text  = [NSString stringWithFormat:@"Turn Complete:%f",currentHeading];
                angle = 0.0;
                angleToTurn = 0.0;

            }
        //if not within range then turn again
            else {
                angleToTurn = angle - currentHeading;
                [self.robot turnByAngle:angle
                             withRadius:radius
                                  speed:speed
                        finishingAction:RMCoreTurnFinishingActionStopDriving
                             completion:^(BOOL success, float heading) {
                                 currentHeading = heading;
                                 [self turnErrorHandling];
                             }];
            }


        
    }
    
    
//    if ((currentHeading >= minAngleValue) && (currentHeading < maxAngleValue)) {
//        debugLabel.text  = [NSString stringWithFormat:@"cH:%f",currentHeading];
//        nil;
//    }
//    
//    else if ((currentHeading <= minAngleValue) || (currentHeading >= maxAngleValue)) {
//        
//        if ((currentHeading > angle) ) { //&& (currentHeading > 0.0)
//            float difference = currentHeading - angle;
//            // if (difference > headingPrecision) {
//            angleToTurn = -difference;
//            
//            
//            [self.robot turnByAngle:angleToTurn
//                         withRadius:radius
//                              speed:speed
//                    finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
//                        
//                        minAngleValue = angleToTurn - headingPrecision;
//                        maxAngleValue = angleToTurn + headingPrecision;
//                        
//                        currentHeading = heading;
//                        [self turnErrorHandling];
//                        
//                    }];
//            //}
//        }
//        
//        else if (currentHeading < angle ) { // && (currentHeading > 0.0
//            float difference = angle - currentHeading;
//            //if (difference > headingPrecision) {
//            angleToTurn = difference;
//            
//            [self.robot turnByAngle:angleToTurn
//                         withRadius:radius
//                              speed:speed
//                    finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
//                        
//                        minAngleValue = angleToTurn - headingPrecision;
//                        maxAngleValue = angleToTurn + headingPrecision;
//                        
//                        currentHeading = heading;
//                        [self turnErrorHandling];
//                        
//                        
//                    }];
//            //}
//        }
//        
//    }


   
    
    
    //}

    
//    if (rm.angle > 0.0 && rm.angle <=180.0) {
//        
//        
//        if ((currentHeading > rm.angle) && (currentHeading > 0.0))
//        {
//            float difference = currentHeading - rm.angle;
//            if (difference > headingPrecision) {
//                angleToTurn = -difference;
//                
//                [self.robot turnByAngle:angleToTurn
//                             withRadius:rm.radius
//                                  speed:rm.speed
//                        finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
//                            
//                            currentHeading = heading;
//                            [self turnErrorHandling];
//                            
//                            
//                        }];
//            }
//            else
//                debugLabel.text  = [NSString stringWithFormat:@"cH:%f",currentHeading];
//            nil;
//        }
//        else if ((currentHeading < rm.angle) && (currentHeading > 0.0))
//        {
//            float difference = rm.angle - currentHeading;
//            if (difference > headingPrecision) {
//                angleToTurn = difference;
//                
//                [self.robot turnByAngle:angleToTurn
//                             withRadius:rm.radius
//                                  speed:rm.speed
//                        finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
//                            
//                            
//                            currentHeading = heading;
//                            [self turnErrorHandling];
//                            
//                        }];
//            }
//            else
//                debugLabel.text  = [NSString stringWithFormat:@"cH:%f",currentHeading];
//            nil;
//        }
//    }
//    
//    else if (rm.angle < 0.0 && rm.angle>=-180){
//        
//        
//        if ((currentHeading < rm.angle) && (currentHeading < 0.0)) {
//            float difference = rm.angle - currentHeading;
//            if (difference > headingPrecision) {
//                angleToTurn = difference;
//                
//                [self.robot turnByAngle:angleToTurn
//                             withRadius:rm.radius
//                                  speed:rm.speed
//                        finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
//                            
//                            currentHeading = heading;
//                            [self turnErrorHandling];
//                            
//                        }];
//            }
//            else
//                debugLabel.text  = [NSString stringWithFormat:@"cH:%f",currentHeading];
//            nil;
//        }
//        
//        else if ((currentHeading > rm.angle) && (currentHeading < 0.0)) {
//            float difference = currentHeading - rm.angle;
//            if (difference > headingPrecision) {
//                angleToTurn = -difference;
//                
//                
//                [self.robot turnByAngle:angleToTurn
//                             withRadius:rm.radius
//                                  speed:rm.speed
//                        finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
//                            
//                            currentHeading = heading;
//                            [self turnErrorHandling];
//                            
//                        }];
//            }
//            else
//                debugLabel.text  = [NSString stringWithFormat:@"cH:%f",currentHeading];
//            nil;
//            
//        }
//        
//    }
//    debugLabel.text  = [NSString stringWithFormat:@"cH:%f",currentHeading];
//    nil;
    
}
*/


#pragma mark - Gesture Recognizers

- (void)swipedLeft:(UIGestureRecognizer *)sender {
    _emotionLabel.text = @"swipedLeft";
    debugLabel.text=nil;
    
    [self emotionTimerRun];
    [self movementTimerRun];
    
}

/*
- (void)testTurnwithAngle:(float)_angle{
    currentHeading = self.locationManager.heading.magneticHeading;
    headingPrecision = 1.0;
    angle =_angle;

    [self.robot turnByAngle:angle withRadius:0.0 speed:0.2 finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
        [self testTurnError];
        
    }];
}

- (void)testTurnError{
    float expectedHeading;
    if (angle >0){ // means turn CCW
        
        if (currentHeading > angle) {
            expectedHeading = currentHeading - angle;
        }
        else if (currentHeading < angle){
            expectedHeading = 360 - (angle - currentHeading);
        }
        
        currentHeading = self.locationManager.heading.magneticHeading;
        minAngleValue = expectedHeading - headingPrecision;
        maxAngleValue = expectedHeading + headingPrecision;
        
        if (currentHeading >= minAngleValue && currentHeading <= maxAngleValue) {
            debugLabel.text = [NSString stringWithFormat:@"current:%8.1f, nH:%8.1f", currentHeading, expectedHeading];
            //ended
        }
        else //continue turn
            if (currentHeading > maxAngleValue) {
                angle = currentHeading - maxAngleValue;
                debugLabel.text = [NSString stringWithFormat:@"angle:%8.1f, current:%8.1f, nH:%8.1f",angle, currentHeading, expectedHeading];
            }
            else if (currentHeading < minAngleValue){
                angle = currentHeading-minAngleValue;
                debugLabel.text = [NSString stringWithFormat:@"angle:%8.1f, current:%8.1f, nH:%8.1f",angle, currentHeading, expectedHeading];
            }
            [self.robot turnByAngle:angle withRadius:0.0 speed:0.2 finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
               //start check again
                }];
                
                
            }
    else if (angle < 0) { // means turn CW
        if (currentHeading > -angle) {
            expectedHeading = currentHeading - angle;
        }
        else if (currentHeading < -angle){
            expectedHeading = 360 - (angle - currentHeading);
        }
    }
}
*/
- (void)swipedRight:(UIGestureRecognizer *)sender {
    _emotionLabel.text = @"swipedRight";
    
    expressionLabel.text = nil;
    emotionLabel.text = nil;
    
    
   // [self testTurnwithAngle:180];

//    [self.robot turnToHeading:179 withRadius:0.0 speed:0.2 forceShortestTurn:YES finishingAction:RMCoreTurnFinishingActionStopDriving completion:^(BOOL success, float heading) {
//        debugLabel.text = [NSString stringWithFormat:@"cH:%f",heading];
//
//    }];
    
   // [self turnToHeading:-180 speed:0.2 radius:0.0 withPrecision:1.0];
    
   // [self turnWithHeading:-180 speed:0.2 radius:0.0 withPrecision:1.0];
    
    //[self turnWithHeading:-135 speed:0.2 radius:0.0 withPrecision:0.5];
}

- (void)swipedUp:(UIGestureRecognizer *)sender {
    _emotionLabel.text = @"swipedUp";
    debugLabel.text=nil;
    
    //test methods
    //[self tasteAnimation];
    //[self romoCoversEarsForDuration:5.0];
    //[self startBloom];
    //[self testAnimation];
    //[self winter];
    // [self springClouds];
    //[self springClouds];
    [self sunAnimation];
    
}

- (void)swipedDown:(UIGestureRecognizer *)sender {
    _emotionLabel.text = @"swiped Down";
    debugLabel.text=nil;
    [self getRandomEmotion];
}

- (void)tappedScreen:(UIGestureRecognizer *)sender {
    _emotionLabel.text = @"tapped";
    // robot stop
    [self.robot stopDriving];
    [debugLabel removeFromSuperview];
   
}

- (void)doubleTappedScreen:(UIGestureRecognizer *)sender {
    [debugLabel removeFromSuperview];
    [_emotionLabel removeFromSuperview];
    [self takeScreenShot];
}


- (void)addGestureRecognizers
{
    // Let's start by adding some gesture recognizers with which to interact with Romo
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(swipedLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(swipedRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(swipedUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(swipedDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(tappedScreen:)];
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doubleTappedScreen:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
}

#pragma mark - Romo Notifications

- (void)initializeRomoNotifications {
    //HeadTilt speed changed notification
    [[NSNotificationCenter defaultCenter] addObserver:(self) selector:@selector(DriveSpeedChanged:) name:(@"RMCoreRobotHeadTiltSpeedDidChangeNotification") object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:(self) selector:@selector(ExpressionFinish:) name:(@"RMCharacterDidFinishExpressingNotification") object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:(self) selector:@selector(ExpressionBegin:) name:(@"RMCharacterDidBeginExpressingNotification") object:nil];
}

-(void)DriveSpeedChanged:(NSNotification *)note{
    
    //just to test
    debugLabel.text = [NSString stringWithFormat:@"Speed changed to %f m/s",rm.speed];
}


-(void)ExpressionBegin:(NSNotification *)note{
    if (self.romo.expression) {
        [self.view addSubview:debugLabel];
        expressionLabel.text = re.expressions[re.rExpression];
        emotionLabel.text = nil;
        
        //debugLabel.text =[NSString stringWithFormat:@"Expression: %@ duration: %8.2f sec",re.expressions[re.rExpression], [self.re expressionDuration:re.expressions[re.rExpression]]];
        
        [self.romo setFillColor:re.expressionBGColor percentage:100];
    }
    else if (self.romo.emotion){
        //[debugLabel removeFromSuperview];
        emotionLabel.text = re.emotions[re.rEmotion];
        expressionLabel.text = nil;
        [self.romo setFillColor:re.emotionBGColor percentage:100];
    }
   // debugLabel.text = [NSString stringWithFormat:@"%f",[magneticHeading floatValue]];

}

- (void)ExpressionFinish:(NSNotification *)note{
    expressionLabel.text = nil;
    
    emotionLabel.text = re.emotions[re.rEmotion];
    [self.romo setFillColor:re.emotionBGColor percentage:100];
    
}



#pragma mark - RobotMotionDelegate
- (void)robotDidConnect:(RMCoreRobot *)robot {
    if(robot.isDrivable && robot.isHeadTiltable && robot.isLEDEquipped) {
        self.robot = (RMCoreRobot<HeadTiltProtocol, DriveProtocol, LEDProtocol > *) robot;
    }
}

- (void)robotDidDisconnect:(RMCoreRobot *)robot {
    if(robot == self.robot) {
        self.robot = nil;
    }
}

#pragma mark - Server
- (void)connect {
    // hardcoded ip
    //ip = @"192.168.0.4"; //home
    ip = @"216.37.103.111";
    
    // networking part
    _inputBuffer = [NSMutableData data];
    _outputBuffer = [NSMutableData data];
    
    [self setNetworkState:NetworkStateConnectingToServer];
    
    _messages = [[NSMutableArray alloc] init];
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)ip, 55554, &readStream, &writeStream);
    
    _inputStream = (__bridge_transfer NSInputStream *)readStream;
    _outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
}

-(void) disconnect {
    
    [self setNetworkState:NetworkStateConnectingToServer];
    
    if (_inputStream != nil) {
        _inputStream.delegate = nil;
        [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_inputStream close];
        _inputStream = nil;
        _inputBuffer = nil;
    }
    if (_outputStream != nil) {
        _outputStream.delegate = nil;
        [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_outputStream close];
        _outputStream = nil;
        _outputBuffer = nil;
    }
}

- (void)reconnect {
    [self disconnect];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self connect];
    });
}

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if(aStream == _inputStream) {
            // NSLog(@"streamDispatch_INPUT");
            [self inputStreamHandleEvent:eventCode];
        }
        else if(aStream == _outputStream) {
            // NSLog(@"streamDispatch_OUTPUT");
            [self outputStreamHandleEvent:eventCode];
        }
    });
}

- (void)setNetworkState:(NetworkState)nState{
    _networkState = nState;
}

/*
 Read Part
 */

// one line is an object
- (void)checkForMessages:(NSString *)msgString{
    if(msgString != nil) {
        _messageLabel.text = msgString;
        NSLog(@"\n\n  %@", msgString);
        // JUST FOR TEST [self getDuration:msgString];
        if([msgString rangeOfString:@"TYPE:E"].location != NSNotFound) {
            [eQueue insertLast:msgString];
        }
        else if([msgString rangeOfString:@"TYPE:M"].location != NSNotFound) {
            [mQueue insertLast:msgString];
        }
        
        // start running on queue only queue was empty
        if(eDuration == -1.f && [eQueue getSize] != 0) {
            [self emotionTimerRun];
        }
        if(mDuration == -1.f && [mQueue getSize] != 0) {
            [self movementTimerRun];
        }
    }
}


- (void)inputStreamHandleEvent:(NSStreamEvent)eventCode {
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            // NSLog(@"Opened input stream");
            _inputOpened = YES;
            if (_inputOpened && _outputOpened && _networkState == NetworkStateConnectingToServer) {
                [self setNetworkState:NetworkStateConnected];
                // TODO: Send message to server
            }
        }
        case NSStreamEventHasBytesAvailable: {
            if ([_inputStream hasBytesAvailable]) {
                // NSLog(@"Input stream has bytes...");
                // TODO: Read bytes
                NSInteger bytesRead;
                uint8_t buffer[32768];
                
                bytesRead = [_inputStream read:buffer maxLength:sizeof(buffer)];
                if (bytesRead == -1) {
                    // NSLog(@"Network read error");
                }
                else if (bytesRead == 0) {
                    // NSLog(@"No data read, reconnecting");
                    [self reconnect];
                }
                else {
                    // NSLog(@"Read %d bytes", bytesRead);
                    //[_inputBuffer appendData:[NSData dataWithBytes:buffer length:bytesRead]];
                    NSString *msgString = [[NSString alloc] initWithBytes:buffer length:bytesRead encoding:NSASCIIStringEncoding];
                    [self checkForMessages:msgString];
                }
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO); // should never happen for the input stream
        } break;
        case NSStreamEventErrorOccurred: {
            // NSLog(@"Stream open error, reconnecting");
            [self reconnect];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}


/*
 Write Part
 */

- (void)sendData:(NSData *)data {
    
    if (_outputBuffer == nil) return;
    
    int dataLength = data.length;
    dataLength = htonl(dataLength);
    [_outputBuffer appendBytes:&dataLength length:sizeof(dataLength)];
    [_outputBuffer appendData:data];
    if (_okToWrite) {
        [self writeChunk];
        // NSLog(@"Wrote message");
    } else {
        // NSLog(@"Queued message");
    }
}

- (BOOL)writeChunk {
    int amtToWrite = MIN(_outputBuffer.length, 1024);
    if (amtToWrite == 0)
        return FALSE;
    
    // NSLog(@"Amt to write: %d/%d", amtToWrite, _outputBuffer.length);
    
    int amtWritten = [_outputStream write:_outputBuffer.bytes maxLength:amtToWrite];
    if (amtWritten < 0) {
        [self reconnect];
    }
    int amtRemaining = _outputBuffer.length - amtWritten;
    if (amtRemaining == 0) {
        _outputBuffer = [NSMutableData data];
    } else {
        // NSLog(@"Creating output buffer of length %d", amtRemaining);
        _outputBuffer = [NSMutableData dataWithBytes:_outputBuffer.bytes+amtWritten length:amtRemaining];
    }
    // NSLog(@"Wrote %d bytes, %d remaining.", amtWritten, amtRemaining);
    _okToWrite = FALSE;
    return TRUE;
}


- (void)outputStreamHandleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            // NSLog(@"Opened output stream");
            _outputOpened = YES;
            if (_inputOpened && _outputOpened && _networkState == NetworkStateConnectingToServer) {
                [self setNetworkState:NetworkStateConnected];
                // TODO: Send message to server
            }
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            // NSLog(@"Ok to send");
            // TODO: Write bytes
            BOOL wroteChunk = [self writeChunk];
            if(!wroteChunk) {
                _okToWrite = TRUE;
            }
        } break;
        case NSStreamEventErrorOccurred: {
            // NSLog(@"Stream open error, reconnecting");
            [self reconnect];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}




            
@end
