//
//  DJAlertView.m
//  DJAlertViewSample
//
//  Created by jiang deng on 2018/7/3.
//  Copyright © 2018年 DJ. All rights reserved.
//
//  || https://github.com/alexanderjarvis/PXAlertView


#import "DJAlertView.h"
#import "DJAlertViewHelp.h"

static const CGFloat DJAlertViewWidth = 270.0f;
static const CGFloat DJAlertViewContentMargin = 30.0f;
static const CGFloat DJAlertViewVerticalElementSpace = 5.0f;
static const CGFloat DJAlertViewIconWidth = 90.0f;
static const CGFloat DJAlertViewIconHeight = 90.0f;
static const CGFloat DJAlertViewButtonHeight = 40.0f;
static const CGFloat DJAlertViewLineLayerHeight = 1.0f;
static const CGFloat DJAlertViewVerticalEdgeMinMargin = 25.0f;

#define DJAlertViewMarkBgColor          [UIColor colorWithWhite:0 alpha:0.25]
#define DJAlertViewBgColor              [UIColor colorWithWhite:0.9 alpha:1]

#define DJAlertViewTitleColor           [UIColor colorWithWhite:0 alpha:1];
#define DJAlertViewTitleFont            [UIFont systemFontOfSize:16.0f];
#define DJAlertViewMessageColor         [UIColor colorWithWhite:0.2 alpha:1];
#define DJAlertViewMessageFont          [UIFont systemFontOfSize:14.0f];
#define DJAlertViewGapLineColor         [UIColor colorWithWhite:0.8 alpha:0.6];

#define DJAlertViewCancleBtnBgColor     [UIColor redColor]
#define DJAlertViewOtherBtnBgColor      [UIColor clearColor]
#define DJAlertViewCancleBtnTextColor   [UIColor blueColor]
#define DJAlertViewOtherBtnTextColor    [UIColor blueColor]
#define DJAlertViewBtnFont              [UIFont systemFontOfSize:16.0f];

@interface DJAlertViewStack ()

@property (nonatomic) NSMutableArray *alertViews;

- (void)push:(DJAlertView *)alertView;
- (void)pop:(DJAlertView *)alertView;

@end

@interface DJAlertView ()

@property (nonatomic, assign, getter=isVisible) BOOL visible;

@property (nonatomic, weak) UIWindow *mainWindow;

@property (nonatomic, strong) UIWindow *alertWindow;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *messageScrollView;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *buttonBgView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *lineLayerArray;

@property (nonatomic, assign) BOOL buttonsShouldStack;

@property (nonatomic) UITapGestureRecognizer *tapOutside;

@end


@implementation DJAlertView

- (void)dealloc
{
    //NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //[center removeObserver:self];
}

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows)
    {
        if (window.windowLevel == windowLevel)
        {
            return window;
        }
    }
    return nil;
}

