#import "UIFont+HYPStyles.h"

@implementation UIFont (HYPStyles)

+ (UIFont *)HYPLargeSize {
    return [UIFont fontWithName:@"Avenir-Medium" size:20.0];
}

+ (UIFont *)HYPLargeSizeBold {
    return [UIFont fontWithName:@"Avenir-Black" size:20.0];
}

+ (UIFont *)HYPLargeSizeRegular {
    return [UIFont fontWithName:@"Avenir-Light" size:20.0];
}

+ (UIFont *)HYPMediumSize {
    return [UIFont fontWithName:@"Avenir-Medium" size:17.0];
}

+ (UIFont *)HYPMediumSizeBolder {
    return [UIFont fontWithName:@"Avenir-Black" size:17.0];
}

+ (UIFont *)HYPMediumSizeBold {
    return [UIFont fontWithName:@"Avenir-Medium" size:17.0];
}

+ (UIFont *)HYPMediumSizeLight {
    return [UIFont fontWithName:@"Avenir-Light" size:17.0];
}

+ (UIFont *)HYPSmallSizeBold {
    return [UIFont fontWithName:@"Avenir-Black" size:14.0];
}

+ (UIFont *)HYPSmallSize {
    return [UIFont fontWithName:@"Avenir-Light" size:14.0];
}

+ (UIFont *)HYPSmallSizeLight {
    return [UIFont fontWithName:@"Avenir-Light" size:14.0];
}

+ (UIFont *)HYPSmallSizeMedium {
    return [UIFont fontWithName:@"Avenir-Medium" size:14.0];
}

+ (UIFont *)HYPLabelFont {
    return [UIFont fontWithName:@"Avenir-Light" size:13.0];
}

+ (UIFont *)HYPTextFieldFont {
    return [UIFont fontWithName:@"Avenir-Light" size:15.0];
}

@end
