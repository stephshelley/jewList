//
//  FreeTextViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/7/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "FreeTextViewController.h"
#import "FreeTextPresenter.h"
#import "FreeTextHelpers.h"
#import "UIPlaceHolderTextView.h"

@interface FreeTextViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation FreeTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.placeholder = [FreeTextHelpers placeholderForType:self.type];
    self.textView.placeholderColor = [UIColor lightGrayColor];
    if (self.preloadText) {
        self.textView.text = self.preloadText;
    }
    
    self.questionTitleLabel.text = [FreeTextHelpers questionTitleForType:self.type];
    
    if (self.saveOnBackButton) {
        self.nextButton.hidden = YES;
    }
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        NSLog(@"back pressed");
        if (self.saveOnBackButton) {
            if ([self.delegate respondsToSelector:@selector(freeTextControllerDidChooseText:text:)]) {
                [self.delegate freeTextControllerDidChooseText:self text:self.textView.text];
            }
        }
    }
}

- (IBAction)onNextButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(freeTextControllerDidChooseText:text:)]) {
        [self.delegate freeTextControllerDidChooseText:self text:self.textView.text];
    }
}

@end
