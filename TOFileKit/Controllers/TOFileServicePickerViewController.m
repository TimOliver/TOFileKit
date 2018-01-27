//
//  ICServicePickerViewController.m
//  icomics
//
//  Created by Tim Oliver on 28/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICDownloadServicePickerViewController.h"
#import "ICDownloadService.h"
#import "ICDownloadOAuthWebViewController.h"
#import "ICAccount.h"
#import "ICEditAccountViewController.h"

@interface ICDownloadServicePickerViewController ()

@property (nonatomic, strong) NSArray *firstPartyServices;
@property (nonatomic, strong) NSArray *thirdPartyServices;

@property (nonatomic, strong) UIBarButtonItem *cancelButton;

- (void)cancelButtonTapped;
- (Class)downloadServiceClassForIndexPath:(NSIndexPath *)indexPath;

- (void)didAuthenticateNewOAuthService:(ICOAuthDownloadService *)service;
- (void)didRegisterNewLocalService:(ICNetworkDownloadService *)service;

@end

@implementation ICDownloadServicePickerViewController

#pragma mark - View Controller Life Cycle -
- (instancetype)init
{
    if (self = [super initWithThemeType:ICThemeTableViewTypeGroupedSettings cellStyle:UITableViewCellStyleSubtitle]) {
        self.title = NSLocalizedString(@"Choose a New Service", @"");
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Get the different types of services
    self.firstPartyServices = [ICDownloadService fileHostingServices];
    self.thirdPartyServices = [ICDownloadService networkProtocolServices];
    
    //Configure the navigation bar
    id<ICTheme> theme = [ICThemeManager sharedTheme];
    [ICThemeManager customizeNavigationBar:self.navigationController.navigationBar inAppSection:ICThemeAppSectionSettings];

    //Add the cancel button
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    //Remove the 'Pick a Service' title from the back buttons
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

#pragma mark - Table View Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.firstPartyServices.count;
    }
        
    return self.thirdPartyServices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    Class service = [self downloadServiceClassForIndexPath:indexPath];
    if (service == nil) {
        return cell;
    }
    
    cell.imageView.image = [service icon];
    cell.textLabel.text = [service name];
    
    return cell;
}

 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class serviceClass = [self downloadServiceClassForIndexPath:indexPath];
    if (serviceClass == nil) {
        return;
    }

    ICDownloadService *service = [ICDownloadService downloadServiceForType:[serviceClass serviceType]];
    
    //If service is OAuth, create and push the appropriate service view controller
    if (ICDownloadServiceIsOAuth(service.serviceType)) {
        ICDownloadOAuthWebViewController *webController = [[ICDownloadOAuthWebViewController alloc] initWithService:(ICOAuthDownloadService *)service];
        webController.authenticationSuccessHandler = ^(ICOAuthDownloadService *service) {
            [self didAuthenticateNewOAuthService:service];
        };
        
        [self.navigationController pushViewController:webController animated:YES];
    }
    else { //If service is a local server, spawn the appropriate form controller
        ICEditAccountViewController *formController = [[ICEditAccountViewController alloc] initWithNewAccountForServiceType:service.serviceType];
        formController.registeredNewServiceHandler = ^(ICNetworkDownloadService *service) {
            
        };
        
        [self.navigationController pushViewController:formController animated:YES];
    }
}

#pragma mark - Authentication Success -
- (void)didAuthenticateNewOAuthService:(ICOAuthDownloadService *)service
{
    ICAccount *account = [ICAccount accountWithOAuthDownloadService:service];
    [[ICAccount accountsRealm] transactionWithBlock:^{
        [[ICAccount accountsRealm] addObject:account];
    }];
    
    
    if (self.didAddNewAccountHandler) {
        self.didAddNewAccountHandler();
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRegisterNewLocalService:(ICNetworkDownloadService *)service
{
    
}

#pragma mark - Interaction -
- (void)cancelButtonTapped
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Convenience Methods -
- (Class)downloadServiceClassForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 1 || indexPath.section < 0) {
        return nil;
    }
    
    NSArray *services = indexPath.section == 1 ? self.firstPartyServices : self.thirdPartyServices;
    if (indexPath.row < 0 || indexPath.row >= services.count) {
        return nil;
    }
    
    return services[indexPath.row];
}

@end