- (instancetype)initWithIcon:(NSString *)iconName
                       title:(id)title
                     message:(id)message
                 contentView:(UIView *)contentView
                 cancelTitle:(nullable NSString *)cancelTitle
                 otherTitles:(NSArray<NSString *> *)otherTitles
          buttonsShouldStack:(BOOL)shouldStack
                  completion:(DJAlertViewCompletionBlock)completion
{
    self = [super init];
    if (self)
    {
        self.mainWindow = [self windowWithLevel:UIWindowLevelNormal];
        
        self.alertWindow = [self windowWithLevel:UIWindowLevelAlert];
        
        if (!self.alertWindow)
        {
            self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.alertWindow.windowLevel = UIWindowLevelAlert;
            self.alertWindow.backgroundColor = [UIColor clearColor];
        }
        
        self.shouldDismissOnTapOutside = YES;
        
        self.showAnimationType = DJAlertViewShowAnimationFadeIn;
        self.hideAnimationType = DJAlertViewHideAnimationFadeOut;
        
        CGRect frame = [self frameForOrientation];
        self.view.frame = frame;
        
        self.iconName = iconName;
        
        if ([title isKindOfClass:[NSString class]])
        {
            self.alertTitle = title;
        }
        else if ([title isKindOfClass:[NSMutableAttributedString class]])
        {
            self.alertTitleAttrStr = title;
        }
        
        if ([message isKindOfClass:[NSString class]])
        {
            self.alertMessage = message;
        }
        else if ([message isKindOfClass:[NSMutableAttributedString class]])
        {
            self.alertMessageAttrStr = message;
        }
        
        self.contentView = contentView;
        
        self.completion = completion;
        
        NSMutableArray *btnTitles = [NSMutableArray array];
        if (cancelTitle)
        {
            [btnTitles addObject:cancelTitle];
        }
        else
        {
            [btnTitles addObject:NSLocalizedString(@"确定", nil)];
        }
        if (otherTitles.count)
        {
            [btnTitles addObjectsFromArray:otherTitles];
        }
        
        self.buttonArray = [NSMutableArray arrayWithCapacity:btnTitles.count];
        self.lineLayerArray = [NSMutableArray arrayWithCapacity:btnTitles.count];
        
        self.backgroundView = [[UIView alloc] initWithFrame:frame];
        self.backgroundView.backgroundColor = self.alertMarkBgColor;
        [self.view addSubview:self.backgroundView];
        
        //CGFloat space = (self.contentView == nil)? AlertViewVerticalElementSpace:0;
        CGFloat alertWidth = (self.contentView == nil) ? DJAlertViewWidth : self.contentView.width;
        
        self.alertView = [[UIView alloc] init];
        self.alertView.width = alertWidth;
        self.alertView.backgroundColor = self.alertBgColor;
        self.alertView.layer.cornerRadius = 8.0;
        self.alertView.layer.opacity = 0.95;
        self.alertView.clipsToBounds = YES;
        [self.view addSubview:self.alertView];
        
        // icon
        self.iconImageView = [[UIImageView alloc] init];
        [self.alertView addSubview:self.iconImageView];
        
        // Title
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DJAlertViewContentMargin, 0, alertWidth - DJAlertViewContentMargin * 2, 10)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        [self.alertView addSubview:self.titleLabel];
        
        // Optional Content View
        if (contentView)
        {
            self.contentView = contentView;
            [self.alertView addSubview:self.contentView];
        }
        
        // Message
        self.messageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DJAlertViewContentMargin, 0, alertWidth - DJAlertViewContentMargin * 2, 10)];
        self.messageScrollView.scrollEnabled = YES;
        
        self.messageLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.messageScrollView.frame.size}];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.numberOfLines = 0;
        
        [self.messageScrollView addSubview:self.messageLabel];
        [self.alertView addSubview:self.messageScrollView];
        
        // Buttons
        self.buttonsShouldStack = shouldStack;
        
        self.buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertWidth, 10.0f)];
        self.buttonBgView.backgroundColor = [UIColor clearColor];
        [self.alertView addSubview:self.buttonBgView];
        
        [self addButtonWithTitles:btnTitles];
        
        [self setupGestures];
        
        //NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        //[center addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
        //[center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (CGPoint)centerWithFrame:(CGRect)frame
{
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - [self statusBarOffset]);
}

- (CGFloat)statusBarOffset
{
    CGFloat statusBarOffset = 0;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        statusBarOffset = 20.0f;
    }
    return statusBarOffset;
}

- (CGRect)frameForOrientation
{
    UIWindow *window = [[UIApplication sharedApplication].windows count] > 0 ? [[UIApplication sharedApplication].windows objectAtIndex:0] : nil;
    if (!window)
    {
        window = [UIApplication sharedApplication].keyWindow;
    }
    if ([[window subviews] count] > 0)
    {
        return [[[window subviews] objectAtIndex:0] bounds];
    }
    return [[self windowWithLevel:UIWindowLevelNormal] bounds];
}

- (CGRect)adjustLabelFrameHeight:(UILabel *)label
{
    CGFloat height = [label calculatedHeight];
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
}

- (void)setupGestures
{
    self.tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.tapOutside setNumberOfTapsRequired:1];
    self.tapOutside.enabled = self.shouldDismissOnTapOutside;
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.backgroundView setMultipleTouchEnabled:NO];
    [self.backgroundView addGestureRecognizer:self.tapOutside];
    self.backgroundView.exclusiveTouch = YES;
}

- (UIButton *)genericButton:(NSUInteger)btnIndex
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor blueColor] colorByLighteningTo:0.5f] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    button.exclusiveTouch = YES;
    button.tag = btnIndex;
    return button;
}

