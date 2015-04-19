@import AssetsLibrary;

#import "HYPContractViewController.h"

#import "HYPSignaturesViewController.h"
#import "HYPWebView.h"
#import "SVProgressHUD.h"
#import "HYPButton.h"
#import "UIColor+HYPColors.h"
#import "UIFont+HYPStyles.h"

#import "UIViewController+HYPContainer.h"

static CGFloat const HYPControlViewHeight = 210.0f;
static const CGRect HYPContractSignatureButtonRect = {0.0f, 0.0f, 250.0f, 35.0f};
static const CGRect HYPContractEmailButtonRect = {0.0f, 0.0f, 200.0f, 35.0f};

@interface HYPContractViewController () <UIScrollViewDelegate, HYPWebViewDelegate,
HYPSignaturesViewControllerDelegate>

@property (nonatomic) BOOL controlViewPresented;
@property (nonatomic) HYPWebView *webView;
@property (nonatomic) HYPSignaturesViewController *controlsViewController;
@property (nonatomic) CGRect previousRect;
@property (nonatomic) UIImage *firstPartySignature;
@property (nonatomic) UIImage *secondPartySignature;
@property (nonatomic, copy) NSString *contractURL;
@property (nonatomic, copy) NSString *firstPartyName;
@property (nonatomic, copy) NSString *secondPartyName;
@property (nonatomic) HYPButton *signatureComposerButton;
@property (nonatomic) HYPButton *sendButton;
@property (nonatomic) BOOL needsSignature;

@end

@implementation HYPContractViewController

- (instancetype)initWithContractURL:(NSString *)contractURL
                     firstPartyName:(NSString *)firstPartyName
                    secondPartyName:(NSString *)secondPartyName
                     needsSignature:(BOOL)needsSignature {
    self = [super init];
    if (!self) return nil;

    self.title = NSLocalizedString(@"Contract", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _contractURL = contractURL;
    _firstPartyName = firstPartyName;
    _secondPartyName = secondPartyName;
    _needsSignature = needsSignature;

    return self;
}

#pragma mark - Getters

- (HYPWebView *)webView {
    if (_webView) return _webView;

    _webView = [[HYPWebView alloc] initWithFrame:self.view.frame];
    _webView.webViewDelegate = self;
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

- (UIBarButtonItem *)leftButton {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Dismiss", nil)
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(cancelButtonAction)];

    return button;
}

- (UIBarButtonItem *)rightButton {
    UIBarButtonItem *doneButton;

    doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil)
                                                  style:UIBarButtonItemStyleDone
                                                 target:self
                                                 action:@selector(doneButtonAction)];
    doneButton.enabled = NO;

    return doneButton;
}

- (HYPButton *)signatureComposerButton {
    if (_signatureComposerButton) return _signatureComposerButton;

    _signatureComposerButton = [HYPButton stickyButtonWithFrame:HYPContractSignatureButtonRect
                                                           title:NSLocalizedString(@"ContractSignatureComposerShow", nil)
                                                          target:self
                                                          action:@selector(presentSignatureControl)];

    return _signatureComposerButton;
}

- (HYPButton *)sendButton {
    if (_sendButton) return _sendButton;

    _sendButton = [HYPButton stickyButtonWithFrame:HYPContractEmailButtonRect
                                              title:NSLocalizedString(@"SendToEmail", nil)
                                             target:self
                                             action:@selector(sendButtonAction)];

    return _sendButton;
}

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    [self styleNavigationBar];

    self.navigationItem.leftBarButtonItem = [self leftButton];
    self.navigationItem.rightBarButtonItem = [self rightButton];

    [self.view addSubview:self.webView];

    CGFloat y = CGRectGetHeight(self.view.frame);
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGRect frame = CGRectMake(0.0f, y + HYPControlViewHeight, width, HYPControlViewHeight);
    [self hyp_addViewController:self.controlsViewController inFrame:frame];

    self.controlViewPresented = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self loadRequestForContractURL:self.contractURL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Private Methods

