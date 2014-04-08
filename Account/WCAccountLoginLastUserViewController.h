#import "WCBaseTextFieldItem.h"

@interface WCAccountLoginLastUserViewController : UIViewController
{
    WCBaseTextFieldItem *m_textFieldPwdItem;
    UILabel *m_labelUserName;
}

- (void)onNext;

@end