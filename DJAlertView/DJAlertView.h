//
//  DJAlertView.h
//  DJAlertViewSample
//
//  Created by jiang deng on 2018/7/3.
//  Copyright © 2018年 DJ. All rights reserved.
//
//  || https://github.com/alexanderjarvis/PXAlertView

#import <UIKit/UIKit.h>

#define DJALERTVIEW_MAXSHOWCOUNT 5

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DJAlertViewShowAnimation)
{
    DJAlertViewShowAnimationNone,
    DJAlertViewShowAnimationFadeIn,
    DJAlertViewShowAnimationSlideInFromBottom,
    DJAlertViewShowAnimationSlideInFromTop,
    DJAlertViewShowAnimationSlideInFromLeft,
    DJAlertViewShowAnimationSlideInFromRight
};

typedef NS_ENUM(NSInteger, DJAlertViewHideAnimation)
{
    DJAlertViewHideAnimationNone,
    DJAlertViewHideAnimationFadeOut,
    DJAlertViewHideAnimationSlideOutToBottom,
    DJAlertViewHideAnimationSlideOutToTop,
    DJAlertViewHideAnimationSlideOutToLeft,
    DJAlertViewHideAnimationSlideOutToRight
};

typedef void (^DJAlertViewCompletionBlock)(BOOL cancelled, NSInteger buttonIndex);

@interface DJAlertView : UIViewController

@property (nonatomic, assign, readonly, getter=isVisible) BOOL visible;

@property (nonatomic, assign) BOOL shouldDismissOnTapOutside;
@property (nonatomic, assign) BOOL notDismissOnCancel;

@property (nonatomic, strong, readonly) UIVisualEffectView *alertMarkBgEffectView;
@property (nullable, nonatomic, strong) UIVisualEffect *alertMarkBgEffect;
@property (nonatomic, strong) UIColor *alertMarkBgColor;
@property (nonatomic, strong) UIColor *alertBgColor;

@property (nullable, nonatomic, strong) NSString *iconName;

@property (nonatomic, strong) UIColor *alertTitleColor;
@property (nonatomic, strong) UIFont *alertTitleFont;
@property (nullable, nonatomic, strong) NSString *alertTitle;

@property (nonatomic, strong) UIColor *alertMessageColor;
@property (nonatomic, strong) UIFont *alertMessageFont;
@property (nullable, nonatomic, strong) NSString *alertMessage;

@property (nullable, nonatomic, strong) NSMutableAttributedString *alertTitleAttrStr;
@property (nullable, nonatomic, strong) NSMutableAttributedString *alertMessageAttrStr;

@property (nonatomic, strong) UIColor *alertGapLineColor;

@property (nonatomic, strong) UIColor *cancleBtnBgColor;
@property (nonatomic, strong) UIColor *otherBtnBgColor;
@property (nonatomic, strong) UIColor *cancleBtnTextColor;
@property (nonatomic, strong) UIColor *otherBtnTextColor;
@property (nonatomic, strong) UIFont *btnFont;

@property (nonatomic, assign) DJAlertViewShowAnimation showAnimationType;
@property (nonatomic, assign) DJAlertViewHideAnimation hideAnimationType;

@property (nullable, nonatomic, copy) DJAlertViewCompletionBlock completion;

@property (nonatomic, assign) CGFloat buttonHeight;


+ (instancetype)showAlertWithTitle:(nullable id)title;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                        completion:(nullable DJAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       cancelTitle:(nullable NSString *)cancelTitle
                        completion:(nullable DJAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       cancelTitle:(nullable NSString *)cancelTitle
                        otherTitle:(nullable NSString *)otherTitle
                        completion:(nullable DJAlertViewCompletionBlock)completion;
+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       cancelTitle:(nullable NSString *)cancelTitle
                        otherTitle:(nullable NSString *)otherTitle
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(nullable DJAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       cancelTitle:(nullable NSString *)cancelTitle
                       otherTitles:(nullable NSArray<NSString *> *)otherTitles
                        completion:(nullable DJAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       contentView:(nullable UIView *)contentView
                       cancelTitle:(nullable NSString *)cancelTitle
                        otherTitle:(nullable NSString *)otherTitle
                        completion:(nullable DJAlertViewCompletionBlock)completion;
+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       contentView:(nullable UIView *)contentView
                       cancelTitle:(nullable NSString *)cancelTitle
                        otherTitle:(nullable NSString *)otherTitle
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(nullable DJAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       contentView:(nullable UIView *)contentView
                       cancelTitle:(nullable NSString *)cancelTitle
                       otherTitles:(nullable NSArray<NSString *> *)otherTitles
                        completion:(nullable DJAlertViewCompletionBlock)completion;
+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       contentView:(nullable UIView *)contentView
                       cancelTitle:(nullable NSString *)cancelTitle
                       otherTitles:(nullable NSArray<NSString *> *)otherTitles
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(nullable DJAlertViewCompletionBlock)completion;

+ (instancetype)alertWithTitle:(nullable id)title
                       message:(nullable id)message
                   contentView:(nullable UIView *)contentView
                   cancelTitle:(nullable NSString *)cancelTitle
                   otherTitles:(nullable NSArray<NSString *> *)otherTitles
            buttonsShouldStack:(BOOL)shouldStack
                    completion:(nullable DJAlertViewCompletionBlock)completion;

- (instancetype)initWithIcon:(nullable NSString *)iconName
                       title:(nullable id)title
                     message:(nullable id)message
                 contentView:(nullable UIView *)contentView
                 cancelTitle:(nullable NSString *)cancelTitle
                 otherTitles:(nullable NSArray<NSString *> *)otherTitles
          buttonsShouldStack:(BOOL)shouldStack
                  completion:(nullable DJAlertViewCompletionBlock)completion;

- (UIButton *)getButtonAtIndex:(NSUInteger)index;

- (void)showAlertView;

- (void)dismiss;
- (void)dismissWithIndex:(NSInteger)index animated:(BOOL)animated;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end

@interface DJAlertViewStack : NSObject

+ (DJAlertViewStack *)sharedInstance;

- (void)closeAllAlertViews;

- (void)closeAlertView:(DJAlertView *)alertView;
- (void)closeAlertView:(DJAlertView *)alertView animated:(BOOL)animated;

- (void)closeAlertView:(DJAlertView *)alertView dismissWithIndex:(NSInteger)index animated:(BOOL)animated;

- (NSUInteger)getAlertViewCount;

@end

NS_ASSUME_NONNULL_END