- (void)showToolbar {
    NSMutableArray *items = [NSMutableArray new];

    [items addObject:[[UIBarButtonItem alloc] initWithCustomView:self.sendButton]];

    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                   target:self
                                                                   action:nil]];

    if (self.needsSignature) {
        [items addObject:[[UIBarButtonItem alloc] initWithCustomView:[self signatureComposerButton]]];
    }

    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController.toolbar setItems:items];
}

- (void)styleNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor HYPLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor HYPCoreBlue];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HYPCoreBlue],
                                                                    NSFontAttributeName            : [UIFont HYPMediumSizeBold]};
}

- (void)loadRequestForContractURL:(NSString *)contractURL {
    NSURL *requestURL = [NSURL URLWithString:contractURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
//    [request setValue:[HYPTokenManager token] forHTTPHeaderField:HYPHeaderTokenKey];
    [self.webView loadRequest:request];
}

#pragma mark - Control Methods

- (void)presentSignatureControl {
    self.controlViewPresented = !self.controlViewPresented;

    NSString *title = (self.controlViewPresented) ? NSLocalizedString(@"ContractSignatureComposerHide", nil) : NSLocalizedString(@"ContractSignatureComposerShow", nil);
    [self.signatureComposerButton setTitle:title
                                  forState:UIControlStateNormal];

    [self animateControlView:self.controlsViewController.view
                        show:self.controlViewPresented];
}

- (void)animateControlView:(UIView *)view show:(BOOL)show {
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
                     } completion:nil];
}

#pragma mark - HYPSignaturesViewControllerDelegate

- (void)signaturesViewController:(HYPSignaturesViewController *)signaturesViewController
didFinishWithFirstPartySignature:(UIImage *)firstPartySignature
            secondPartySignature:(UIImage *)secondPartySignature {
    BOOL shouldHideSendButton = (!firstPartySignature || !secondPartySignature);
    self.sendButton.hidden = shouldHideSendButton;

    BOOL hasBothSignatures = (firstPartySignature && secondPartySignature);
    self.navigationItem.rightBarButtonItem.enabled = hasBothSignatures;

    self.secondPartySignature = firstPartySignature;
    self.firstPartySignature = secondPartySignature;
}

#pragma mark - Actions

- (void)cancelButtonAction {
    [SVProgressHUD dismiss];
    [self.delegate contractControllerDidDismiss:self];
}

- (void)doneButtonAction {
    [self.delegate contractControllerDidFinish:self
                       withFirstPartySignature:self.firstPartySignature
                       andSecondPartySignature:self.secondPartySignature];
}

- (void)sendButtonAction {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

//    NSURL *contractURL = [NSURL URLWithString:self.contract.url];
//    [self.networking downloadContract:contractURL completion:^(NSData *pdfData, NSError *error) {
//        [SVProgressHUD dismiss];
//
//        if (error || !pdfData) {
//
//            [PSTAlertController presentDismissableAlertWithTitle:NSLocalizedString(@"ErrorSENDContract", nil)
//                                                         message:nil
//                                                      controller:self];
//            return;
//        }
//
//        [self.emailManager applySystemStyle];
//
//        HYPEmailAttachment *attachment = [HYPEmailAttachment new];
//        attachment.data = pdfData;
//        attachment.mimeType = @"application/pdf";
//        attachment.fileName = @"HYP-kontrakt.pdf";
//
//        [self.emailManager sendMailTo:self.contract.employee.emailAddress
//                              subject:NSLocalizedString(@"SENDContractSubject", nil)
//                                 body:NSLocalizedString(@"SENDContractBody", nil)
//                           attachment:attachment
//                      usingController:self];
//    }];
}

#pragma mark - HYPEmailManagerDelegate

//- (void)emailManagerDidFinished:(HYPEmailManager *)emailManager {
//    [appDelegate applyStyle];
//}

#pragma mark - HYPWebViewDelegate

- (void)webViewDidFinishLoading:(HYPWebView *)webView error:(NSError *)error {
    if (!error) {
        [self showToolbar];
        self.navigationItem.rightBarButtonItem = [self rightButton];
    }
}

@end
