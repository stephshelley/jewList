//
//  SHGradYearViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHGradYearViewController.h"
#import "JLColors.h"
#import "SHApi.h"

@interface SHGradYearViewController ()

@end

@implementation SHGradYearViewController

- (id)initWithUser:(User *)currentUser
{
    self = [super init];
    if(self)
    {
        _currentUser = currentUser;
        
    }
    
    return self;
    
}

- (void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = DEFAULT_BLUE_COLOR;
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    topView.backgroundColor = DEFAULT_BLUE_COLOR;
    [self.view addSubview:topView];
    
    UIView *leftButtonView = [SHUIHelpers getCustomBarButtonView:CGRectMake(0, 0, 44, 44)
                                                     buttonImage:@"iphone_navbar_button_back"
                                                   selectedImage:@"iphone_navbar_button_back"
                                                           title:@""
                                                     andSelector:@selector(popVC)
                                                          sender:self
                                                      titleColor:[UIColor clearColor]];
    
    leftButtonView.centerY = floorf(topView.height/2);
    leftButtonView.left = 0;
    [topView addSubview:leftButtonView];
    
    self.yearTopView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom, self.view.width, 50)];
    _yearTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_yearTopView];
    
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _yearTopView.bottom, self.view.width, self.view.height - _yearTopView.bottom)];
    whiteBgView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [self.view addSubview:whiteBgView];

    self.chooseYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _yearTopView.width, _yearTopView.height)];
    _chooseYearLabel.textAlignment = NSTextAlignmentCenter;
    _chooseYearLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _chooseYearLabel.textColor = DEFAULT_BLUE_COLOR;
    _chooseYearLabel.backgroundColor = [UIColor clearColor];
    _chooseYearLabel.text = @"What year are you graduating college?";
    [_yearTopView addSubview:_chooseYearLabel];
    
    self.yearsArray = [NSMutableArray arrayWithArray:@[@2015,@2016,@2017,@2018,@2019,@2020,@2021,@2022,@2023,@2024,@2025,@2026,@2027,@2028,@2029,@2030]];
    
    if(_currentUser.gradYear == nil)
        _currentUser.gradYear = [_yearsArray firstObject];
    
    [self loadPicker];
    
    for(NSNumber *year in _yearsArray)
    {
        if([year intValue] == [_currentUser.gradYear intValue])
        {
            NSUInteger row = [_yearsArray indexOfObject:year];
            [self.yearPickerView selectRow:row inComponent:0 animated:NO];
        }
    }
    
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
    self.yearPickerView.centerY = floorf(self.view.height/2);
    [self.view addSubview:self.yearPickerView];
    
    
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
    NSNumber *number = [_yearsArray objectAtIndex:row];
    _currentUser.gradYear = number;
    
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
    //self.navigationController.navigationBar.topItem.title = @"Back";

    //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(popVC)];

	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.topItem.title = @"Edit Profile";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
