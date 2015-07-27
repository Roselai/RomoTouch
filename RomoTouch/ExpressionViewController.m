//
//  ExpressionViewController.m
//  romoDrive
//
//  Created by Tabassum Azad on 4/14/15.
//  Copyright (c) 2015 NYIT Roboticists. All rights reserved.
//

#import "macros.m"
#import "ExpressionViewController.h"

@interface ExpressionViewController ()
{
    NSArray *expressionPickerData;
    UIPickerView *expressionPicker;
    UILabel *debugLabel;
    
}
@end

@implementation ExpressionViewController
@synthesize re;

RMCharacterExpression expression;
RMCharacterEmotion emotion;
- (id)init
{
    if (!(self = [super init]))
    {
        return (nil);
    }
    
    self.title = NSLocalizedString(@"Expressions", @"Button 2");
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
  
    
    expressionPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-100 , 30)];
    expressionPicker.backgroundColor = [UIColor clearColor];
    
    
    
    // Initialize Data
    expressionPickerData = re.expressions;

    
    // Connect data
    expressionPicker.dataSource = self;
    expressionPicker.delegate = self;
    
    //UILabel for debug
    debugLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 450, self.view.frame.size.width, 60)];
    [debugLabel setTextColor:[UIColor blackColor]];
    [debugLabel setBackgroundColor:[UIColor clearColor]];
    [debugLabel setFont:[UIFont systemFontOfSize:15]];
    [debugLabel setTextAlignment:NSTextAlignmentCenter];
    
    //debugLabel.text=nil;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Add Romo's face to self.view whenever the view will appear
    [self.Romo addToSuperview:self.view];
    [self.view addSubview:expressionPicker];
    [self.view addSubview:debugLabel];
    debugLabel.text=nil;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:(self) selector:@selector(ExpressionFinish:) name:(@"RMCharacterDidFinishExpressingNotification") object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.Romo removeFromSuperview];
    [debugLabel removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RMCharacterDidFinishExpressingNotification" object:nil];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Removing Romo from the superview stops animations and sounds
    [debugLabel removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RMCharacterDidFinishExpressingNotification" object:nil];
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
    label.text =[NSString stringWithFormat:@"%@", re.expressions[row]];
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
    return expressionPickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return expressionPickerData[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
   
    re.rExpression = row;
    
    
   [self.Romo setExpression:re.rExpression];
    [self.Romo setFillColor:re.expressionBGColor percentage:100];
    
    
    debugLabel.text =[NSString stringWithFormat:@"%@ duration: %8.2f sec",re.expressions[re.rExpression],[self.re expressionDuration:re.expressions[re.rExpression]]];

}


- (void)ExpressionFinish:(NSNotification *)note{
    [self.Romo setFillColor:re.emotionBGColor percentage:100.0];
    [self.view addSubview:debugLabel];
    
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
