@import UIKit;

@class HYPContract;

static const CGSize HYPContractPopoverSize = { .width = 320.0f, .height = 360.0f };

@protocol HYPContractViewControllerDelegate;

@interface HYPContractViewController : UIViewController

@property (nonatomic, weak) id <HYPContractViewControllerDelegate> delegate;

- (instancetype)initWithURLRequest:(NSURLRequest *)URLRequest
                    firstPartyName:(NSString *)firstPartyName
                   secondPartyName:(NSString *)secondPartyName
                    needsSignature:(BOOL)needsSignature;

- (void)presentSignatureControl;

@end

@protocol HYPContractViewControllerDelegate <NSObject>

- (void)contractControllerDidSign:(HYPContractViewController *)contractController
              firstPartySignature:(UIImage *)firstPartySignature
          andSecondPartySignature:(UIImage *)secondPartySignature;

@end