- (void)setBackgroundColorForButton:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        [sender setBackgroundColor:[self.cancleBtnBgColor colorByLighteningTo:0.5f]];
    }
    else
    {
        [sender setBackgroundColor:[self.otherBtnBgColor colorByLighteningTo:0.5f]];
    }
    sender.highlighted = YES;
}

- (void)clearBackgroundColorForButton:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        [sender setBackgroundColor:self.cancleBtnBgColor];
    }
    else
    {
        [sender setBackgroundColor:self.otherBtnBgColor];
    }
    sender.highlighted = NO;
}

- (CALayer *)addLineLayer
{
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = self.alertGapLineColor.CGColor;
    [self.lineLayerArray addObject:lineLayer];
    [self.buttonBgView.layer addSublayer:lineLayer];
    return lineLayer;
}

- (void)addButtonWithTitles:(NSArray *)titles
{
    NSUInteger index = 0;
    for (NSString *btnTitle in titles)
    {
        [self addLineLayer];
        
        UIButton *button = [self genericButton:index];
        [button setTitle:btnTitle forState:UIControlStateNormal];
        [self.buttonArray addObject:button];
        [self.buttonBgView addSubview:button];
        index++;
    }
}

- (CGFloat)freshButtons
{
    if (self.buttonArray.count == 1)
    {
        CALayer *lineLayer = self.lineLayerArray[0];
        lineLayer.frame = CGRectMake(0, 0, self.buttonBgView.width, DJAlertViewLineLayerHeight);
        lineLayer.backgroundColor = self.alertGapLineColor.CGColor;
        UIButton *button = self.buttonArray[0];
        button.frame = CGRectMake(0, DJAlertViewLineLayerHeight, self.buttonBgView.width, self.buttonHeight);
        button.backgroundColor = self.cancleBtnBgColor;
        button.titleLabel.font = self.btnFont;
        [button setTitleColor:self.cancleBtnTextColor forState:UIControlStateNormal];
        [button setTitleColor:[self.cancleBtnTextColor colorByLighteningTo:0.5f] forState:UIControlStateHighlighted];
        
        return DJAlertViewLineLayerHeight + self.buttonHeight;
    }
    else if (!self.buttonsShouldStack && self.buttonArray.count == 2)
    {
        CALayer *lineLayer = self.lineLayerArray[0];
        lineLayer.frame = CGRectMake(0, 0, self.buttonBgView.width, DJAlertViewLineLayerHeight);
        lineLayer.backgroundColor = self.alertGapLineColor.CGColor;
        
        CALayer *verticalLine = self.lineLayerArray[1];
        verticalLine.frame = CGRectMake((self.buttonBgView.width - DJAlertViewLineLayerHeight) * 0.5, 0, DJAlertViewLineLayerHeight, self.buttonHeight);
        verticalLine.backgroundColor = self.alertGapLineColor.CGColor;
        
        UIButton *button = self.buttonArray[0];
        button.frame = CGRectMake(0, DJAlertViewLineLayerHeight, (self.buttonBgView.width - DJAlertViewLineLayerHeight) * 0.5, self.buttonHeight);
        button.backgroundColor = self.cancleBtnBgColor;
        button.titleLabel.font = self.btnFont;
        [button setTitleColor:self.cancleBtnTextColor forState:UIControlStateNormal];
        [button setTitleColor:[self.cancleBtnTextColor colorByLighteningTo:0.5f] forState:UIControlStateHighlighted];
        
        button = self.buttonArray[1];
        button.frame = CGRectMake((self.buttonBgView.width + DJAlertViewLineLayerHeight) * 0.5, DJAlertViewLineLayerHeight, (self.buttonBgView.width - DJAlertViewLineLayerHeight) * 0.5, self.buttonHeight);
        button.backgroundColor = self.otherBtnBgColor;
        button.titleLabel.font = self.btnFont;
        [button setTitleColor:self.otherBtnTextColor forState:UIControlStateNormal];
        [button setTitleColor:[self.otherBtnTextColor colorByLighteningTo:0.5f] forState:UIControlStateHighlighted];
        
        return DJAlertViewLineLayerHeight + self.buttonHeight;
    }
    else if (self.buttonArray.count > 1)
    {
        NSUInteger index = 0;
        for (UIButton *button in self.buttonArray)
        {
            CGFloat top = (DJAlertViewLineLayerHeight + self.buttonHeight) * index;
            
            CALayer *lineLayer = self.lineLayerArray[index];
            lineLayer.frame = CGRectMake(0, top, self.buttonBgView.width, DJAlertViewLineLayerHeight);
            lineLayer.backgroundColor = self.alertGapLineColor.CGColor;
            
            button.frame = CGRectMake(0, DJAlertViewLineLayerHeight + top, self.buttonBgView.width, self.buttonHeight);
            if (index == 0)
            {
                button.backgroundColor = self.cancleBtnBgColor;
                button.titleLabel.font = self.btnFont;
                [button setTitleColor:self.cancleBtnTextColor forState:UIControlStateNormal];
                [button setTitleColor:[self.cancleBtnTextColor colorByLighteningTo:0.5f] forState:UIControlStateHighlighted];
            }
            else
            {
                button.backgroundColor = self.otherBtnBgColor;
                button.titleLabel.font = self.btnFont;
                [button setTitleColor:self.otherBtnTextColor forState:UIControlStateNormal];
                [button setTitleColor:[self.otherBtnTextColor colorByLighteningTo:0.5f] forState:UIControlStateHighlighted];
            }
            
            index++;
        }
        
        return (DJAlertViewLineLayerHeight + self.buttonHeight) * self.buttonArray.count;
    }
    
    return 0;
}

