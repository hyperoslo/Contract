@import UIKit;

@protocol HYPSignaturesViewControllerDelegate;

@interface HYPSignaturesViewController : UIViewController

@property (nonatomic, weak) id <HYPSignaturesViewControllerDelegate> delegate;
@property (nonatomic, readonly) UIImage *firstPartySignature;
@property (nonatomic, readonly) UIImage *secondPartySignature;

- (instancetype)initWithFirstPartyName:(NSString *)firsPartyName
                    andSecondPartyName:(NSString *)secondPartyName;
@end

@protocol HYPSignaturesViewControllerDelegate <NSObject>

- (void)signaturesViewController:(HYPSignaturesViewController *)signaturesViewController
didFinishWithFirstPartySignature:(UIImage *)firstPartySignature
            secondPartySignature:(UIImage *)secondPartySignature;

@end
