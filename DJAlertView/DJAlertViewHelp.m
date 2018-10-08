//
//  DJAlertViewHelp.m
//  DJAlertViewSample
//
//  Created by jiang deng on 2018/7/4.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "DJAlertViewHelp.h"
#import <objc/runtime.h>

@implementation NSString (Size)

- (CGFloat)heightToFitWidth:(CGFloat)width withFont:(UIFont *)font
{
    return [self sizeToFitWidth:width withFont:font].height;
}

- (CGSize)sizeToFitWidth:(CGFloat)width withFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    return [self sizeToFit:maxSize withFont:font lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGFloat)widthToFitHeight:(CGFloat)height withFont:(UIFont *)font
{
    return [self sizeToFitHeight:height withFont:font].width;
}

- (CGSize)sizeToFitHeight:(CGFloat)height withFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);
    return [self sizeToFit:maxSize withFont:font lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize)sizeToFit:(CGSize)maxSize withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if (!font)
    {
        font = [UIFont systemFontOfSize:12.0f];
    }
    
    CGSize result;
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping)
        {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGRect rect = [self boundingRectWithSize:maxSize
                                         options:options
                                      attributes:attr context:nil];
        result = rect.size;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGSize)sizeToFitWidth:(CGFloat)width withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    return [self sizeToFit:maxSize withFont:font paragraphStyle:paragraphStyle];
}

- (CGSize)sizeToFitHeight:(CGFloat)height withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);
    return [self sizeToFit:maxSize withFont:font paragraphStyle:paragraphStyle];
}

- (CGSize)sizeToFit:(CGSize)maxSize withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
{
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle};
    
    CGRect rect = [self boundingRectWithSize:maxSize options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil];
    
    return rect.size;
}

@end


@implementation NSAttributedString (Size)

- (CGSize)sizeToFitWidth:(CGFloat)width
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    return [self sizeToFit:maxSize lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize)sizeToFitHeight:(CGFloat)height
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);
    return [self sizeToFit:maxSize lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize)sizeToFit:(CGSize)maxSize lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    if (lineBreakMode ==  NSLineBreakByTruncatingHead ||
        lineBreakMode ==  NSLineBreakByTruncatingTail ||
        lineBreakMode ==  NSLineBreakByTruncatingMiddle )
    {
        options |= NSStringDrawingTruncatesLastVisibleLine;
    }
    
    CGRect textRect = [self boundingRectWithSize:maxSize options:options context:nil];
    
    return textRect.size;
}

@end


@implementation UILabel (Category)

- (CGSize)attribSizeToFitWidth:(CGFloat)width
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    return [self attribSizeToFit:maxSize];
}

- (CGSize)attribSizeToFitHeight:(CGFloat)height
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);
    return [self attribSizeToFit:maxSize];
}

- (CGSize)attribSizeToFit:(CGSize)maxSize
{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    if (self.lineBreakMode ==  NSLineBreakByTruncatingHead ||
        self.lineBreakMode ==  NSLineBreakByTruncatingTail ||
        self.lineBreakMode ==  NSLineBreakByTruncatingMiddle )
    {
        options |= NSStringDrawingTruncatesLastVisibleLine;
    }
    
    CGRect textRect  = [self.attributedText boundingRectWithSize:maxSize options:options context:NULL];
    
    return textRect.size;
}

- (CGSize)labelSizeToFitWidth:(CGFloat)width
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    return [self labelSizeToFit:maxSize];
}

- (CGSize)labelSizeToFitHeight:(CGFloat)height
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);
    return [self labelSizeToFit:maxSize];
}

- (CGSize)labelSizeToFit:(CGSize)maxSize
{
    CGSize size = [self.text sizeToFit:maxSize withFont:self.font lineBreakMode:self.lineBreakMode];
    return size;
}

- (CGFloat)calculatedHeight
{
    if (self.attributedText)
    {
        return [self attribSizeToFitWidth:self.bounds.size.width].height;
    }
    else
    {
        return [self labelSizeToFitWidth:self.bounds.size.width].height;
    }
}

@end

