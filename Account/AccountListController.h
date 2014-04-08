//
//  AccountListController.h
//  hkimmd
//
//  Created by sam on 4/6/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccountInfo : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPwd;
@property (nonatomic, copy) NSString *nickName;

+ (void)updateAccount:(AccountInfo *)ai;

@end


@interface AccountListController : UITableViewController

@property (nonatomic, assign) id parent;

@end
