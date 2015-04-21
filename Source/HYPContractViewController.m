@import AssetsLibrary;

#import "HYPContractViewController.h"

#import "HYPSignaturesViewController.h"
#import "HYPWebView.h"
#import "SVProgressHUD.h"
#import "UIColor+HYPColors.h"
#import "UIFont+HYPStyles.h"

#import "UIViewController+HYPContainer.h"

static CGFloat const HYPControlViewHeight = 210.0f;

@interface HYPContractViewController () <UIScrollViewDelegate, HYPSignaturesViewControllerDelegate>

@property (nonatomic) BOOL controlViewPresented;
@property (nonatomic) HYPWebView *webView;
@property (nonatomic) HYPSignaturesViewController *controlsViewController;
@property (nonatomic) CGRect previousRect;
@property (nonatomic) UIImage *firstPartySignature;
@property (nonatomic) UIImage *secondPartySignature;
@property (nonatomic, copy) NSURLRequest *URLRequest;
@property (nonatomic, copy) NSString *firstPartyName;
@property (nonatomic, copy) NSString *secondPartyName;
@property (nonatomic) BOOL needsSignature;

@end

@implementation HYPContractViewController

- (instancetype)initWithURLRequest:(NSURLRequest *)URLRequest
                    firstPartyName:(NSString *)firstPartyName
                   secondPartyName:(NSString *)secondPartyName
                    needsSignature:(BOOL)needsSignature {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;

    self.title = NSLocalizedString(@"Contract", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _URLRequest = URLRequest;
    _firstPartyName = firstPartyName;
    _secondPartyName = secondPartyName;
    _needsSignature = needsSignature;

    return self;
}

#pragma mark - Getters

- (HYPWebView *)webView {
    if (_webView) return _webView;

    _webView = [[HYPWebView alloc] initWithFrame:self.view.frame];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return _webView;
}

- (HYPSignaturesViewController *)controlsViewController {
    if (_controlsViewController) return _controlsViewController;

    _controlsViewController = [[HYPSignaturesViewController alloc] initWithFirstPartyName:self.firstPartyName
                                                                       andSecondPartyName:self.secondPartyName];
    _controlsViewController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _controlsViewController.delegate = self;

    return _controlsViewController;
}

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    [self.view addSubview:self.webView];

    CGFloat y = CGRectGetHeight(self.view.frame);
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGRect frame = CGRectMake(0.0f, y + HYPControlViewHeight, width, HYPControlViewHeight);
    [self hyp_addViewController:self.controlsViewController inFrame:frame];

    self.controlViewPresented = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.webView loadRequest:self.URLRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Control Methods

- (void)toogleSignatureControl {
    self.controlViewPresented = !self.controlViewPresented;

    [self animateControlView:self.controlsViewController.view
                        show:self.controlViewPresented
                  completion:^{
                      if ([self.delegate respondsToSelector:@selector(contractController:didToogleSignatureControl:)]) {
                          [self.delegate contractController:self
                                  didToogleSignatureControl:self.controlViewPresented];
                      }
                  }];
}

- (void)animateControlView:(UIView *)view
                      show:(BOOL)show
                completion:(void (^)())completion {
    CGRect webViewFrame = self.webView.frame;
    CGRect controlViewFrame = view.frame;

    CGFloat margin = CGRectGetHeight(self.view.frame);

    if (show) {
        margin -= HYPControlViewHeight;
    } else {
        margin += HYPControlViewHeight;
    }

    controlViewFrame.origin.y = margin;
    webViewFrame.size.height = margin;

    [UIView animateWithDuration:0.35f delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.webView setFrame:webViewFrame];
                         [view setFrame:controlViewFrame];
                     } completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

#pragma mark - HYPSignaturesViewControllerDelegate

- (void)signaturesViewController:(HYPSignaturesViewController *)signaturesViewController
didFinishWithFirstPartySignature:(UIImage *)firstPartySignature
            secondPartySignature:(UIImage *)secondPartySignature {

    self.firstPartySignature = secondPartySignature;
    self.secondPartySignature = firstPartySignature;

    if ([self.delegate respondsToSelector:@selector(contractControllerDidSign:firstPartySignature:andSecondPartySignature:)]) {
        [self.delegate contractControllerDidSign:self
                             firstPartySignature:self.firstPartySignature
                         andSecondPartySignature:self.secondPartySignature];
    }
}

@end
