@import UIKit;

@interface HYPButton : UIButton

@property (nonatomic) BOOL complete;
@property (nonatomic) BOOL open;

+ (HYPButton *)blueButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;
+ (HYPButton *)betaButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;
+ (HYPButton *)stickyButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;
+ (HYPButton *)whiteButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;
+ (HYPButton *)roundButtonWithFrame:(CGRect)frame target:(id)target action:(SEL)action;
+ (HYPButton *)roundButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;
+ (HYPButton *)titleButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

@end
