
@protocol SHOnboardingDelegate <NSObject>

- (void)continueToNextStep:(id)sender;
- (void)goToPreviousStep:(id)sender;

@end
