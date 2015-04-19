#import "HYPButton.h"

#import "UIColor+Hex.h"
#import "UIColor+HYPColors.h"
#import "UIFont+HYPStyles.h"
#import "UIButton+ANDYHighlighted.h"

@interface HYPButton ()

@property (nonatomic, retain) UIView *completeView;

@end

@implementation HYPButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.titleLabel.font = [UIFont HYPMediumSize];
    self.layer.cornerRadius = 5.0f;
    self.imageView.image = nil;

    return self;
}

#pragma mark - Getters

- (UIView *)completeView {
    if (_completeView) return _completeView;

    _completeView = [[UIView alloc] initWithFrame:CGRectMake(0,0,5,self.frame.size.height)];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.frame
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft
                                                         cornerRadii:CGSizeMake(5.0f, 5.0f)];
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    _completeView.layer.mask = maskLayer;

    [self addSubview:_completeView];

    return _completeView;
}

+ (HYPButton *)blueButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
    HYPButton *button = [[HYPButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor HYPCallToAction];
    button.contentEdgeInsets = UIEdgeInsetsMake(3.0f, 14.0f, 0.0f, 33.0f);
    button.imageEdgeInsets = UIEdgeInsetsMake(-4.0f, -2.0f, 0.0f, 33.0f);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.clipsToBounds = YES;

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont HYPMediumSizeBolder];

    button.backgroundColor = [UIColor HYPCallToAction];
    button.highlightedBackgroundColor = [UIColor whiteColor];
    button.highlightedTitleColor = [UIColor HYPFieldForegroundDisabled];
    button.layer.borderColor = [UIColor HYPCallToAction].CGColor;
    button.titleColor = [UIColor whiteColor];

    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        button.highlightedBackgroundColor = [UIColor HYPCallToActionPressed];
    }

    return button;
}

+ (HYPButton *)betaButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
    HYPButton *button = [HYPButton blueButtonWithFrame:frame title:title target:target action:action];
    button.backgroundColor = [UIColor colorFromHex:@"FFD200"];
    button.highlightedBackgroundColor = [UIColor colorFromHex:@"FFD200"];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);

    return button;
}

+ (HYPButton *)stickyButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
    HYPButton *button = [HYPButton blueButtonWithFrame:frame title:title target:target action:action];

    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.f);
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    button.titleLabel.font = [UIFont fontWithName:@"DIN-Bold" size:16.0];

    button.backgroundColor = [UIColor HYPCallToAction];
    button.highlightedBackgroundColor = [UIColor whiteColor];
    button.highlightedTitleColor = [UIColor HYPFieldForegroundDisabled];
    button.layer.borderColor = [UIColor HYPCallToAction].CGColor;
    button.titleColor = [UIColor whiteColor];

    return button;
}

+ (HYPButton *)whiteButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
    HYPButton *button = [[HYPButton alloc] initWithFrame:frame];
    button.layer.cornerRadius = 0.0f;
    button.backgroundColor = [UIColor clearColor];

    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 24.0f, 0.0f, 33.0f);
    button.imageEdgeInsets = UIEdgeInsetsMake(-2.0f, -7.0f, 0.0f, 33.0f);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont HYPMediumSizeBold];

    button.highlightedBackgroundColor = [UIColor clearColor];
    button.layer.borderColor = [UIColor HYPCallToAction].CGColor;

    [button setTitleColor:[UIColor HYPDarkBlue] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor HYPCoreBlue] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];

    if (target && action) {
        button.titleColor = [UIColor HYPCallToAction];
        button.highlightedTitleColor = [UIColor HYPCoreBlue];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor HYPCallToAction] forState:UIControlStateNormal];
    } else {
        button.userInteractionEnabled = NO;
    }

    return button;
}

+ (HYPButton *)roundButtonWithFrame:(CGRect)frame target:(id)target action:(SEL)action {
    return [self roundButtonWithFrame:frame title:nil target:target action:action];
}

+ (HYPButton *)roundButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
    HYPButton *button = [[HYPButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor HYPCallToAction];
    button.highlightedBackgroundColor = [UIColor HYPDarkBlue];
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = button.frame.size.width / 2;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 3.0f;

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];

    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        button.highlightedBackgroundColor = [UIColor HYPCoreBlue];
    }

    return button;
}

+ (HYPButton *)titleButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
    if (!title) return nil;

    HYPButton *button = [[HYPButton alloc] initWithFrame:frame];

    button.backgroundColor = [UIColor clearColor];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.titleLabel.font = [UIFont HYPMediumSize];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    NSTextAttachment *textAttachment = [NSTextAttachment new];
    textAttachment.image = [UIImage imageNamed:@"ic_white_arrow_down"];
    NSAttributedString *attributedImage = [NSAttributedString attributedStringWithAttachment:textAttachment];

    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:[title stringByAppendingString:@"  "]
                                                              attributes:@{
                                                                           NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                           }];
    [attributedString appendAttributedString:attributedImage];

    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0f, frame.size.width - 15.f, 0.0f, 0.0f);

    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

    return button;
}

- (void)setComplete:(BOOL)complete {
    _complete = complete;

    self.completeView.backgroundColor = (complete) ? [UIColor HYPGreen] : [UIColor redColor];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    CGRect frame = self.imageView.frame;
    frame.origin.x -= 11.0f;
    self.imageView.frame = CGRectMake(-10,-10,30,30);
    [super setImage:image forState:state];
}

@end
