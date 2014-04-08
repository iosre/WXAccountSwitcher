//
//  AccountListController.m
//  hkimmd
//
//  Created by sam on 4/6/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "AccountListController.h"
#import "NSDictionary+Keychain.h"

@implementation AccountInfo

+ (NSString *)getPlistPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"AccountList.plist"];
    return path;
}

+ (NSMutableArray *)getAccountList
{
    static NSMutableArray *accountList = nil;
    
    if (accountList == nil) {
        accountList = [[NSMutableArray alloc] init];
    }
    [accountList removeAllObjects];
    /*
    NSPropertyListFormat format;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:[AccountInfo getPlistPath]];
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSPropertyListSerialization
                                                        propertyListFromData:plistXML
                                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                        format:&format errorDescription:nil];
     */
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryFromKeychainWithKey:@"AccountList"]];
    if (dict) {
        NSArray *array = [dict objectForKey:@"User"];
        for (NSInteger i=0; i<array.count; i++) {
            NSDictionary *dict2 = [array objectAtIndex:i];
            AccountInfo *ai = [[AccountInfo alloc] init];
            ai.userName = [dict2 objectForKey:@"UserName"];
            ai.userPwd = [dict2 objectForKey:@"UserPwd"];
            ai.nickName = [dict2 objectForKey:@"NickName"];
            [accountList addObject:ai];
            [ai release];
        }
    }
    
    return accountList;
}

+ (void)updateAccountList:(NSArray *)accountList
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *arrary = [NSMutableArray array];
    for (NSInteger i=0; i<accountList.count; i++) {
        AccountInfo *ai = [accountList objectAtIndex:i];
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        [dict2 setValue:ai.nickName forKey:@"NickName"];
        [dict2 setValue:ai.userName forKey:@"UserName"];
        [dict2 setValue:ai.userPwd forKey:@"UserPwd"];
        [arrary addObject:dict2];
        [dict setObject:arrary forKey:@"User"];
    }
    //[dict writeToFile:[AccountInfo getPlistPath] atomically:YES];
    [dict storeToKeychainWithKey:@"AccountList"];
}

+ (void)updateAccount:(AccountInfo *)ai
{
    NSMutableArray *accountList = [AccountInfo getAccountList];
    BOOL isFind = NO;
    for (NSInteger i=0; i<accountList.count; i++) {
        AccountInfo *ai2 = [accountList objectAtIndex:i];
        if ([ai2.userName isEqualToString:ai.userName] == YES) {
            [accountList replaceObjectAtIndex:i withObject:ai];
            isFind = YES;
            break;
        }
    }
    if (isFind == NO) {
        [accountList addObject:ai];
        isFind = YES;
    }
    [AccountInfo updateAccountList:accountList];
}

@end

@interface AccountListController () {
    NSMutableArray *accountList;
}

@end

@implementation AccountListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.title = @"Switch Account";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(clickClose)] autorelease];
    self.tableView.rowHeight = 60;
    [self getAccountList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAccountList
{
    accountList = [AccountInfo getAccountList];
}

- (void)deleteAccount:(NSInteger)idx
{
    if (idx >= 0 && idx < accountList.count) {
        [accountList removeObjectAtIndex:idx];
        [AccountInfo updateAccountList:accountList];
    }
}

- (void)setAccount:(NSInteger)idx
{
    if (self.parent != nil && [self.parent respondsToSelector:@selector(setAccount:)]) {
        if (idx >= 0 && idx < accountList.count) {
            [self.parent performSelector:@selector(setAccount:) withObject:[accountList objectAtIndex:idx]];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return accountList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.row < accountList.count) {
        AccountInfo *ai = [accountList objectAtIndex:indexPath.row];
        cell.textLabel.text = ai.userName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < accountList.count) {
        [self setAccount:indexPath.row];
        [self clickClose];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [self deleteAccount:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)clickClose
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
