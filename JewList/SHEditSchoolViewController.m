//
//  SHEditSchoolViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/16/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "SHEditSchoolViewController.h"
#import "SHApi.h"
@interface SHEditSchoolViewController ()

@end

@implementation SHEditSchoolViewController


- (id)initWithUser:(User *)user
{
    if([self init])
    {
        self.user = user;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.schoolView = [[SHOnboarding2View alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) andUser:_user];
    _schoolView.nextStepButton.hidden = YES;
    _schoolView.shouldPopAfterSelection = YES;
    [self.view addSubview:_schoolView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
