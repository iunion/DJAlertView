//
//  DJAlertViewHelp.h
//  DJAlertViewSample
//
//  Created by jiang deng on 2018/7/4.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)

#define IS_IPHONE4  (CGSizeEqualToSize(CGSizeMake(320.0f, 480.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define IS_IPHONE5  (CGSizeEqualToSize(CGSizeMake(320.0f, 568.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define IS_IPHONE6  (CGSizeEqualToSize(CGSizeMake(375.0f, 667.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define IS_IPHONE6P (CGSizeEqualToSize(CGSizeMake(414.0f, 736.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define IS_IPHONEX  (CGSizeEqualToSize(CGSizeMake(375.0f, 812.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define IS_IPHONEXP (CGSizeEqualToSize(CGSizeMake(414.0f, 896.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)

@interface NSString (Size)

- (CGFloat)heightToFitWidth:(CGFloat)width withFont:(UIFont *)font;
- (CGSize)sizeToFitWidth:(CGFloat)width withFont:(UIFont *)font;
- (CGFloat)widthToFitHeight:(CGFloat)height withFont:(UIFont *)font;
- (CGSize)sizeToFitHeight:(CGFloat)height withFont:(UIFont *)font;
- (CGSize)sizeToFit:(CGSize)maxSize withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeToFitWidth:(CGFloat)width withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;
- (CGSize)sizeToFitHeight:(CGFloat)height withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;
- (CGSize)sizeToFit:(CGSize)maxSize withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;

@end

@interface NSAttributedString (Size)

- (CGSize)sizeToFitWidth:(CGFloat)width;
- (CGSize)sizeToFitHeight:(CGFloat)height;
- (CGSize)sizeToFit:(CGSize)maxSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end

@interface UILabel (Category)

- (CGSize)attribSizeToFitWidth:(CGFloat)width;
- (CGSize)attribSizeToFitHeight:(CGFloat)height;
- (CGSize)attribSizeToFit:(CGSize)maxSize;

// 以下不支持attributedText带属性计算，只支持普通text
- (CGSize)labelSizeToFitWidth:(CGFloat)width;
- (CGSize)labelSizeToFitHeight:(CGFloat)height;
- (CGSize)labelSizeToFit:(CGSize)maxSize;

- (CGFloat)calculatedHeight;

@end

@interface NSObject (DJSwizzle)

+ (BOOL)swizzleMethod:(nonnull SEL)originalSEL withMethod:(nonnull SEL)swizzledSEL error:(NSError * _Nullable * _Nullable)error;
+ (BOOL)swizzleClassMethod:(nonnull SEL)originalSEL withClassMethod:(nonnull SEL)swizzledSEL error:(NSError * _Nullable * _Nullable)error;

@end

typedef NS_ENUM(NSUInteger, DJButtonEdgeInsetsStyle)
{
    DJButtonEdgeInsetsStyleImageLeft,
    DJButtonEdgeInsetsStyleImageRight,
    DJButtonEdgeInsetsStyleImageTop,
    DJButtonEdgeInsetsStyleImageBottom
};

@interface UIButton (ContentRect)

@property (nonatomic, assign) CGRect titleRect;
@property (nonatomic, assign) CGRect imageRect;

- (void)layoutButtonWithEdgeInsetsStyle:(DJButtonEdgeInsetsStyle)style imageTitleGap:(CGFloat)gap;

+ (nonnull instancetype)dj_buttonWithFrame:(CGRect)frame imageName:(nonnull NSString *)imageName;
+ (nonnull instancetype)dj_buttonWithFrame:(CGRect)frame image:(nullable UIImage *)image;
+ (nonnull instancetype)dj_buttonWithFrame:(CGRect)frame imageName:(nonnull NSString *)imageName highlightedImageName:(nonnull NSString *)highlightedImageName;
+ (nonnull instancetype)dj_buttonWithFrame:(CGRect)frame image:(nullable UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage;

@end

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha;

- (UIColor *)changeAlpha:(CGFloat)alpha;

- (UIColor *)colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)colorByLighteningTo:(CGFloat)f;
- (UIColor *)colorByDarkeningTo:(CGFloat)f;

@end


@interface UIView (Size)

/**
 * Shortcut for frame.origin
 */
@property (nonatomic, assign) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic, assign) CGSize size;

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic, assign) CGFloat left;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic, assign) CGFloat right;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic, assign) CGFloat top;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic, assign) CGFloat bottom;

/** The x origin of the view's frame. */
@property (nonatomic, assign) CGFloat originX;

/** The max y origin of the view's frame. */
@property (nonatomic, assign) CGFloat originY;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic, assign) CGFloat centerX;


/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic, assign) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic, assign) CGFloat height;


// bounds accessors
@property (nonatomic, assign) CGSize boundsSize;
@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;


// content getters
@property (nonatomic, readonly) CGRect contentBounds;
@property (nonatomic, readonly) CGPoint contentCenter;


// additional frame setters
- (void)setLeft:(CGFloat)left right:(CGFloat)right;
- (void)setWidth:(CGFloat)width right:(CGFloat)right;
- (void)setTop:(CGFloat)top bottom:(CGFloat)bottom;
- (void)setHeight:(CGFloat)height bottom:(CGFloat)bottom;

@end
