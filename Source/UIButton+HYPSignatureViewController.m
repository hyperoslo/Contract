#import "UIButton+HYPSignatureViewController.h"

#import "UIColor+Hex.h"
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
    button.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:17.0];

    button.highlightedBackgroundColor = [UIColor clearColor];
    button.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;

    [button setTitleColor:[UIColor colorFromHex:@"455C73"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHex:@"28649C"] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];

    if (target && action) {
        button.titleColor = [UIColor colorFromHex:@"3DAFEB"];
        button.highlightedTitleColor = [UIColor colorFromHex:@"28649C"];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorFromHex:@"3DAFEB"] forState:UIControlStateNormal];
    } else {
        button.userInteractionEnabled = NO;
    }

    return button;
}

@end
