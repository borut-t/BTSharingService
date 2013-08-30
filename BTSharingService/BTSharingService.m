//
//  BTSharingService.m
//
//  Version 1.0.0
//
//  Created by Borut Tomazin on 8/30/2013.
//  Copyright 2013 Borut Tomazin
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/borut-t/BTSharingService
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "BTSharingService.h"

#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "Facebook.h"

#define kFacebookKey @"XXXXX"

#define kMailNotEnabledTitle      @"Za pošiljanje elektronskih sporočil si najprej ustvarite poštni račun."
#define kMailNotEnabledMsg        @"To lahko storite v nastavitvah naprave (Settings -> Mail, Contacts, Calendars)."
#define kiMessageNotEnabledTitle  @"Pošiljanje Message sporočil ni na voljo."
#define kiMessageNotEnabledMsg    @"Vklopite jih v nastavitvah naprave (Settings -> Messages)."
#define kFacebookNotEnabledTitle  @"Facebook račun ni vklopljen."
#define kFacebookNotEnabledMsg    @"Vklopite ga v nastavitvah naprave (Settings -> Facebook)."
#define kTwitterNotEnabledTitle   @"Twitter račun ni vklopljen."
#define kTwitterNotEnabledMsg     @"Vklopite ga v nastavitvah naprave (Settings -> Twitter)."
#define kTwitterNotAvailableTitle @"Twitter je na voljo samo za naprave z nameščenim iOS 5.0 ali novejšim."
#define kTwitterNotAvailableMsg   @"Če imate možnost potem nadgradite iOS."

@interface BTSharingService() <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, FBDialogDelegate, FBRequestDelegate, FBSessionDelegate>

@end

@implementation BTSharingService

+ (id)sharedInstance
{
    static BTSharingService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)shareWithServiceType:(BTSharingServiceType)serviceType forSharingData:(NSDictionary *)sharingData onViewController:(UIViewController *)viewController
{
    switch (serviceType) {
        //Facebook
        case BTSharingServiceTypeFacebook:
        {
            // iOS 6+
            if ([SLComposeViewController class]) {
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                    __weak SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                    [facebookController setInitialText:[sharingData objectForKey:@"body"]];
                    [facebookController addURL:[NSURL URLWithString:[sharingData objectForKey:@"url"]]];
                    facebookController.completionHandler = ^(SLComposeViewControllerResult result) {
                        [facebookController dismissViewControllerAnimated:YES completion:nil];
                    };
                    [viewController presentViewController:facebookController animated:YES completion:nil];
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kFacebookNotEnabledTitle
                                                                        message:kFacebookNotEnabledMsg
                                                                       delegate:nil
                                                              cancelButtonTitle:@"V redu"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            // iOS < 6
            else {
                Facebook *facebook = [[Facebook alloc] initWithAppId:kFacebookKey andDelegate:self];
                [facebook dialog:@"feed" andParams:[@{@"app_id": kFacebookKey, @"name": [sharingData objectForKey:@"body"], @"link": [sharingData objectForKey:@"url"]} mutableCopy] andDelegate:self];
            }
        }
        break;
            
        //Twitter
        case BTSharingServiceTypeTwitter:
        {
            // iOS 6+
            if ([SLComposeViewController class]) {
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                    __weak SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                    [twitterController setInitialText:[sharingData objectForKey:@"body"]];
                    [twitterController addURL:[NSURL URLWithString:[sharingData objectForKey:@"url"]]];
                    twitterController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
                        [twitterController dismissViewControllerAnimated:YES completion:nil];
                    };
                    [viewController presentViewController:twitterController animated:YES completion:nil];
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kTwitterNotEnabledTitle
                                                                        message:kTwitterNotEnabledMsg
                                                                       delegate:nil
                                                              cancelButtonTitle:@"V redu"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            // iOS 5
            else if ([TWTweetComposeViewController class]) {
                if ([TWTweetComposeViewController canSendTweet]) {
                    TWTweetComposeViewController *twitterController = [[TWTweetComposeViewController alloc] init];
                    [twitterController setInitialText:[sharingData objectForKey:@"body"]];
                    [twitterController addURL:[NSURL URLWithString:[sharingData objectForKey:@"url"]]];
                    
                    __weak TWTweetComposeViewController *weakTwitterController = twitterController;
                    twitterController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
                        [weakTwitterController dismissViewControllerAnimated:YES completion:nil];
                    };
                    [viewController presentViewController:twitterController animated:YES completion:nil];
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kTwitterNotEnabledTitle
                                                                        message:kTwitterNotEnabledMsg
                                                                       delegate:nil
                                                              cancelButtonTitle:@"V redu"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            // not available
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kTwitterNotAvailableTitle
                                                                    message:kTwitterNotAvailableMsg
                                                                   delegate:nil
                                                          cancelButtonTitle:@"V redu"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        break;
            
        //Mail
        case BTSharingServiceTypeMail:
        {
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *sendEmail = [[MFMailComposeViewController alloc] init];
                sendEmail.mailComposeDelegate = self;
                [sendEmail setSubject:[sharingData objectForKey:@"title"]];
                [sendEmail setMessageBody:[sharingData objectForKey:@"body"] isHTML:YES];
                if ([sharingData objectForKey:@"recipients"] != nil) {
                    [sendEmail setToRecipients:[sharingData objectForKey:@"recipients"]];
                }
                sendEmail.modalPresentationStyle = UIModalPresentationFormSheet;
                [viewController presentModalViewController:sendEmail animated:YES];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMailNotEnabledTitle
                                                                message:kMailNotEnabledMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"V redu"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        break;
            
        //iMessage
        case BTSharingServiceTypeiMessage:
        {
            if ([MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController *sendMessage = [[MFMessageComposeViewController alloc] init];
                sendMessage.messageComposeDelegate = self;
                [sendMessage setBody:[sharingData objectForKey:@"body"]];
                sendMessage.modalPresentationStyle = UIModalPresentationFormSheet;
                [viewController presentModalViewController:sendMessage animated:YES];
            }
            // not available
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kiMessageNotEnabledTitle
                                                                message:kiMessageNotEnabledMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"V redu"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        break;
            
        //Safari
        case BTSharingServiceTypeSafari:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[sharingData objectForKey:@"url"]]];
        }
        break;
    }
}



#pragma mark - MailComposer Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [[controller presentingViewController] dismissModalViewControllerAnimated:YES];
}



#pragma mark - iMessageComposer Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [[controller presentingViewController] dismissModalViewControllerAnimated:YES];
}



#pragma mark - Facebook delegate
- (void)fbDidLogin {}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt {}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout {}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated {}

@end
