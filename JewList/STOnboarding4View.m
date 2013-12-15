//
//  STOnboarding4View.m
//  JewList
//
//  Created by Oren Zitoun on 12/15/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "STOnboarding4View.h"
#import "JLColors.h"

const CGFloat kOptimumPickerHeight = 216;
const CGFloat kOptimumPickerWidth = 320;

@implementation STOnboarding4View

- (id)initWithFrame:(CGRect)frame andUser:(User*)user
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.user = user;
        [self loadUI];
        
    }
    
    return self;
    
}

- (void)loadUI
{
    self.backgroundColor = DEFAULT_BACKGROUND_COLOR;

    UIView *progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, IS_IOS7 ? 20 : 0, self.frame.size.width, 5)];
    progressBar.backgroundColor = [UIColor JLGreen];
    UIView *progressMade = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (progressBar.width/4)*3 , progressBar.height)];
    progressMade.backgroundColor = [UIColor JLDarkGreen];
    [progressBar addSubview:progressMade];
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:progressBar.frame];
    progressLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.text = @"Step 3/4";
    progressLabel.centerY = floorf(progressBar.height/2);
    //[progressBar addSubview:progressLabel];
    [self addSubview:progressBar];

    self.yearTopView = [[UIView alloc] initWithFrame:CGRectMake(0, progressBar.bottom, self.width, 50)];
    _yearTopView.backgroundColor = [UIColor JLGrey];
    [self addSubview:_yearTopView];
    
    self.chooseYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _yearTopView.width, _yearTopView.height)];
    _chooseYearLabel.textAlignment = NSTextAlignmentCenter;
    _chooseYearLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _chooseYearLabel.textColor = [UIColor whiteColor];
    _chooseYearLabel.backgroundColor = [UIColor clearColor];
    _chooseYearLabel.text = @"What year are you graduating?";
    [_yearTopView addSubview:_chooseYearLabel];

    CGFloat buttonHeight = 63;
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height-buttonHeight, self.width, buttonHeight)];
    _nextStepButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_nextStepButton setTitle:@"Next" forState:UIControlStateNormal];
    [_nextStepButton setTitle:@"Next" forState:UIControlStateHighlighted];
    _nextStepButton.bottom = self.height + 40;
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _nextStepButton.centerX = _yearTopView.centerX;
    [self addSubview:_nextStepButton];
    
    self.yearsArray = [NSMutableArray arrayWithArray:@[@2015,@2016,@2017,@2018,@2019,@2020,@2021,@2022,@2023,@2024,@2025,@2026,@2027,@2028,@2029,@2030]];
    [self loadPicker];

}

- (void)loadPicker
{
    self.yearPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [_yearPickerView sizeToFit];
    CGSize pickerSize = _yearPickerView.frame.size;
    self.yearPickerView.frame = [self pickerFrameWithSize:pickerSize];
    
    self.yearPickerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
	self.yearPickerView.showsSelectionIndicator = YES;	// note this is defaulted to NO
	
	// this view controller is the data source and delegate
	self.yearPickerView.delegate = self;
	self.yearPickerView.dataSource = self;
	
	// add this picker to our view controller, initially hidden
	self.yearPickerView.hidden = NO;
    self.yearPickerView.centerY = floorf(self.height/2);
    [self addSubview:self.yearPickerView];

}

- (CGRect)pickerFrameWithSize:(CGSize)size
{
    CGRect resultFrame;
    
    CGFloat height = size.height;
    CGFloat width = size.width;
    
    if (size.height < kOptimumPickerHeight)
        // if in landscape, the picker height can be sized too small, so use a optimum height
        height = kOptimumPickerHeight;
    
    if (size.width > kOptimumPickerWidth)
        // keep the width an optimum size as well
        width = kOptimumPickerWidth;
    
    resultFrame = CGRectMake(0.0, -1.0, width, height);
    
    return resultFrame;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableAttributedString *attrTitle = nil;
    
    NSString *title = @"";
	
    NSNumber *number = [_yearsArray objectAtIndex:row];
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
	
    NSNumber *number = [_yearsArray objectAtIndex:row];
    returnStr = [number stringValue];

	return returnStr;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return self.width;
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

@end
