//
//  EmotionViewController.m
//  romoDrive
//
//  Created by Tabassum Azad on 4/14/15.
//  Copyright (c) 2015 NYIT Roboticists. All rights reserved.
//
#import "macros.m"
#import "EmotionViewController.h"

@interface EmotionViewController ()
{
    NSArray *emotionPickerData;
    UIPickerView *emotionPicker;
}

@end


@implementation EmotionViewController
@dynamic emotionPicker;
@synthesize re;
RMCharacterExpression expression;
RMCharacterEmotion emotion;

- (id)init
{
    if (!(self = [super init]))
    {
        return (nil);
    }
    
    self.title = NSLocalizedString(@"Emotions", @"Button 2");
    self.tabBarItem.image = [UIImage imageNamed:@"first"];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"TOP_BAR_TITLE", @"Navigation Bar Title");
    
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Grab a shared instance of the Romo character
    self.Romo = [RMCharacter Romo];
    re = [RomoExpression alloc];
    [self.Romo addToSuperview:self.view];
    
    emotionPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-100 , 30)];
    emotionPicker.backgroundColor = [UIColor clearColor];

    
    [self.view addSubview:emotionPicker];
    // Initialize Data
    
    emotionPickerData =re.emotions;

    // Connect data
    emotionPicker.dataSource = self;
    emotionPicker.delegate = self;
    
    [self.Romo setFillColor:re.emotionBGColor percentage:100];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.Romo removeFromSuperview];
    // Dispose of any resources that can be recreated.
}


- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view{
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@", re.emotions[row]];
    return label;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return emotionPickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return emotionPickerData[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    re.rEmotion = row;
    [self.Romo setEmotion:row];
    [self.Romo setFillColor:re.emotionBGColor percentage:100.0];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    }


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
