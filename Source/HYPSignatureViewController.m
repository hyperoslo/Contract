#import "HYPSignatureViewController.h"

#import "UIColor+HYPColors.h"

static const CGFloat HYPSignatureSubjectY = 70.0f;

@interface HYPSignatureViewController ()

@property (nonatomic) UILabel *signatureSubject;
@property (nonatomic) UIView *lineSeparatorView;
@property (nonatomic, copy) NSString *name;

@end

@implementation HYPSignatureViewController

#pragma mark - Initialize

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (!self) return nil;

    _name = name;

    return self;
}

#pragma mark - Getters

- (HYPSignatureView *)signatureView {
    if (_signatureView) return _signatureView;

    CGRect frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, HYPSignatureWidth, HYPSignatureHeight);
    _signatureView = [[HYPSignatureView alloc] initWithFrame:frame context:nil];
    _signatureView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _signatureView.userInteractionEnabled = NO;

    return _signatureView;
}


- (UILabel *)signHereLabel {
    if (_signHereLabel) return _signHereLabel;

    _signHereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, HYPSignatureWidth, 350.0f)];
    _signHereLabel.text = NSLocalizedString(@"TapHereToSign", nil);
    _signHereLabel.font = [UIFont fontWithName:@"DIN-Light" size:33.0];
    _signHereLabel.textColor = [UIColor HYPDarkBlue];
    _signHereLabel.textAlignment = NSTextAlignmentCenter;

    return _signHereLabel;
}

- (UIButton *)doneButton {
    if (_doneButton) return _doneButton;

    _doneButton = [UIButton whiteButtonWithFrame:CGRectMake(HYPSignatureWidth - HYPButtonWidth, 0.0f, HYPButtonWidth, HYPButtonHeight)
                                             title:NSLocalizedString(@"Ferdig", nil)
                                            target:self
                                            action:@selector(doneButtonPressed)];
    _doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _doneButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 33.0f);
    _doneButton.imageEdgeInsets = UIEdgeInsetsMake(-3.0f, 0.0f, 0.0f, 5.f);
    _doneButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [_doneButton setImage:[UIImage imageNamed:@"ic_mini_check"] forState:UIControlStateNormal];
    _doneButton.alpha = 0.0f;

    return _doneButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton) return _cancelButton;

    NSString *title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Clear", nil), NSLocalizedString(@"SignatureField", nil)];
    _cancelButton = [UIButton whiteButtonWithFrame:CGRectMake(0.0f, 0.0f, HYPNullifyButtonSignatureWidth, HYPButtonHeight)
                                               title:title
                                              target:self
                                              action:@selector(cancelButtonPressed)];
    _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _cancelButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 33.0f, 0.0f, 0.0f);
    _cancelButton.imageEdgeInsets = UIEdgeInsetsMake(-3.0f, -5.0f, 0.0f, 0.f);
    _cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [_cancelButton setImage:[UIImage imageNamed:@"ic_mini_clear"] forState:UIControlStateNormal];
    _cancelButton.alpha = 0.0f;

    return _cancelButton;
}

- (UILabel *)signatureSubject {
    if (_signatureSubject) return _signatureSubject;

    _signatureSubject = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, HYPSignatureHeight - HYPSignatureSubjectY, HYPSignatureWidth, 30.0f)];
    _signatureSubject.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Signature", nil), self.name];
    _signatureSubject.font = [UIFont fontWithName:@"DIN-Regular" size:23.0];
    _signatureSubject.textAlignment = NSTextAlignmentCenter;
    _signatureSubject.textColor = [UIColor HYPDarkBlue];

    return _signatureSubject;
}

- (UIView *)lineSeparatorView {
    if (_lineSeparatorView) return _lineSeparatorView;

    CGFloat margin = 100.0f;
    _lineSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(margin, HYPSignatureHeight - HYPSignatureSubjectY - 15.0f, HYPSignatureWidth - (2.0f * margin), 2.0f)];
    _lineSeparatorView.backgroundColor = [UIColor HYPDarkBlue];

    return _lineSeparatorView;
}

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.signatureView];
    [self.view addSubview:self.doneButton];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.signatureSubject];
    [self.view addSubview:self.lineSeparatorView];
    [self.view addSubview:self.signHereLabel];

    self.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.view.layer.borderColor = [UIColor HYPCallToAction].CGColor;
    self.view.layer.cornerRadius = 10.0f;
    self.view.layer.borderWidth = 2.0f;
    self.view.layer.masksToBounds = YES;
}

#pragma mark - Actions

- (void)cancelButtonPressed {
    [self.signatureView erase];

    if ([self.delegate respondsToSelector:@selector(signatureViewControllerDidClear:)]) {
        [self.delegate signatureViewControllerDidClear:self];
    }
}

- (void)doneButtonPressed {
    if ([self.delegate respondsToSelector:@selector(signatureViewController:didFinishWithSignature:)]) {
        [self.delegate signatureViewController:self didFinishWithSignature:[self.signatureView snapshot]];
    }
}

- (void)enableButtons:(BOOL)enabled {
    self.cancelButton.enabled = enabled;
    self.doneButton.enabled = enabled;

    UIColor *color = (enabled) ? [UIColor HYPCallToAction] : [UIColor HYPLightGray];
    [self.cancelButton setTitleColor:color forState:UIControlStateNormal];
    [self.doneButton setTitleColor:color forState:UIControlStateNormal];

    UIImage *checkImage = (enabled) ? [UIImage imageNamed:@"ic_mini_check"] : [UIImage imageNamed:@"ic_mini_check_disabled"];
    UIImage *clearImage = (enabled) ? [UIImage imageNamed:@"ic_mini_clear"] : [UIImage imageNamed:@"ic_mini_clear_disabled"];
    [self.cancelButton setImage:clearImage forState:UIControlStateNormal];
    [self.doneButton setImage:checkImage forState:UIControlStateNormal];
}


@end
