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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonBottomConstraint;

@end

@implementation FreeTextViewController


- (void)registerNotification {
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.textView resignFirstResponder];
}

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

#pragma mark - Keyboard notifications

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    [self animateScrollViewWithKeyboardNotification:notification];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    [self animateScrollViewWithKeyboardNotification:notification];
}

- (void)animateScrollViewWithKeyboardNotification:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardTop = CGRectGetMinY([self.view convertRect:keyboardRect fromView:nil]);
    CGFloat bottomInset = MAX(0, self.view.height - keyboardTop);
  
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | (curve << 16);
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         self.nextButtonBottomConstraint.constant = bottomInset;
                     }
                     completion:nil];
}

@end
