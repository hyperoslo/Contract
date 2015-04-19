#import "HYPSignaturesViewController.h"

#import "HYPSignatureViewController.h"

#import "UIViewController+HYPContainer.h"

static const CGFloat HYPSignatureButtonX = 15.0f;
static const CGFloat HYPSignatureButtonY = 15.0f;

static const CGFloat HYPSignatureButtonHeight = 180.0f;
static const CGFloat HYPSignatureButtonWidth = 360.0f;

@interface HYPSignaturesViewController () <HYPSignatureViewControllerDelegate>

@property (nonatomic, copy) NSString *firstPartyName;
@property (nonatomic, copy) NSString *secondPartyName;

@property (nonatomic) HYPSignatureViewController *firstPartySignatureViewController;
@property (nonatomic) HYPSignatureViewController *secondPartySignatureViewController;
@property (nonatomic) UIView *overlayView;

@property (nonatomic) CGRect originalRect;
@property (nonatomic) CGRect previousRect;

@property (nonatomic) UITapGestureRecognizer *firstPartyTapRecognizer;
@property (nonatomic) UITapGestureRecognizer *secondPartyTapRecognizer;

@property (nonatomic) UIImage *firstPartySignature;
@property (nonatomic) UIImage *secondPartySignature;

@end

@implementation HYPSignaturesViewController

#pragma mark - Initalization

- (instancetype)initWithFirstPartyName:(NSString *)firsPartyName
                    andSecondPartyName:(NSString *)secondPartyName {
    self = [super init];
    if (!self) return nil;

    _firstPartyName = firsPartyName;
    _secondPartyName = secondPartyName;

    return self;
}

#pragma mark - Getters

- (HYPSignatureViewController *)firstPartySignatureViewController {
    if (_firstPartySignatureViewController) return _firstPartySignatureViewController;

    _firstPartySignatureViewController = [[HYPSignatureViewController alloc] initWithName:self.firstPartyName];
    _firstPartySignatureViewController.delegate = self;

    return _firstPartySignatureViewController;
}

- (HYPSignatureViewController *)secondPartySignatureViewController {
    if (_secondPartySignatureViewController) return _secondPartySignatureViewController;

    _secondPartySignatureViewController = [[HYPSignatureViewController alloc] initWithName:self.secondPartyName];
    _secondPartySignatureViewController.delegate = self;

    return _secondPartySignatureViewController;
}


- (UIView *)overlayView {
    if (_overlayView) return _overlayView;

    _overlayView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _overlayView.alpha = 0.0f;

    return _overlayView;
}

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = CGRectMake(HYPSignatureButtonX, HYPSignatureButtonY, HYPSignatureButtonWidth, HYPSignatureButtonHeight);
    [self hyp_addViewController:self.firstPartySignatureViewController];
    self.firstPartySignatureViewController.view.layer.transform = CATransform3DMakeScale(.515, .515, 1);
    self.firstPartySignatureViewController.view.frame = frame;
    self.firstPartySignatureViewController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;

    self.firstPartyTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(employerSignatureTapped)];
    [self.firstPartySignatureViewController.view addGestureRecognizer:self.firstPartyTapRecognizer];

    frame.origin.x = CGRectGetWidth([[UIScreen mainScreen] bounds]) - HYPSignatureButtonWidth - HYPSignatureButtonX;
    [self hyp_addViewController:self.secondPartySignatureViewController];
    self.secondPartySignatureViewController.view.layer.transform = CATransform3DMakeScale(.515, .515, 1);
    self.secondPartySignatureViewController.view.frame = frame;
    self.secondPartySignatureViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

    self.secondPartyTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(employeeSignatureTapped)];
    [self.secondPartySignatureViewController.view addGestureRecognizer:self.secondPartyTapRecognizer];
}

#pragma mark - Actions

- (void)employerSignatureTapped {
    [self expandSignature:self.firstPartySignatureViewController];
}

- (void)employeeSignatureTapped {
    [self expandSignature:self.secondPartySignatureViewController];
}

