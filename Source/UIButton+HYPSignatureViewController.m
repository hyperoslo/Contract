#import "UIButton+HYPSignatureViewController.h"

#import "UIColor+Hex.h"
#import "UIColor+HYPColors.h"
#import "UIFont+HYPStyles.h"
#import "UIButton+ANDYHighlighted.h"

@implementation UIButton (HYPSignatureViewController)

+ (UIButton *)whiteButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                             target:(id)target
                             action:(SEL)action {
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

@end