#define SetNSErrorFor(FUNC, ERROR_VAR, FORMAT,...)    \
if (ERROR_VAR) {    \
NSString *errStr = [NSString stringWithFormat:@"%s: " FORMAT,FUNC,##__VA_ARGS__]; \
*ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
code:-1    \
userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
}
#define SetNSError(ERROR_VAR, FORMAT,...) SetNSErrorFor(__func__, ERROR_VAR, FORMAT, ##__VA_ARGS__)

#if OBJC_API_VERSION >= 2
#define GetClass(obj)    object_getClass(obj)
#else
#define GetClass(obj)    (obj ? obj->isa : Nil)
#endif

@implementation NSObject (BMSwizzle)

+ (BOOL)swizzleMethod:(SEL)originalSEL withMethod:(SEL)swizzledSEL error:(NSError **)error
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    if (!originalMethod) {
#if TARGET_OS_IPHONE
        SetNSError(error, @"original method %@ not found for class %@", NSStringFromSelector(originalSEL), [self class]);
#else
        SetNSError(error, @"original method %@ not found for class %@", NSStringFromSelector(originalSEL), [self className]);
#endif
        return NO;
    }
    
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    if (!swizzledMethod) {
#if TARGET_OS_IPHONE
        SetNSError(error, @"alternate method %@ not found for class %@", NSStringFromSelector(swizzledSEL), [self class]);
#else
        SetNSError(error, @"alternate method %@ not found for class %@", NSStringFromSelector(swizzledSEL), [self className]);
#endif
        return NO;
    }
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalSEL withClassMethod:(SEL)swizzledSEL error:(NSError **)error
{
    return [GetClass((id)self) swizzleMethod:originalSEL withMethod:swizzledSEL error:error];
}

@end


@implementation UIButton (ContentRect)

static const char *titleRectKey = "DJTitleRectKey";
static const char *imageRectKey = "DJImageRectKey";

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(titleRectForContentRect:) withMethod:@selector(dj_titleRectForContentRect:) error:nil];
        [self swizzleMethod:@selector(imageRectForContentRect:) withMethod:@selector(dj_imageRectForContentRect:) error:nil];
    });
}

- (CGRect)titleRect
{
    NSValue *rectValue = objc_getAssociatedObject(self, titleRectKey);
    return [rectValue CGRectValue];
}

- (void)setTitleRect:(CGRect)rect
{
    objc_setAssociatedObject(self, titleRectKey, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
}

- (CGRect)imageRect
{
    NSValue *rectValue = objc_getAssociatedObject(self, imageRectKey);
    return [rectValue CGRectValue];
}

- (void)setImageRect:(CGRect)rect
{
    objc_setAssociatedObject(self, imageRectKey, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
}

- (CGRect)dj_titleRectForContentRect:(CGRect)contentRect
{
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero))
    {
        return self.titleRect;
    }
    return [self dj_titleRectForContentRect:contentRect];
    
}

- (CGRect)dj_imageRectForContentRect:(CGRect)contentRect
{
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero))
    {
        return self.imageRect;
    }
    return [self dj_imageRectForContentRect:contentRect];
}