- (void)expandSignature:(HYPSignatureViewController *)signatureViewController {
    [self setUpGestureInSignatureController:signatureViewController removed:YES];

    self.overlayView.frame = self.navigationController.view.bounds;
    [self.navigationController.view addSubview:self.overlayView];

    self.originalRect = signatureViewController.view.frame;
    CGRect newRect = [self.view convertRect:signatureViewController.view.frame toView:self.navigationController.view];
    [self.navigationController hyp_addViewController:signatureViewController];

    signatureViewController.view.frame = newRect;
    self.previousRect = newRect;

    CGRect mainBounds = [[UIScreen mainScreen] bounds];

    CGRect frame = CGRectMake((CGRectGetWidth(mainBounds) / 2) - HYPSignatureWidth / 2, (CGRectGetHeight(mainBounds) / 2) - HYPSignatureHeight / 2, HYPSignatureWidth, HYPSignatureHeight);

    [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        signatureViewController.view.layer.transform = CATransform3DIdentity;
        signatureViewController.view.frame = frame;
        self.overlayView.alpha = 1.0f;
        signatureViewController.signHereLabel.alpha = 0.0f;
        signatureViewController.doneButton.alpha = 1.0f;
        signatureViewController.cancelButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        signatureViewController.signatureView.userInteractionEnabled = YES;
    }];
}

- (void)dismissSignatureController:(HYPSignatureViewController *)signatureViewController {
    CGRect frame = self.previousRect;

    [UIView animateWithDuration:0.4 animations:^{
        signatureViewController.view.layer.transform = CATransform3DMakeScale(.515, .515, 1);
        signatureViewController.view.frame = frame;
        self.overlayView.alpha = 0.0f;
        signatureViewController.doneButton.alpha = 0.0f;
        signatureViewController.cancelButton.alpha = 0.0f;
        // ONLY SHOW IF NOT SIGNED-signatureViewController.signHereLabel.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self hyp_addViewController:signatureViewController];
        [self.overlayView removeFromSuperview];
        signatureViewController.view.frame = self.originalRect;
        signatureViewController.signatureView.userInteractionEnabled = NO;
        [self setUpGestureInSignatureController:signatureViewController removed:NO];
    }];
}

- (void)setUpGestureInSignatureController:(HYPSignatureViewController *)signatureViewController removed:(BOOL)removed {
    UIGestureRecognizer *gestureRecognizer;

    BOOL isEmployeeSignature = ([signatureViewController isEqual:self.secondPartySignatureViewController]);
    if (isEmployeeSignature) {
        gestureRecognizer = self.secondPartyTapRecognizer;
    } else {
        gestureRecognizer = self.firstPartyTapRecognizer;
    }

    if (removed) {
        [signatureViewController.view removeGestureRecognizer:gestureRecognizer];
    } else {
        [signatureViewController.view addGestureRecognizer:gestureRecognizer];
    }

    if (removed) {
        signatureViewController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    } else {
        signatureViewController.view.autoresizingMask = (isEmployeeSignature)? UIViewAutoresizingFlexibleLeftMargin : UIViewAutoresizingFlexibleRightMargin;
    }
}

#pragma mark - HYPSignatureViewControllerDelegate

- (void)signatureViewControllerDidClear:(HYPSignatureViewController *)signatureViewController {
    BOOL isFirstParty = ([signatureViewController isEqual:self.firstPartySignatureViewController]);

    if (isFirstParty) {
        self.firstPartySignature = nil;
    } else {
        self.secondPartySignature = nil;
    }

    [self dismissSignatureController:signatureViewController];

    if ([self.delegate respondsToSelector:@selector(signaturesViewController:didFinishWithFirstPartySignature:secondPartySignature:)]) {
        [self.delegate signaturesViewController:self
               didFinishWithFirstPartySignature:self.firstPartySignature
                           secondPartySignature:self.secondPartySignature];
    }
}

- (void)signatureViewController:(HYPSignatureViewController *)signatureViewController
         didFinishWithSignature:(UIImage *)image {
    BOOL isFirstParty = ([signatureViewController isEqual:self.firstPartySignatureViewController]);

    if (isFirstParty) {
        self.firstPartySignature = image;
    } else {
        self.secondPartySignature = image;
    }

    [self dismissSignatureController:signatureViewController];

    if ([self.delegate respondsToSelector:@selector(signaturesViewController:didFinishWithFirstPartySignature:secondPartySignature:)]) {
        [self.delegate signaturesViewController:self
               didFinishWithFirstPartySignature:self.firstPartySignature
                           secondPartySignature:self.secondPartySignature];
    }
}

@end
