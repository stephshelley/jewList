//
//  STOnboardingStep5.m
//  JewList
//
//  Created by Oren Zitoun on 12/28/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "STOnboarding5View.h"
#import "JLColors.h"
#import "SHUIHelpers.h"

@implementation STOnboarding5View

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

    self.ageTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.width, 50)];
    _ageTopView.backgroundColor = [UIColor clearColor];
    [self addSubview:_ageTopView];
    
    UIView *leftButtonView = [SHUIHelpers getCustomBarButtonView:CGRectMake(0, 0, 44, 44)
                                                     buttonImage:@"iphone_navbar_button_back"
                                                   selectedImage:@"iphone_navbar_button_back"
                                                           title:@""
                                                     andSelector:@selector(popScreen)
                                                          sender:self
                                                      titleColor:[UIColor clearColor]];
    
    leftButtonView.centerY = floorf(_ageTopView.height/2);
    leftButtonView.left = -2;
    [_ageTopView addSubview:leftButtonView];
    
    self.chooseYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _ageTopView.width, _ageTopView.height)];
    _chooseYearLabel.textAlignment = NSTextAlignmentCenter;
    _chooseYearLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _chooseYearLabel.textColor = [UIColor whiteColor];
    _chooseYearLabel.backgroundColor = [UIColor clearColor];
    _chooseYearLabel.text = @"How old are you";
    [_ageTopView addSubview:_chooseYearLabel];
    
    UIView *bgColor = [[UIView alloc] initWithFrame:CGRectMake(0, _ageTopView.bottom, self.width, self.height - _ageTopView.bottom)];
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
    _nextStepButton.centerX = _ageTopView.centerX;
    [self addSubview:_nextStepButton];
    
    
    self.agesArray = [NSMutableArray array];
    for(NSInteger i = 16; i < 50; i++)
    {
        NSNumber *age = [NSNumber numberWithInteger:i];
        [_agesArray addObject:age];
    }
    
    if([_user.age intValue] == 0)
        _user.age = @16;

    
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
        _agePickerView.hidden = YES;
        _activityView.hidesWhenStopped = YES;
    }
    
}

- (void)hideLoading
{
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    _activityView = nil;
    _agePickerView.hidden = NO;
    
    
}

- (void)loadPicker
{
    self.agePickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [_agePickerView sizeToFit];
    CGSize pickerSize = _agePickerView.frame.size;
    self.agePickerView.frame = [self pickerFrameWithSize:pickerSize];
    self.agePickerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	self.agePickerView.showsSelectionIndicator = YES;
	self.agePickerView.delegate = self;
	self.agePickerView.dataSource = self;
	self.agePickerView.hidden = NO;
    self.agePickerView.centerY = floorf(self.height/2);
    [self addSubview:self.agePickerView];
    
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
    NSNumber *number = [_agesArray objectAtIndex:row];
    _user.age = number;
    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableAttributedString *attrTitle = nil;
    
    NSString *title = @"";
	
    NSNumber *number = [_agesArray objectAtIndex:row];
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
	
    NSNumber *number = [_agesArray objectAtIndex:row];
    returnStr = [number stringValue];
    
	return returnStr;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    NSNumber *number = [_agesArray objectAtIndex:row];
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
	return [_agesArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
@end