- (void)layoutButtonWithEdgeInsetsStyle:(DJButtonEdgeInsetsStyle)style imageTitleGap:(CGFloat)gap
{
    CGFloat imageViewWidth = CGRectGetWidth(self.imageView.frame);
    CGFloat labelWidth = CGRectGetWidth(self.titleLabel.frame);
    
    if (labelWidth == 0)
    {
        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
        labelWidth = titleSize.width;
    }
    
    CGFloat imageInsetsTop = 0.0f;
    CGFloat imageInsetsLeft = 0.0f;
    CGFloat imageInsetsBottom = 0.0f;
    CGFloat imageInsetsRight = 0.0f;
    
    CGFloat titleInsetsTop = 0.0f;
    CGFloat titleInsetsLeft = 0.0f;
    CGFloat titleInsetsBottom = 0.0f;
    CGFloat titleInsetsRight = 0.0f;
    
    switch (style)
    {
        case DJButtonEdgeInsetsStyleImageRight:
        {
            gap = gap * 0.5f;
            
            imageInsetsLeft = labelWidth + gap;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = -(imageViewWidth + gap);
            titleInsetsRight = -titleInsetsLeft;
        }
            break;
            
        case DJButtonEdgeInsetsStyleImageLeft:
        {
            gap = gap * 0.5f;
            
            imageInsetsLeft = -gap;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = gap;
            titleInsetsRight = -titleInsetsLeft;
        }
            break;
            
        case DJButtonEdgeInsetsStyleImageBottom:
        {
            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
            CGFloat buttonHeight = CGRectGetHeight(self.frame);
            CGFloat boundsCentery = (imageHeight + gap + labelHeight) * 0.5f;
            
            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
            
            CGFloat imageBottomY = CGRectGetMaxY(self.imageView.frame);
            CGFloat titleTopY = CGRectGetMinY(self.titleLabel.frame);
            
            imageInsetsTop = buttonHeight - (buttonHeight * 0.5f - boundsCentery) - imageBottomY;
            imageInsetsLeft = centerX_button - centerX_image;
            imageInsetsRight = -imageInsetsLeft;
            imageInsetsBottom = -imageInsetsTop;
            
            titleInsetsTop = (buttonHeight * 0.5 - boundsCentery) - titleTopY;
            titleInsetsLeft = -(centerX_titleLabel - centerX_button);
            titleInsetsRight = -titleInsetsLeft;
            titleInsetsBottom = -titleInsetsTop;
            
        }
            break;
            
        case DJButtonEdgeInsetsStyleImageTop:
        {
            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
            CGFloat buttonHeight = CGRectGetHeight(self.frame);
            CGFloat boundsCentery = (imageHeight + gap + labelHeight) * 0.5f;
            
            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
            
            CGFloat imageTopY = CGRectGetMinY(self.imageView.frame);
            CGFloat titleBottom = CGRectGetMaxY(self.titleLabel.frame);
            
            imageInsetsTop = (buttonHeight * 0.5 - boundsCentery) - imageTopY;
            imageInsetsLeft = centerX_button - centerX_image;
            imageInsetsRight = -imageInsetsLeft;
            imageInsetsBottom = -imageInsetsTop;
            
            titleInsetsTop = buttonHeight - (buttonHeight * 0.5 - boundsCentery) - titleBottom;
            titleInsetsLeft = -(centerX_titleLabel - centerX_button);
            titleInsetsRight = -titleInsetsLeft;
            titleInsetsBottom = -titleInsetsTop;
        }
            break;
            
        default:
            break;
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageInsetsTop, imageInsetsLeft, imageInsetsBottom, imageInsetsRight);
    self.titleEdgeInsets = UIEdgeInsetsMake(titleInsetsTop, titleInsetsLeft, titleInsetsBottom, titleInsetsRight);
}

+ (instancetype)dj_buttonWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    return [UIButton dj_buttonWithFrame:frame image:[UIImage imageNamed:imageName]];
}

+ (instancetype)dj_buttonWithFrame:(CGRect)frame image:(UIImage *)image
{
    return [UIButton dj_buttonWithFrame:frame image:image highlightedImage:nil];
}

+ (instancetype)dj_buttonWithFrame:(CGRect)frame imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName
{
    return [UIButton dj_buttonWithFrame:frame image:[UIImage imageNamed:imageName] highlightedImage:[UIImage imageNamed:highlightedImageName]];
}

+ (instancetype)dj_buttonWithFrame:(CGRect)frame image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    
    return button;
}

@end


@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(UInt32)hex
{
    return [UIColor colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
}

- (CGColorSpaceModel)colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL) canProvideRGBComponents
{
    switch (self.colorSpaceModel)
    {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
            
        default:
            return NO;
    }
}

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r,g,b,a;
    
    switch (self.colorSpaceModel)
    {
        case kCGColorSpaceModelMonochrome:
            r = g = b = components[0];
            a = components[1];
            break;
            
        case kCGColorSpaceModelRGB:
            r = components[0];
            g = components[1];
            b = components[2];
            a = components[3];
            break;
            
        default: // We don't know how to handle this model
            return NO;
    }
    
    if (red)
        *red = r;
    
    if (green)
        *green = g;
    
    if (blue)
        *blue = b;
    
    if (alpha)
        *alpha = a;
    
    return YES;
}