- (void)freshAlertView
{
    self.backgroundView.backgroundColor = self.alertMarkBgColor;
    self.alertView.backgroundColor = self.alertBgColor;
    
    CGFloat space = DJAlertViewVerticalElementSpace;
    CGFloat alertWidth = self.alertView.width;
    
    self.alertView.width = alertWidth;
    
    CGFloat iconWidth = 0;
    CGFloat iconHeight = 0;
    
    if (self.iconName)
    {
        iconWidth = DJAlertViewIconWidth;
        iconHeight = DJAlertViewIconHeight;
        
        self.iconImageView.image = [UIImage imageNamed:self.iconName];
        self.iconImageView.frame = CGRectMake((alertWidth - iconWidth) * 0.5, space, iconWidth, iconHeight);
        self.titleLabel.top = space + iconHeight + space;
    }
    else
    {
        self.iconImageView.image = nil;
        self.titleLabel.top = space;
    }
    
    if (self.alertTitleAttrStr)
    {
        self.titleLabel.attributedText = self.alertTitleAttrStr;
    }
    else
    {
        self.titleLabel.text = self.alertTitle;
    }
    self.titleLabel.textColor = self.alertTitleColor;
    self.titleLabel.font = self.alertTitleFont;
    self.titleLabel.frame = [self adjustLabelFrameHeight:self.titleLabel];
    
    CGFloat messageLabelTop = self.titleLabel.bottom + space;
    
    // Optional Content View
    if (self.contentView)
    {
        self.contentView.top = messageLabelTop;
        messageLabelTop = self.contentView.bottom + space;
    }
    
    // Message
    self.messageScrollView.top = messageLabelTop;
    
    if (self.alertMessageAttrStr)
    {
        self.messageLabel.attributedText = self.alertTitleAttrStr;
    }
    else
    {
        self.messageLabel.text = self.alertMessage;
    }
    self.messageLabel.textColor = self.alertMessageColor;
    self.messageLabel.font = self.alertMessageFont;
    self.messageLabel.frame = [self adjustLabelFrameHeight:self.messageLabel];
    self.messageScrollView.contentSize = self.messageLabel.frame.size;
    
    // Get total button height
    self.tapOutside.enabled = self.shouldDismissOnTapOutside;
    
    CGFloat totalButonHeight = [self freshButtons];
    
    CGFloat margin = DJAlertViewVerticalEdgeMinMargin;
    if (IS_IPHONE5 || IS_IPHONE6 || IS_IPHONEX)
    {
        margin *= 2;
    }
    else if (IS_IPHONE6P)
    {
        margin *= 3;
    }
    
    CGRect scrollViewFrame = (CGRect){
        self.messageScrollView.frame.origin,
        self.messageScrollView.frame.size.width,
        MIN(self.messageLabel.frame.size.height, self.alertWindow.frame.size.height - self.messageScrollView.frame.origin.y - totalButonHeight - margin * 2)};
    self.messageScrollView.frame = scrollViewFrame;
    
    self.buttonBgView.top = DJAlertViewVerticalElementSpace + self.messageScrollView.bottom;
    self.buttonBgView.height = totalButonHeight;
    
    self.alertView.height = self.buttonBgView.bottom;
    self.alertView.center = [self centerWithFrame:self.backgroundView.bounds];
}

