//
//  UIView+Common.m
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (UIViewController *)firstAvailableUIViewController
{
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id)traverseResponderChainForUIViewController
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

- (CGFloat)left {
    return CGRectGetMinX(self.frame);
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return CGRectGetMinY(self.frame);
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right {
    self.left = right - self.width;
}

- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom {
    self.top = bottom - self.height;
}

- (CGFloat)centerX {
    return CGRectGetMidX(self.frame);
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.centerY);
}

- (CGFloat)centerY {
    return CGRectGetMidY(self.frame);
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.centerX, centerY);
}

- (void)centerInSuperview {
    self.center = CGPointMake(self.superview.width / 2.0, self.superview.height / 2.0);
}

- (CGFloat)width {
    return CGRectGetWidth(self.bounds);
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return CGRectGetHeight(self.bounds);
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.bounds.size;
}

- (void)setSize:(CGSize)size {
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

#pragma mark - Layer Properties

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    if (cornerRadius > 0) {
        self.layer.masksToBounds = YES;
    }
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (NSNumber *)constrainedCenterX {
    return [self valueForMarginAttribute:NSLayoutAttributeCenterX];
}

- (void)setConstrainedCenterX:(NSNumber *)constrainedCenterX {
    [self setValue:constrainedCenterX forMarginAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (NSNumber *)constrainedCenterY {
    return [self valueForMarginAttribute:NSLayoutAttributeCenterY];
}

- (void)setConstrainedCenterY:(NSNumber *)constrainedCenterY {
    [self setValue:constrainedCenterY forMarginAttribute:NSLayoutAttributeCenterYWithinMargins];
}

- (NSNumber *)constrainedLeading {
    return [self valueForMarginAttribute:NSLayoutAttributeLeading];
}

- (void)setConstrainedLeading:(NSNumber *)constrainedLeading {
    [self setValue:constrainedLeading forMarginAttribute:NSLayoutAttributeLeading];
}

- (NSNumber *)constrainedTrailing {
    return [self valueForMarginAttribute:NSLayoutAttributeTrailing];
}

- (void)setConstrainedTrailing:(NSNumber *)constrainedTrailing {
    [self setValue:constrainedTrailing forMarginAttribute:NSLayoutAttributeTrailing];
}

- (NSNumber *)constrainedTop {
    return [self valueForMarginAttribute:NSLayoutAttributeTop];
}

- (void)setConstrainedTop:(NSNumber *)constrainedTop {
    [self setValue:constrainedTop forMarginAttribute:NSLayoutAttributeTop];
}

- (NSNumber *)constrainedBottom {
    return [self valueForMarginAttribute:NSLayoutAttributeBottom];
}

- (void)setConstrainedBottom:(NSNumber *)constrainedBottom {
    [self setValue:constrainedBottom forMarginAttribute:NSLayoutAttributeBottom];
}

- (NSNumber *)constrainedHeight {
    return [self valueForSizeAttribute:NSLayoutAttributeHeight];
}

- (void)setConstrainedHeight:(NSNumber *)constrainedHeight {
    [self setValue:constrainedHeight forSizeAttribute:NSLayoutAttributeHeight];
}

- (NSNumber *)constrainedWidth {
    return [self valueForSizeAttribute:NSLayoutAttributeWidth];
}

- (void)setConstrainedWidth:(NSNumber *)constrainedWidth {
    [self setValue:constrainedWidth forSizeAttribute:NSLayoutAttributeWidth];
}

#pragma mark - UIView (Extension)

+ (instancetype)viewFromNib:(UINib *)nib atIndex:(NSUInteger)index {
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    if (views.count <= index) {
        return nil;
    }
    return views[index];
}

+ (instancetype)viewFromNibName:(NSString *)nibName bundle:(NSBundle *)bundle atIndex:(NSUInteger)index {
    UINib *nib = [UINib nibWithNibName:nibName bundle:bundle];
    return [self viewFromNib:nib atIndex:index];
}

+ (instancetype)viewFromNib:(UINib *)nib {
    return [self viewFromNib:nib atIndex:0];
}

+ (instancetype)viewFromNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
    return [self viewFromNibName:nibName bundle:bundle atIndex:0];
}

+ (instancetype)viewFromNib {
    return [self viewFromNibName:NSStringFromClass(self) bundle:nil];
}

#pragma mark - Autolayout (Private)

- (NSNumber *)valueForSizeAttribute:(NSLayoutAttribute)attribute {
    NSLayoutConstraint *constraint = [self sizeConstraintWithAttribute:attribute];
    if (constraint) {
        return @(constraint.constant);
    }
    
    return nil;
}

- (void)setValue:(NSNumber *)value forSizeAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *constraint = [self sizeConstraintWithAttribute:attribute];
    if (value) {
        if (!constraint) {
            // Create new constraint
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                             attribute:attribute
                                                             relatedBy:0
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:value.doubleValue]];
        }
        else {
            // Update existing constraint
            constraint.constant = value.doubleValue;
        }
    }
    else if (constraint) {
        // Delete existing Constraint
        [self removeConstraint:constraint];
    }
}


- (NSNumber *)valueForMarginAttribute:(NSLayoutAttribute)attribute
{
    if (!self.superview) return nil;
    
    NSLayoutConstraint *constraint = [self marginConstraintWithAttribute:attribute];
    if (constraint) {
        return @(constraint.constant);
    }
    
    return nil;
}

- (void)setValue:(NSNumber *)value forMarginAttribute:(NSLayoutAttribute)attribute
{
    if (!self.superview) return;
    
    NSLayoutConstraint *constraint = [self marginConstraintWithAttribute:attribute];
    if (value)
    {
        if (!constraint)
        {
            // Create new constraint, flip bottom & trailing relationship
            BOOL flipConstraint = (attribute == NSLayoutAttributeBottom || attribute == NSLayoutAttributeTrailing);
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:flipConstraint ? self.superview : self
                                                                       attribute:attribute
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:flipConstraint ? self : self.superview
                                                                       attribute:attribute
                                                                      multiplier:1.0
                                                                        constant:value.doubleValue]];
        }
        else
        {
            // Update existing constraint
            constraint.constant = value.doubleValue;
        }
    }
    else if (constraint) {
        // Remove existing constraint
        [self.superview removeConstraint:constraint];
    }
}

- (NSLayoutConstraint *)marginConstraintWithAttribute:(NSLayoutAttribute)attribute {
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ([self constraint:constraint isMarginWithAttribute:attribute]) {
            return constraint;
        }
    }
    
    return nil;
}

- (NSLayoutConstraint *)sizeConstraintWithAttribute:(NSLayoutAttribute)attribute {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if ([self constraint:constraint isSizeWithAttribute:attribute]) {
            return constraint;
        }
    }
    
    return nil;
}

- (BOOL)constraint:(NSLayoutConstraint *)constraint isSizeWithAttribute:(NSLayoutAttribute)attribute
{
    return (constraint.firstItem == self && constraint.firstAttribute == attribute &&
            constraint.secondItem == nil &&  constraint.secondAttribute == NSLayoutAttributeNotAnAttribute);
}

- (BOOL)constraint:(NSLayoutConstraint *)constraint isMarginWithAttribute:(NSLayoutAttribute)attribute
{
    return (((constraint.firstItem == self && constraint.secondItem == self.superview) ||
             (constraint.firstItem == self.superview && constraint.secondItem == self)) &&
            constraint.firstAttribute == attribute && constraint.secondAttribute == attribute &&
            constraint.relation == NSLayoutRelationEqual);
}

@end
