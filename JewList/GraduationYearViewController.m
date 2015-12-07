//
//  GraduationYearViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "GraduationYearViewController.h"
#import "AgeViewController.h"
#import "AppDelegate.h"

@interface GraduationYearViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic) NSMutableArray *yearsArray;
@end

@implementation GraduationYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.yearsArray = [NSMutableArray arrayWithArray:@[@2016,@2017,@2018,@2019,@2020,@2021,@2022,@2023,@2024,@2025,@2026,@2027,@2028,@2029,@2030]];
    self.user.gradYear = [self.yearsArray firstObject];
}

#pragma mark - UIPickerViewDelegate -

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSNumber *number = [_yearsArray objectAtIndex:row];
    self.user.gradYear = number;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
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
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *returnStr = @"";
    NSNumber *number = [_yearsArray objectAtIndex:row];
    returnStr = [number stringValue];
    return returnStr;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    NSNumber *number = [_yearsArray objectAtIndex:row];
    label.text = [number stringValue];
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.yearsArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (IBAction)onNextButtonPressed:(id)sender {
    AgeViewController *ageViewContorller = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"AgeViewController"];
    ageViewContorller.user = self.user;
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController pushViewController:ageViewContorller animated:YES];
}

@end