- (void)centerAlertView
{
    CGRect frame = [self frameForOrientation];
    self.backgroundView.frame = frame;
    self.alertView.center = [self centerWithFrame:frame];
}


#pragma mark -
#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self freshAlertView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification *)notification
{
    //if (self.isVisible)
    {
        CGRect keyboardFrameBeginRect = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8 && (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight))
        {
            keyboardFrameBeginRect = (CGRect){keyboardFrameBeginRect.origin.y, keyboardFrameBeginRect.origin.x, keyboardFrameBeginRect.size.height, keyboardFrameBeginRect.size.width};
        }
#pragma clang diagnostic pop
        CGRect interfaceFrame = [self frameForOrientation];
        
        if (interfaceFrame.size.height - keyboardFrameBeginRect.size.height <= self.alertView.frame.size.height + self.alertView.frame.origin.y)
        {
            [UIView animateWithDuration:.35
                                  delay:0
                                options:0x70000
                             animations:^(void) {
                                 self.alertView.frame = (CGRect){self.alertView.frame.origin.x, interfaceFrame.size.height - keyboardFrameBeginRect.size.height - self.alertView.frame.size.height - 20, self.alertView.frame.size};
                             }
                             completion:nil];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //if (self.isVisible)
    {
        [UIView animateWithDuration:.35
                              delay:0
                            options:0x70000
                         animations:^(void) {
                             self.alertView.center = [self centerWithFrame:[self frameForOrientation]];
                             
                         }
                         completion:nil];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return [UIApplication sharedApplication].statusBarHidden;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;  //UIInterfaceOrientationMaskAll;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"转屏前调入");
    }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     NSLog(@"转屏后调入");
                                     
                                     [self centerAlertView];
                                     
                                 }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
//{
//    [self centerAlertView];
//}


#pragma mark -
#pragma mark property

- (void)setShouldDismissOnTapOutside:(BOOL)shouldDismissOnTapOutside
{
    _shouldDismissOnTapOutside = shouldDismissOnTapOutside;
    self.tapOutside.enabled = shouldDismissOnTapOutside;
}

- (UIColor *)alertMarkBgColor
{
    if (!_alertMarkBgColor)
    {
        return DJAlertViewMarkBgColor;
    }
    
    return _alertMarkBgColor;
}

- (UIColor *)alertBgColor
{
    if (!_alertBgColor)
    {
        return DJAlertViewBgColor;
    }
    
    return _alertBgColor;
}

- (UIColor *)alertTitleColor
{
    if (!_alertTitleColor)
    {
        return DJAlertViewTitleColor;
    }
    
    return _alertTitleColor;
}

- (UIFont *)alertTitleFont
{
    if (!_alertTitleFont)
    {
        return DJAlertViewTitleFont;
    }
    
    return _alertTitleFont;
}

- (UIColor *)alertMessageColor
{
    if (!_alertMessageColor)
    {
        return DJAlertViewMessageColor;
    }
    
    return _alertMessageColor;
}

- (UIFont *)alertMessageFont
{
    if (!_alertMessageFont)
    {
        return DJAlertViewMessageFont;
    }
    
    return _alertMessageFont;
}

- (CGFloat)buttonHeight
{
    if (_buttonHeight < DJAlertViewButtonHeight)
    {
        _buttonHeight = DJAlertViewButtonHeight;
    }
    
    return _buttonHeight;
}

- (UIColor *)alertGapLineColor
{
    if (!_alertGapLineColor)
    {
        return DJAlertViewGapLineColor;
    }
    
    return _alertGapLineColor;
}

- (UIColor *)cancleBtnBgColor
{
    if (!_cancleBtnBgColor)
    {
        return DJAlertViewCancleBtnBgColor;
    }
    
    return _cancleBtnBgColor;
}

- (UIColor *)otherBtnBgColor
{
    if (!_otherBtnBgColor)
    {
        return DJAlertViewOtherBtnBgColor;
    }
    
    return _otherBtnBgColor;
}

- (UIColor *)cancleBtnTextColor
{
    if (!_cancleBtnTextColor)
    {
        return DJAlertViewCancleBtnTextColor;
    }
    
    return _cancleBtnTextColor;
}

- (UIColor *)otherBtnTextColor
{
    if (!_otherBtnTextColor)
    {
        return DJAlertViewOtherBtnTextColor;
    }
    
    return _otherBtnTextColor;
}

- (UIFont *)btnFont
{
    if (!_btnFont)
    {
        return DJAlertViewBtnFont;
    }
    
    return _btnFont;
}


#pragma mark -
#pragma mark func

- (void)show
{
    [[DJAlertViewStack sharedInstance] push:self];
}

- (void)showInternal
{
    self.alertWindow.rootViewController = self;
    [self.alertWindow makeKeyAndVisible];
    
    switch (self.showAnimationType)
    {
        case DJAlertViewShowAnimationFadeIn:
            [self fadeIn];
            break;
            
        case DJAlertViewShowAnimationSlideInFromBottom:
            [self slideInFromBottom];
            break;
            
        case DJAlertViewShowAnimationSlideInFromTop:
            [self slideInFromTop];
            break;
            
        case DJAlertViewShowAnimationSlideInFromLeft:
            [self slideInFromLeft];
            break;
            
        case DJAlertViewShowAnimationSlideInFromRight:
            [self slideInFromRight];
            break;
            
        default:
            [self showCompletion];
            break;
    }
}

- (void)showCompletion
{
    self.alertWindow.alpha = 1;
    
    self.visible = YES;
    
    [self showAlertAnimation];
}

- (void)hide
{
    if (self.alertWindow.rootViewController == self)
    {
        self.alertWindow.rootViewController = nil;
    }
}

- (void)dismiss:(id)sender
{
    [self dismiss:sender animated:YES];
}

- (void)doCompletion:(id)sender
{
    BOOL cancelled = NO;
    if (sender == self.tapOutside || (self.buttonArray.count > 0 && sender == self.buttonArray[0]))
    {
        cancelled = YES;
    }
    NSInteger buttonIndex = -1;
    if (sender && sender != self.tapOutside && self.buttonArray.count)
    {
        NSUInteger index = [self.buttonArray indexOfObject:sender];
        if (index != NSNotFound)
        {
            buttonIndex = index;
            [self clearBackgroundColorForButton:sender];
        }
    }
    self.completion(cancelled, buttonIndex);
}

- (void)dismissCompletion:(id)sender
{
    self.alertWindow.alpha = 0;
    
    if (self.completion)
    {
        [self doCompletion:sender];
    }
    
    if ([[DJAlertViewStack sharedInstance] getAlertViewCount] == 1)
    {
        //[self dismissAlertAnimation];
        
        self.alertWindow.rootViewController = nil;
        self.alertWindow = nil;
        
        [self.mainWindow makeKeyAndVisible];
    }
    
    [[DJAlertViewStack sharedInstance] pop:self];
}

- (void)dismiss:(id)sender animated:(BOOL)animated
{
    if (self.notDismissOnCancel)
    {
        self.visible = YES;
        
        if (self.completion)
        {
            [self doCompletion:sender];
        }
        
        return;
    }
    
    self.visible = NO;
    
    if (animated)
    {
        switch (self.hideAnimationType)
        {
            case DJAlertViewHideAnimationFadeOut:
                [self fadeOut:sender];
                break;
                
            case DJAlertViewHideAnimationSlideOutToBottom:
                [self slideOutToBottom:sender];
                break;
                
            case DJAlertViewHideAnimationSlideOutToTop:
                [self slideOutToTop:sender];
                break;
                
            case DJAlertViewHideAnimationSlideOutToLeft:
                [self slideOutToLeft:sender];
                break;
                
            case DJAlertViewHideAnimationSlideOutToRight:
                [self slideOutToRight:sender];
                break;
                
            default:
                 [self dismissCompletion:sender];
                break;
        }
    }
    else
    {
        [self dismissCompletion:sender];
    }
}

- (void)showAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)] ];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.3;
    
    [self.alertView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)] ];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = 0.2;
    
    [self.alertView.layer addAnimation:animation forKey:@"dismissAlert"];
}


