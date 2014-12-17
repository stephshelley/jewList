//
//  STOnboarding4View.m
//  JewList
//
//  Created by Oren Zitoun on 12/15/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "STOnboarding4View.h"
#import "JLColors.h"
#import "SHUIHelpers.h"
#import "User.h"


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


- (void)popScreen
{
    if(_delegate && [_delegate respondsToSelector:@selector(goToPreviousStep:)])
        [_delegate goToPreviousStep:self];
    
    
}

- (void)loadUI
{

    self.backgroundColor = DEFAULT_BLUE_COLOR;
    if(IS_IOS7) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.yearTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.width, 50)];
    _yearTopView.backgroundColor = [UIColor clearColor];
    [self addSubview:_yearTopView];
    
    UIView *leftButtonView = [SHUIHelpers getCustomBarButtonView:CGRectMake(0, 0, 44, 44)
                                                     buttonImage:@"iphone_navbar_button_back"
                                                   selectedImage:@"iphone_navbar_button_back"
                                                           title:@""
                                                     andSelector:@selector(popScreen)
                                                          sender:self
                                                      titleColor:[UIColor clearColor]];
    
    leftButtonView.centerY = floorf(_yearTopView.height/2);
    leftButtonView.left = -2;
    [_yearTopView addSubview:leftButtonView];
    
    self.chooseYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _yearTopView.width - 50, _yearTopView.height)];
    _chooseYearLabel.textAlignment = NSTextAlignmentCenter;
    _chooseYearLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _chooseYearLabel.textColor = [UIColor whiteColor];
    _chooseYearLabel.backgroundColor = [UIColor clearColor];
    _chooseYearLabel.text = @"What year are you graduating college?";
    _chooseYearLabel.centerX = floorf(_yearTopView.width/2) + 10;
    _chooseYearLabel.adjustsFontSizeToFitWidth = YES;
    [_yearTopView addSubview:_chooseYearLabel];
    
    UIView *bgColor = [[UIView alloc] initWithFrame:CGRectMake(0, _yearTopView.bottom, self.width, self.height - _yearTopView.bottom)];
    bgColor.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [self addSubview:bgColor];
    [self sendSubviewToBack:bgColor];

    CGFloat buttonHeight = 63;
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height-buttonHeight, self.width, buttonHeight)];
    _nextStepButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_nextStepButton setTitle:@"Next" forState:UIControlStateNormal];
    [_nextStepButton setTitle:@"Next" forState:UIControlStateHighlighted];
    _nextStepButton.bottom = self.height;
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _nextStepButton.centerX = _yearTopView.centerX;
    [self addSubview:_nextStepButton];
    
    self.yearsArray = [NSMutableArray arrayWithArray:@[@2015,@2016,@2017,@2018,@2019,@2020,@2021,@2022,@2023,@2024,@2025,@2026,@2027,@2028,@2029,@2030]];
    _user.gradYear = [_yearsArray firstObject];
    
    [self loadPicker];

}

- (void)showLoading
{
    if(nil == _activityView)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = self.center;
        [self addSubview:_activityView];
        [_activityView startAnimating];
        _yearPickerView.hidden = YES;
        _activityView.hidesWhenStopped = YES;
    }
    
}

- (void)hideLoading
{
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    _activityView = nil;
    _yearPickerView.hidden = NO;

    
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
    CGFloat width = self.frame.size.width;
    
    if (size.height < kOptimumPickerHeight)
        // if in landscape, the picker height can be sized too small, so use a optimum height
        height = kOptimumPickerHeight;
    
    resultFrame = CGRectMake(0.0, -1.0, width, height);
    
    return resultFrame;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSNumber *number = [_yearsArray objectAtIndex:row];
    _user.gradYear = number;
    
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    NSNumber *number = [_yearsArray objectAtIndex:row];
    label.text = [number stringValue];
    return label;    
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
