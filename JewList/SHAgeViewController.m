
//
//  SHAgeViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/28/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHAgeViewController.h"

@interface SHAgeViewController ()

@end

@implementation SHAgeViewController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"Age";
    self.chooseYearLabel.text = @"How old are you?";

    self.yearsArray = [NSMutableArray array];
    for(NSInteger i = 18; i < 50; i++)
    {
        NSNumber *age = [NSNumber numberWithInteger:i];
        [self.yearsArray addObject:age];
    }
    
    self.yearPickerView.delegate = self;
    
    for(NSNumber *age in self.yearsArray)
    {
        if([age intValue] == [self.currentUser.age intValue])
        {
            NSUInteger row = [self.yearsArray indexOfObject:age];
            [self.yearPickerView selectRow:row inComponent:0 animated:NO];
        }
    }
    
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSNumber *number = [self.yearsArray objectAtIndex:row];
    self.currentUser.age = [number stringValue];
    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableAttributedString *attrTitle = nil;
    
    NSString *title = @"";
	
    NSNumber *number = [self.yearsArray objectAtIndex:row];
    title = [number stringValue];
    
    attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attrTitle addAttribute:NSForegroundColorAttributeName
                      value:[UIColor whiteColor]
                      range:NSMakeRange(0, [attrTitle length])];
    
    
    return attrTitle;
}

#pragma mark - UIPickerViewDataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr = @"";
	
    NSNumber *number = [self.yearsArray objectAtIndex:row];
    returnStr = [number stringValue];
    
	return returnStr;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return self.view.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [self.yearsArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