#pragma mark -
#pragma mark Show Animations

- (void)fadeIn
{
    self.alertWindow.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alertWindow.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [self showCompletion];
                     }];
}

- (void)slideInFromBottom
{
    self.alertWindow.alpha = 1.0f;
    
    //From Frame
    CGRect frame = [self frameForOrientation];
    self.alertView.top = frame.size.height;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         //To Frame
                         [self centerAlertView];
                         
                     }
                     completion:^(BOOL completed) {
                         [self showCompletion];
                     }];
}

- (void)slideInFromTop
{
    self.alertWindow.alpha = 1.0f;
    //From Frame
    self.alertView.top = -self.alertView.height;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         //To Frame
                         [self centerAlertView];
                         
                     }
                     completion:^(BOOL completed) {
                         [self showCompletion];
                     }];
}

- (void)slideInFromLeft
{
    self.alertWindow.alpha = 1.0f;
    //From Frame
    self.alertView.left = -self.alertView.width;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         //To Frame
                         [self centerAlertView];
                         
                     }
                     completion:^(BOOL completed) {
                         [self showCompletion];
                     }];
}

- (void)slideInFromRight
{
    self.alertWindow.alpha = 1.0f;
    
    //From Frame
    CGRect frame = [self frameForOrientation];
    self.alertView.left = frame.size.width;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         //To Frame
                         [self centerAlertView];
                         
                     }
                     completion:^(BOOL completed) {
                         [self showCompletion];
                     }];
}


