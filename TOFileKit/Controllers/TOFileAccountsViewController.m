//
//  ICDownloadServicesViewController.m
//  icomics
//
//  Created by Tim Oliver on 8/31/15.
//  Copyright (c) 2015 Timothy Oliver. All rights reserved.
//

#import "TOFileAccountsViewController.h"

#import "ICDownloadServicePickerViewController.h"
#import "ICDownloadsTabBarController.h"
#import "ICDownloadLocalServicePickerViewController.h"

#import "ICEditAccountViewController.h"

#import "ICLocalServiceDiscoveryManager.h"
#import "ICLocalService.h"

#import "ICAccount.h"
#import "ICDownloadService.h"
#import "ICNetworkDownloadService.h"
#import "ICCloudDocumentManager.h"

#import "UIImage+Encoding.h"

const NSInteger kICAccountsMaximumLocalServices = 6;

@interface TOFileAccountsViewController () <NSNetServiceBrowserDelegate>

/* Footer view explaining to tap table cells to edit */
@property (nonatomic, strong) UILabel *editingFooterView;

/* Edit Buttons */
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

/* iCloud Documents Manager */
@property (nonatomic, strong) ICCloudDocumentManager *cloudDocumentManager;

/** Manually Managed Assets */
@property (nonatomic, strong) UIImage *addNewAccountIcon;

/** Accounts Management */
@property (nonatomic, strong) RLMRealm *accountsRealm;
@property (nonatomic, strong) RLMNotificationToken *notificationToken;
@property (nonatomic, strong) RLMResults *accounts;

/** Service Discovery Management */
@property (nonatomic, strong) ICLocalServiceDiscoveryManager *serviceDiscoveryManager;

/** Explicitly manage the editing state */
@property (nonatomic, assign) BOOL editingAccounts;

/** Disable Realm automatic updates while we're explicitly editing */
@property (nonatomic, assign) BOOL inlineEditing;

@end

@implementation ICDownloadAccountsViewController

