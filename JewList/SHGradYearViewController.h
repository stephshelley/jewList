//
//  SHGradYearViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "User.h"

@interface SHGradYearViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIView *yearTopView;

@property (nonatomic, strong) UIPickerView *yearPickerView;
@property (nonatomic, strong) NSMutableArray *yearsArray;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UILabel *chooseYearLabel;
@property (nonatomic, strong) UIButton *chooseYearButton;

@property (nonatomic, strong) User *currentUser;

- (id)initWithUser:(User *)currentUser;

@end
