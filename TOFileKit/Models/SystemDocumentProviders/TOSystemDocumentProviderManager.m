//
//  ICCloudDocumentManager.m
//  icomics
//
//  Created by Tim Oliver on 12/5/14.
//  Copyright (c) 2014 Timothy Oliver. All rights reserved.
//

#import "TOSystemDocumentBrowserManager.h"

@interface TOSystemDocumentBrowserManager () <UIPopoverControllerDelegate, UIDocumentPickerDelegate, UIDocumentMenuDelegate>

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation TOSystemDocumentBrowserManager

+ (BOOL)isAvailable
{
    return (NSClassFromString(@"UIDocumentPickerViewController") != nil);
}

- (instancetype)initWithParentViewController:(UIViewController *)parentController
{
    if (self = [super init]) {
        _parentViewController = parentController;
    }
    
    return self;
}

- (void)presentFromBarButtonItem:(UIBarButtonItem *)barItem
{
    if (barItem == nil)
        return;
    
    //Delete any pre-existing popover controller
    if (self.popoverController) {
        [self.popoverController dismissPopoverAnimated:NO];
        self.popoverController = nil;
    }
    
    /*#import <MobileCoreServices/MobileCoreServices.h>
    NSArray *items = @[@"zip", @"cbz", @"rar", @"cbr", @"tar", @"cbt", @"7z", @"cb7", @"epub", @"lzh", @"lha"];
    for (NSString *item in items) {
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)item, NULL);
        NSLog(@"%@ %@", item, fileUTI);
    }*/
    
    //Create the document menu view controller
    UIDocumentMenuViewController *controller = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:[ICComicLoader acceptableDocumentTypes] inMode:UIDocumentPickerModeImport];
    controller.delegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromBarButtonItem:barItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        CGSize popoverSize = self.popoverController.popoverContentSize;
        popoverSize.width = 320.0f;
        self.popoverController.popoverContentSize = popoverSize;
    }
    else {
        [self.parentViewController presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - Document Menu Delegate -
- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker
{
    documentPicker.delegate = self;
    [self.parentViewController presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentMenuWasCancelled:(UIDocumentMenuViewController *)documentMenu
{
    if (self.completionHandler)
        self.completionHandler();
}

#pragma mark - Document Picker Delegate -
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    if (self.completionHandler)
        self.completionHandler();
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    [[ICComicFileManager sharedComicFileManager] importComicsFromDocumentInteractionWithURL:url];
    
    if (self.importSucceededHandler)
        self.importSucceededHandler();
    
    if (self.completionHandler)
        self.completionHandler();
}

@end