- (instancetype)init
{
    if (self = [super initWithThemeType:ICThemeTableViewTypeGroupedSettings cellStyle:UITableViewCellStyleSubtitle]) {
        self.title = NSLocalizedString(@"Network", @"");
        self.accountsRealm = [ICAccount accountsRealm];
        self.serviceDiscoveryManager = [[ICLocalServiceDiscoveryManager alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    if (self.notificationToken) {
        [self.notificationToken invalidate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Preload assets
    self.addNewAccountIcon = [[UIImage imageNamed:@"DownloadTableIcon-New"] decompress];
    
    //Configure the table view
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    //Configure the theme
    id<ICTheme> theme = [ICThemeManager sharedTheme];
    [ICThemeManager customizeNavigationBar:self.navigationController.navigationBar inAppSection:ICThemeAppSectionSettings];
    
    //Configure the navigation bar buttons
    UIBarButtonItem *cloudButton = [[UIBarButtonItem alloc] initWithImage:[theme imageForIconType:ICThemeIconTypeAppCloud] style:UIBarButtonItemStylePlain target:self action:@selector(cloudButtonTapped:)];
    self.navigationItem.leftBarButtonItem = cloudButton;
    
    //Edit button for managing user-added accounts
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    //Done button for when editing of accounts is complete
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonTapped:)];
    
    //A helper view to let users know that tapping an editable account will open its settings
    //(Because adding an arrow accessory next to a re-order control looks terrible. :( )
    self.editingFooterView = [[UILabel alloc] initWithFrame:(CGRect){0,0,320,25}];
    self.editingFooterView.backgroundColor = self.tableView.backgroundView.backgroundColor;
    self.editingFooterView.textColor = [theme textColorForTableViewSectionAccessory:UITableViewStyleGroupedSectionAccessoryFooter forType:ICThemeTableViewTypeGroupedDefault];
    self.editingFooterView.textAlignment = NSTextAlignmentCenter;
    self.editingFooterView.text = NSLocalizedString(@"Tap an account to edit its settings.", @"");
    self.editingFooterView.font = [theme fontForTableViewSectionAccessory:UITableViewStyleGroupedSectionAccessoryFooter forType:ICThemeTableViewTypeGroupedDefault];
}
    
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Load the user accounts from memory
    [self reloadAccounts];
    
    //Start looking for local services
    [self.serviceDiscoveryManager beginServiceDiscovery];
    
    //Set update block
    __weak typeof(self) weakSelf = self;
    self.serviceDiscoveryManager.servicesListUpdatedHandler = ^{
        [weakSelf updateServicesSection];
    };
}

#pragma mark - Accounts Management -
- (void)reloadAccounts
{
    //Set the query on the results object on our first run
    if (self.accounts == nil) {
        self.accounts = [[ICAccount allObjectsInRealm:self.accountsRealm] sortedResultsUsingKeyPath:@"orderedIndex" ascending:YES];
    }
    
    //Enable/Disable the edit button
    self.navigationItem.rightBarButtonItem.enabled = self.accounts.count > 0;
}

#pragma mark - Bar Button Callbacks -
- (void)cloudButtonTapped:(id)sender
{
    if ([ICCloudDocumentManager isAvailable] == NO)
        return;
    
    __weak typeof(self) blockSelf = self;
    self.cloudDocumentManager = [[ICCloudDocumentManager alloc] initWithParentViewController:self];
    self.cloudDocumentManager.completionHandler = ^{ blockSelf.cloudDocumentManager = nil; };
    [self.cloudDocumentManager presentFromBarButtonItem:sender];
}

- (void)editButtonTapped:(id)sender
{
    [self setEditingAccounts:!self.editingAccounts animated:YES];
}

- (void)setEditingAccounts:(BOOL)editingAccounts
{
    [self setEditingAccounts:editingAccounts animated:NO];
}

- (void)setEditingAccounts:(BOOL)editingAccounts animated:(BOOL)animated
{
    _editingAccounts = editingAccounts;
    [self.tableView setEditing:self.editingAccounts animated:YES];
    
    // Hide or show the devices section
    NSIndexSet *deviceSectionIndexSet = [NSIndexSet indexSetWithIndex:1];
    NSIndexPath *addAccountIndexPath = [NSIndexPath indexPathForRow:self.accounts.count inSection:0];
    
    //Ensure all updates are in one transaction
    if (animated) {
        [self.tableView beginUpdates];
        {
            // Insert / Remove the 'Add New Account' button
            UITableViewRowAnimation animation = UITableViewRowAnimationFade;
            if (self.editingAccounts) {
                [self.tableView insertRowsAtIndexPaths:@[addAccountIndexPath] withRowAnimation:animation];
                [[self.tableView footerViewForSection:0] removeFromSuperview];
            }
            else {
                [self.tableView deleteRowsAtIndexPaths:@[addAccountIndexPath] withRowAnimation:animation];
            }
            
            // Add or remove the local services seciont
            BOOL localServicesAreAvailable = (self.serviceDiscoveryManager.services.count > 0);
            if (localServicesAreAvailable) {
                if (self.editingAccounts) {
                    [self.tableView deleteSections:deviceSectionIndexSet withRowAnimation:animation];
                }
                else {
                    [self.tableView insertSections:deviceSectionIndexSet withRowAnimation:animation];
                }
            }
        }
        
        self.tableView.tableFooterView = self.editingAccounts ? self.editingFooterView : nil;
        [self.tableView endUpdates];//End transaction
    }
    else {
        self.tableView.tableFooterView = self.editingAccounts ? self.editingFooterView : nil;
        [self.tableView reloadData];
    }
    
    //If we're editing, disable the elements in our parent toolbar
    //[self.downloadsTabBarController setToolbarHidden:self.editingAccounts animated:animated];
    
    //Set the button to 'Edit' or 'Done'
    self.navigationItem.rightBarButtonItem = (self.editingAccounts) ? self.doneButton : self.editButton;
}

#pragma mark - Update Sections -
- (void)updateServicesSection
{
    BOOL isReachable = [self.serviceDiscoveryManager discoveryAvailable];
    NSInteger numberOfSections = [self.tableView numberOfSections];
    NSIndexSet *section = [NSIndexSet indexSetWithIndex:1];
    NSInteger numberOfServices = self.serviceDiscoveryManager.services.count;
    
    if (self.editingAccounts) {
        return;
    }
    
    [self.tableView beginUpdates];
    //Insert the section if we're reachable now
    if (numberOfServices > 0 && numberOfSections == 1) {
        [self.tableView insertSections:section withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //Delete the section if we became unreachable
    if (numberOfServices == 0 && numberOfSections == 2) {
        [self.tableView deleteSections:section withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //Reload the section if there are serivces available
    if (numberOfServices > 0 && numberOfSections > 1) {
        [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

#pragma mark - Table View Configuration -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.editingAccounts || self.serviceDiscoveryManager.services.count == 0)
        return 1;
        
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSInteger numberOfAccounts = self.accounts.count;
        
        //If editing, add an extra row for the 'Add Account' button
        if (self.editingAccounts) {
            return numberOfAccounts + 1;
        }
        else { //If not editing, show the 'Add Account' button if there are no accounts
            return MAX(numberOfAccounts, 1);
        }
    }
    else {
        NSInteger devicesCount = MIN(kICAccountsMaximumLocalServices, self.serviceDiscoveryManager.services.count);
        return MAX(devicesCount, 1);
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = nil;
    cell.detailTextLabel.text = nil;
    cell.textLabel.alpha = 1.0f;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row < self.accounts.count) {
                ICAccount *account = self.accounts[indexPath.row];
                cell.textLabel.text = account.name.length ? account.name : [account.serviceClass name];
                cell.imageView.image = account.icon;
            }
            else {
                cell.textLabel.text = NSLocalizedString(@"Add a new account...", @"");
                cell.imageView.image = self.addNewAccountIcon;
            }
            break;
        case 1:
            if (self.serviceDiscoveryManager.services.count > 0) {
                if (indexPath.row < kICAccountsMaximumLocalServices - 1) {
                    ICLocalService *service = self.serviceDiscoveryManager.services[indexPath.row];
                    cell.textLabel.text = service.name;
                    cell.detailTextLabel.text = service.serviceType;
                    cell.imageView.image = service.icon;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                else {
                    cell.textLabel.text = NSLocalizedString(@"Show All Local Services...", @"");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = self.addNewAccountIcon;
                }
            }
            else {
                cell.textLabel.alpha = 0.5f;
                cell.textLabel.text = NSLocalizedString(@"Searching for Devices...", @"");
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return NSLocalizedString(@"My Accounts", @"");
    else if (section == 1)
        return NSLocalizedString(@"Local Services", @"");
    
    return nil;
}

#pragma mark - Table View Editing -

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Ensure the 'Add Account' button has a + icon
    if (indexPath.section == 0 && indexPath.row == self.accounts.count) {
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Ensure only the account rows (Not the 'Add Account') button are movable
    return (indexPath.section == 0 && indexPath.row < self.accounts.count);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //Ensure only elements in the accounts sction can be edited
    return (indexPath.section == 0);
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.section == 0 && proposedDestinationIndexPath.row >= self.accounts.count) {
        return [NSIndexPath indexPathForRow:self.accounts.count-1 inSection:0];
    }
    
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.row == destinationIndexPath.row)
        return;
    
    //Make a non-live copy of the accounts list
    NSMutableArray *array = [NSMutableArray array];
    for (ICAccount *account in self.accounts) {
        [array addObject:account];
    }
    
    // Re-order this array as dictated by the table view
    ICAccount *accountToMove = array[sourceIndexPath.row];
    [array removeObject:accountToMove];
    [array insertObject:accountToMove atIndex:destinationIndexPath.row];
    
    self.inlineEditing = YES;
    
    // Loop through all of the items and update their orderedIndex
    [self.accounts.realm transactionWithBlock:^{
        NSInteger i = 0;
        for (ICAccount *account in array) {
            account.orderedIndex = i++;
        }
    }];
    
    self.inlineEditing = NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.inlineEditing = YES;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ICAccount *account = self.accounts[indexPath.row];
        [self.accounts.realm transactionWithBlock:^{
            [self.accounts.realm deleteObject:account];
        }];
        
        if (self.accounts.count > 0) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    self.inlineEditing = NO;
}

#pragma mark - Table View Interaction -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Accounts section
    if (indexPath.section == 0) {
        BOOL addNewAccount = NO;
        addNewAccount = (self.accounts.count == 0 && indexPath.row == 0); // No accounts
        addNewAccount = addNewAccount || (self.tableView.editing && indexPath.row >= self.accounts.count); // 'Add Account'
        if (addNewAccount) {
            ICDownloadServicePickerViewController *controller = [[ICDownloadServicePickerViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self.navigationController.parentViewController presentViewController:navController animated:YES completion:nil];
            
            controller.didAddNewAccountHandler = ^{
                self.editingAccounts = NO;
                [self.tableView reloadData];
            };
        }
        else {
            ICAccount *account = self.accounts[indexPath.row];
            if (self.editingAccounts) {
                ICEditAccountViewController *controller = [[ICEditAccountViewController alloc] initWithAccount:account];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else {
                //Access the account
            }
        }
    }
    else {
        if (indexPath.row >= kICAccountsMaximumLocalServices-1) {
            ICDownloadLocalServicePickerViewController *controller = [[ICDownloadLocalServicePickerViewController alloc] initWithServiceDiscoveryManager:self.serviceDiscoveryManager];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