#pragma mark -
#pragma mark Hide Animations

- (void)fadeOut:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alertWindow.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self dismissCompletion:sender];
                     }];
}

- (void)slideOutToBottom:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alertWindow.alpha = 0;
                         
                         CGRect frame = [self frameForOrientation];
                         self.alertView.top = frame.size.height;
                         
                     }
                     completion:^(BOOL completed) {
                         [self dismissCompletion:sender];
                     }];
}

- (void)slideOutToTop:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alertWindow.alpha = 0;
                         
                         self.alertView.top = -self.alertView.height;
                         
                     }
                     completion:^(BOOL completed) {
                         [self dismissCompletion:sender];
                     }];
}

- (void)slideOutToLeft:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alertWindow.alpha = 0;
                         
                         self.alertView.left = -self.alertView.width;
                         
                     }
                     completion:^(BOOL completed) {
                         [self dismissCompletion:sender];
                     }];
}

- (void)slideOutToRight:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alertWindow.alpha = 0;
                         
                         CGRect frame = [self frameForOrientation];
                         self.alertView.left = frame.size.width;
                         
                     }
                     completion:^(BOOL completed) {
                         [self dismissCompletion:sender];
                     }];
}


#pragma mark -
#pragma mark public func

+ (instancetype)showAlertWithTitle:(id)title
{
    return [self showAlertWithTitle:title message:nil];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
{
    return [self showAlertWithTitle:title message:message completion:nil];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                        completion:(DJAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message cancelTitle:nil completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       cancelTitle:(NSString *)cancelTitle
                        completion:(DJAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message cancelTitle:cancelTitle otherTitle:nil completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                        completion:(DJAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message cancelTitle:cancelTitle otherTitle:otherTitle buttonsShouldStack:NO completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(DJAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message contentView:nil cancelTitle:cancelTitle otherTitle:otherTitle buttonsShouldStack:shouldStack completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray<NSString *> *)otherTitles
                        completion:(DJAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message contentView:nil cancelTitle:cancelTitle otherTitles:otherTitles completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       contentView:(UIView *)contentView
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                        completion:(DJAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message contentView:contentView cancelTitle:cancelTitle otherTitles:otherTitle ? @[ otherTitle ] : nil completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       contentView:(UIView *)contentView
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(DJAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message contentView:contentView cancelTitle:cancelTitle otherTitles:otherTitle ? @[ otherTitle ] : nil buttonsShouldStack:shouldStack completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       contentView:(UIView *)contentView
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray<NSString *> *)otherTitles
                        completion:(DJAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message contentView:contentView cancelTitle:cancelTitle otherTitles:otherTitles buttonsShouldStack:NO completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       contentView:(UIView *)contentView
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray<NSString *> *)otherTitles
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(DJAlertViewCompletionBlock)completion
{
    DJAlertView *alertView = [self alertWithTitle:title
                                          message:message
                                      contentView:contentView
                                      cancelTitle:cancelTitle
                                      otherTitles:otherTitles
                               buttonsShouldStack:shouldStack
                                       completion:completion];
    
    [alertView show];
    return alertView;
}

+ (instancetype)alertWithTitle:(id)title
                       message:(id)message
                   contentView:(UIView *)contentView
                   cancelTitle:(NSString *)cancelTitle
                   otherTitles:(NSArray<NSString *> *)otherTitles
            buttonsShouldStack:(BOOL)shouldStack
                    completion:(DJAlertViewCompletionBlock)completion;
{
    NSUInteger alertViewCount = [[DJAlertViewStack sharedInstance] getAlertViewCount];
    if (alertViewCount >= DJALERTVIEW_MAXSHOWCOUNT)
    {
        return nil;
    }
    
    DJAlertView *alertView = [[self alloc] initWithIcon:nil
                                                  title:title
                                                message:message
                                            contentView:contentView
                                            cancelTitle:cancelTitle
                                            otherTitles:otherTitles
                                     buttonsShouldStack:shouldStack
                                             completion:completion];
    return alertView;
}

- (void)showAlertView
{
    [self show];
}

- (UIButton *)getButtonAtIndex:(NSUInteger)buttonIndex
{
    if (buttonIndex < self.buttonArray.count)
    {
        return self.buttonArray[buttonIndex];
    }
    else
    {
        return nil;
    }
}

- (void)dismiss
{
    [self dismiss:nil];
}

- (void)dismissWithIndex:(NSInteger)index animated:(BOOL)animated
{
    id sender = nil;
    
    if (index < 0)
    {
        sender = self.tapOutside;
    }
    else if (index == 0)
    {
        sender = self.buttonArray[0];
    }
    else if (index < self.buttonArray.count)
    {
        sender = self.buttonArray[index];
    }
    
    [self dismiss:sender animated:animated];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (buttonIndex >= 0 && buttonIndex < self.buttonArray.count)
    {
        [self dismiss:self.buttonArray[buttonIndex] animated:animated];
    }
}

@end

@implementation DJAlertViewStack

+ (instancetype)sharedInstance
{
    static DJAlertViewStack *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DJAlertViewStack alloc] init];
        _sharedInstance.alertViews = [NSMutableArray array];
    });
    
    return _sharedInstance;
}

- (void)push:(DJAlertView *)alertView
{
    @synchronized(self.alertViews)
    {
        for (DJAlertView *av in self.alertViews)
        {
            if (av != alertView)
            {
                [av hide];
            }
            else
            {
                [av freshAlertView];
                return;
            }
        }
        [self.alertViews addObject:alertView];
        [alertView showInternal];
    }
}

- (void)pop:(DJAlertView *)alertView
{
    @synchronized(self.alertViews)
    {
        [alertView hide];
        [self.alertViews removeObject:alertView];
        DJAlertView *last = [self.alertViews lastObject];
        if (last && !last.alertWindow.rootViewController)
        {
            [last showInternal];
        }
        else
        {
            // 公共alertWindow，hide时alertWindow.alpha变更为0
            last.alertWindow.alpha = 1;
        }
    }
}

- (void)closeAllAlertViews
{
    DJAlertView *last = [self.alertViews lastObject];
    while (last)
    {
        if (last.notDismissOnCancel)
        {
            break;
        }
        
        [self closeAlertView:last animated:NO];
        last = [self.alertViews lastObject];
    }
}

- (void)closeAlertView:(DJAlertView *)alertView
{
    [self closeAlertView:alertView animated:YES];
}

- (void)closeAlertView:(DJAlertView *)alertView animated:(BOOL)animated
{
    [alertView dismiss:nil animated:animated];
}

- (void)closeAlertView:(DJAlertView *)alertView dismissWithIndex:(NSInteger)index animated:(BOOL)animated
{
    [alertView dismissWithIndex:index animated:animated];
}

- (NSUInteger)getAlertViewCount
{
    return self.alertViews.count;
}

@end
