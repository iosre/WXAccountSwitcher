#import "Account/AccountListController.h"
#import "Account/WCAccountControlData.h"
#import "Account/WCAccountLoginLastUserViewController.h"
#import "Account/WCAccountLoginLastUserViewControllerDelegate-Protocol.h"
#import "Account/WCAccountLoginControlLogic.h"
#import "Account/WCBaseTextFieldItem.h"

%hook WCAccountLoginLastUserViewController	

- (void)viewDidLoad
{
	%orig;

	UIButton *transparentButton = [UIButton buttonWithType:UIButtonTypeCustom];
	transparentButton.frame = CGRectMake(115, 95, 90, 90);
	[transparentButton addTarget:self action:@selector(clickImage) forControlEvents:UIControlEventTouchUpInside];
	[((UIViewController *)self).view addSubview:transparentButton];
}

%new
- (void)setAccount:(AccountInfo *)ai
{
	WCBaseTextFieldItem *&m_textFieldPwdItem = MSHookIvar<WCBaseTextFieldItem *>(self, "m_textFieldPwdItem");
	[m_textFieldPwdItem setText:ai.userPwd];

	UILabel *&m_labelUserName = MSHookIvar<UILabel *>(self, "m_labelUserName");
	m_labelUserName.text = ai.userName;

	WCAccountLoginControlLogic *m_delegate = MSHookIvar<WCAccountLoginControlLogic *>(self, "m_delegate");
	[m_delegate onLastUserLoginUserName:ai.userName Pwd:ai.userPwd];
	//[self onNext];
}

%new
- (void)clickImage
{
	AccountListController *alc = [[AccountListController alloc] init];
	alc.parent = self;
	UINavigationController *unc = [[UINavigationController alloc] initWithRootViewController:alc];
	[self presentViewController:unc animated:YES completion:^{

	}];
	[alc release];
	[unc release];
}

- (void)onNext
{
	%orig;
	//WCAccountControlData *&m_data = MSHookIvar<WCAccountControlData *>(self, "m_data");

	WCBaseTextFieldItem *&m_textFieldPwdItem = MSHookIvar<WCBaseTextFieldItem *>(self, "m_textFieldPwdItem");
	UILabel *&m_labelUserName = MSHookIvar<UILabel *>(self, "m_labelUserName");

	AccountInfo *ai = [[AccountInfo alloc] init];
	ai.userName = m_labelUserName.text;
	ai.userPwd = [m_textFieldPwdItem getValue];
	//ai.nickName = m_data.m_nsNickName;
	[AccountInfo updateAccount:ai];
	[ai release];
}

%end


%hook WCAccountLoginFirstUserViewController

- (void)onNext
{
	%orig;
	//
	WCBaseTextFieldItem *&m_textFieldUserNameItem = MSHookIvar<WCBaseTextFieldItem *>(self, "m_textFieldUserNameItem");
	WCBaseTextFieldItem *&m_textFieldPwdItem = MSHookIvar<WCBaseTextFieldItem *>(self, "m_textFieldPwdItem");

	AccountInfo *ai = [[AccountInfo alloc] init];
	ai.userName = [m_textFieldUserNameItem getValue];
	ai.userPwd = [m_textFieldPwdItem getValue];
	//ai.nickName = m_data.m_nsNickName;
	[AccountInfo updateAccount:ai];
	[ai release];
}

%end


/*
   %hook WCAccountLoginControlLogic

   - (void)onLastUserLoginUserName:(id)arg1 Pwd:(id)arg2
   {
   NSLog(@"onLastUserLoginUserName <%@-%@>", arg1, arg2);
   %orig;
   }

   %end
 */