- (UIColor *)changeAlpha:(CGFloat)alpha
{
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
    
    CGFloat r,g,b,a;
    if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
    return [UIColor colorWithRed:r
                           green:g
                            blue:b
                           alpha:alpha];
}

- (UIColor *)colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
    
    CGFloat r,g,b,a;
    if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
    return [UIColor colorWithRed:MAX(r, red)
                           green:MAX(g, green)
                            blue:MAX(b, blue)
                           alpha:MAX(a, alpha)];
}

- (UIColor *)colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
    
    CGFloat r,g,b,a;
    if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
    return [UIColor colorWithRed:MIN(r, red)
                           green:MIN(g, green)
                            blue:MIN(b, blue)
                           alpha:MIN(a, alpha)];
}

- (UIColor *)colorByLighteningTo:(CGFloat)f
{
    return [self colorByLighteningToRed:f green:f blue:f alpha:0.0f];
}

- (UIColor *)colorByDarkeningTo:(CGFloat)f
{
    return [self colorByDarkeningToRed:f green:f blue:f alpha:1.0f];
}

@end


@implementation UIView (Size)

- (void)setSize:(CGSize)size
{
    CGPoint origin = [self frame].origin;
    
    [self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
}

- (CGSize)size
{
    return [self frame].size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)left
{
    return CGRectGetMinX([self frame]);
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = [self frame];
    frame.origin.x = x;
    [self setFrame:frame];
}

- (CGFloat)top
{
    return CGRectGetMinY([self frame]);
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = [self frame];
    frame.origin.y = y;
    [self setFrame:frame];
}

- (CGFloat)right
{
    return CGRectGetMaxX([self frame]);
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = [self frame];
    frame.origin.x = right - frame.size.width;
    
    [self setFrame:frame];
}

- (CGFloat)bottom
{
    return CGRectGetMaxY([self frame]);
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = [self frame];
    frame.origin.y = bottom - frame.size.height;
    
    [self setFrame:frame];
}

- (CGFloat)originX
{
    return CGRectGetMinX(self.frame);
}

- (void) setOriginX:(CGFloat)aOriginX
{
    self.frame = CGRectMake(aOriginX, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (CGFloat)originY
{
    return CGRectGetMinY(self.frame);
}

- (void) setOriginY:(CGFloat)aOriginY
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), aOriginY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (CGFloat)centerX
{
    return [self center].x;
}

- (void)setCenterX:(CGFloat)centerX
{
    [self setCenter:CGPointMake(centerX, self.center.y)];
}

- (CGFloat)centerY
{
    return [self center].y;
}

- (void)setCenterY:(CGFloat)centerY
{
    [self setCenter:CGPointMake(self.center.x, centerY)];
}

- (CGFloat)width
{
    return CGRectGetWidth([self frame]);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = [self frame];
    frame.size.width = width;
    
    [self setFrame:CGRectStandardize(frame)];
}

- (CGFloat)height
{
    return CGRectGetHeight([self frame]);
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = [self frame];
    frame.size.height = height;
    
    [self setFrame:CGRectStandardize(frame)];
}


// bounds accessors

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)size
{
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

- (CGFloat)boundsWidth
{
    return self.boundsSize.width;
}

- (void)setBoundsWidth:(CGFloat)width
{
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (CGFloat)boundsHeight
{
    return self.boundsSize.height;
}

- (void)setBoundsHeight:(CGFloat)height
{
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}


// content getters

- (CGRect)contentBounds
{
    return CGRectMake(0.0f, 0.0f, self.boundsWidth, self.boundsHeight);
}

- (CGPoint)contentCenter
{
    return CGPointMake(self.boundsWidth/2.0f, self.boundsHeight/2.0f);
}

- (void)setLeft:(CGFloat)left right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    frame.size.width = right - left;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - width;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    frame.size.height = bottom - top;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - height;
    frame.size.height = height;
    self.frame = frame;
}

@end


