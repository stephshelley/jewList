//
//  UIView+Common.h
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 11/20/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)

/**
 * Get view's parent view controller
 *
 *
 */
- (UIViewController *)firstAvailableUIViewController;

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (readwrite) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (readwrite) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (readwrite) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (readwrite) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (readwrite) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (readwrite) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (readwrite) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (readwrite) CGFloat centerY;

/**
 * Shortcut for frame.origin
 */
@property (readwrite) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (readwrite) CGSize size;

/**
 * Shortcut for layer.cornerRadius
 */
@property (readwrite) CGFloat cornerRadius;

/**
 * Shortcut for layer.borderWidth
 */
@property (readwrite) CGFloat borderWidth;

/**
 * Shortcut for layer.borderColor, conversion to UIColor
 */
@property (readwrite) UIColor *borderColor;

/**
 * Convenience property for Autolayout horizontal leading to superview constraint
 */
@property (readwrite) NSNumber *constrainedLeading;

/**
 * Convenience property for Autolayout horizontal trailing to superview constraint
 */
@property (readwrite) NSNumber *constrainedTrailing;

/**
 * Convenience property for Autolayout vertical leading to superview constraint
 */
@property (readwrite) NSNumber *constrainedTop;

/**
 * Convenience property for Autolayout vertical trailing to superview constraint
 */
@property (readwrite) NSNumber *constrainedBottom;

/**
 * Convenience property for Autolayout width constraint
 */
@property (readwrite) NSNumber *constrainedWidth;

/**
 * Convenience property for Autolayout height constraint
 */
@property (readwrite) NSNumber *constrainedHeight;

/**
 * Convenience property for Autolayout centerY constraint
 */
@property (readwrite) NSNumber *constrainedCenterX;

/**
 * Convenience property for Autolayout centerY constraint
 */
@property (readwrite) NSNumber *constrainedCenterY;

/**
 * Convenience methods for getting a view instance from a nib or nib name
 * @return A UIView instance from the nib, at the specified index
 */
+ (instancetype)viewFromNib;
+ (instancetype)viewFromNib:(UINib *)nib;
+ (instancetype)viewFromNibName:(NSString *)nibName bundle:(NSBundle *)bundle;
+ (instancetype)viewFromNib:(UINib *)nib atIndex:(NSUInteger)index;
+ (instancetype)viewFromNibName:(NSString *)nibName bundle:(NSBundle *)bundle atIndex:(NSUInteger)index;

@end
