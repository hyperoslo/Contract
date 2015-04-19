#import "HYPButton.h"
#import "HYPSignatureView.h"

static const CGFloat HYPSignatureHeight = 350.0f;
static const CGFloat HYPSignatureWidth = 700.0f;
static const CGFloat HYPButtonWidth = 200.0f;
static const CGFloat HYPButtonHeight = 60.0f;
static const CGFloat HYPNullifyButtonSignatureWidth = 300.0f;

@class HYPEmployee;

@protocol HYPSignatureViewControllerDelegate;

@interface HYPSignatureViewController : UIViewController

@property (nonatomic, weak) id <HYPSignatureViewControllerDelegate> delegate;
@property (nonatomic) HYPButton *doneButton;
@property (nonatomic) HYPButton *cancelButton;
@property (nonatomic) UILabel *signHereLabel;
@property (nonatomic) HYPSignatureView *signatureView;

- (instancetype)initWithName:(NSString *)name;

- (void)enableButtons:(BOOL)enabled;

@end

@protocol HYPSignatureViewControllerDelegate <NSObject>

- (void)signatureViewControllerDidClear:(HYPSignatureViewController *)signatureViewController;

- (void)signatureViewController:(HYPSignatureViewController *)signatureViewController
         didFinishWithSignature:(UIImage *)image;

@end

