//
//  AgeViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "AgeViewController.h"
#import "MultiSelectionPresenter.h"
#import "UIView+Common.h"

@interface AgeViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic) NSMutableArray *yearsArray;

@end

@implementation AgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.yearsArray = [NSMutableArray array];
    NSUInteger index = 0;

    for(NSInteger i = 16; i < 50; i++)
    {
        NSNumber *age = [NSNumber numberWithInteger:i];
        [self.yearsArray addObject:age];
        if (self.user.age.integerValue == i) {
            index = [self.yearsArray indexOfObject:age];
        }
    }
    
    if([self.user.age intValue] == 0) {
        self.user.age = [self.yearsArray firstObject];;
    } else {
        [self.pickerView selectRow:index inComponent:0 animated:YES];
    }
    
    if (self.saveOnBackButton) {
        self.nextButton.constrainedHeight = @(0);
        
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (!parent && self.saveOnBackButton) {
        
        if ([self.delegate respondsToSelector:@selector(graduationYearViewControllerDidSelectAge:)]) {
            [self.delegate graduationYearViewControllerDidSelectAge:self.user.age];
        }
    }
}

#pragma mark - UIPickerViewDelegate -

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSNumber *number = [self.yearsArray objectAtIndex:row];
    self.user.age = number;
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
    self.navigationController.navigationBar.topItem.title = @"";
    MultiSelectionPresenter *presenter = [MultiSelectionPresenter presenterFromViewController:self user:self.user];
    [presenter present];
}

@end
