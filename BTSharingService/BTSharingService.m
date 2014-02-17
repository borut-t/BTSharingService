//
//  BTSharingService.m
//
//  Version 1.2
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

//localization keys
NSString *const kMailNotEnabledTitleKey       = @"MailNotEnabledTitle";
NSString *const kMailNotEnabledMsgKey         = @"MailNotEnabledMsg";
NSString *const kiMessageNotEnabledTitleKey   = @"iMessageNotEnabledTitle";
NSString *const kiMessageNotEnabledMsgKey     = @"iMessageNotEnabledMsg";
NSString *const kFacebookNotEnabledTitleKey   = @"FacebookNotEnabledTitle";
NSString *const kFacebookNotEnabledMsgKey     = @"FacebookNotEnabledMsg";
NSString *const kFacebookNotAvailableTitleKey = @"FacebookNotAvailableTitle";
NSString *const kFacebookNotAvailableMsgKey   = @"FacebookNotAvailableMsg";
NSString *const kTwitterNotEnabledTitleKey    = @"TwitterNotEnabledTitle";
NSString *const kTwitterNotEnabledMsgKey      = @"TwitterNotEnabledMsg";
NSString *const kTwitterNotAvailableTitleKey  = @"TwitterNotAvailableTitle";
NSString *const kTwitterNotAvailableMsgKey    = @"TwitterNotAvailableMsg";
NSString *const kServiceNotAvailableOkButton  = @"ServiceNotAvailableOkButton";

NSString *const BTSharingServiceLanguageEnglish   = @"en";
NSString *const BTSharingServiceLanguageSlovenian = @"sl";

@interface BTSharingService() <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UIColor *presentedViewBarTintColor;
@property (nonatomic, strong) UIImage *presentedViewBarBackgroundImage;

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

- (NSString *)localizedStringForKey:(NSString *)key
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"BTSharingService" ofType:@"bundle"];
    
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (self.preferredLanguage != nil && [bundle.localizations containsObject:self.preferredLanguage]) {
        bundlePath = [bundle pathForResource:self.preferredLanguage ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    return [bundle localizedStringForKey:key value:@"" table:nil];
}

- (void)shareWithType:(BTSharingServiceType)serviceType subject:(NSString *)subject body:(NSString *)body url:(NSURL *)url recipients:(NSArray *)recipients onViewController:(UIViewController *)viewController
{
    switch (serviceType) {
            
            //Facebook
        case BTSharingServiceTypeFacebook:
        {
            // iOS 6+
            if ([SLComposeViewController class]) {
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                    SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                    [facebookController setInitialText:body];
                    [facebookController addURL:url];
                    
                    __weak SLComposeViewController *weakFacebookController = facebookController;
                    facebookController.completionHandler = ^(SLComposeViewControllerResult result) {
                        [weakFacebookController dismissViewControllerAnimated:YES completion:nil];
                    };
                    
                    [viewController presentViewController:facebookController animated:YES completion:nil];
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self localizedStringForKey:kFacebookNotEnabledTitleKey]
                                                                        message:[self localizedStringForKey:kFacebookNotEnabledMsgKey]
                                                                       delegate:nil
                                                              cancelButtonTitle:[self localizedStringForKey:kServiceNotAvailableOkButton]
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            // not available
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self localizedStringForKey:kFacebookNotAvailableTitleKey]
                                                                    message:[self localizedStringForKey:kFacebookNotAvailableMsgKey]
                                                                   delegate:nil
                                                          cancelButtonTitle:[self localizedStringForKey:kServiceNotAvailableOkButton]
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
            break;
            
            //Twitter
        case BTSharingServiceTypeTwitter:
        {
            // iOS 6+
            if ([SLComposeViewController class]) {
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                    SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                    [twitterController setInitialText:body];
                    [twitterController addURL:url];
                    
                    __weak SLComposeViewController *weakTwitterController = twitterController;
                    twitterController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
                        [weakTwitterController dismissViewControllerAnimated:YES completion:nil];
                    };
                    
                    [viewController presentViewController:twitterController animated:YES completion:nil];
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self localizedStringForKey:kTwitterNotEnabledTitleKey]
                                                                        message:[self localizedStringForKey:kTwitterNotEnabledMsgKey]
                                                                       delegate:nil
                                                              cancelButtonTitle:[self localizedStringForKey:kServiceNotAvailableOkButton]
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            // iOS 5
            else if ([TWTweetComposeViewController class]) {
                if ([TWTweetComposeViewController canSendTweet]) {
                    TWTweetComposeViewController *twitterController = [[TWTweetComposeViewController alloc] init];
                    [twitterController setInitialText:body];
                    [twitterController addURL:url];
                    
                    __weak TWTweetComposeViewController *weakTwitterController = twitterController;
                    twitterController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
                        [weakTwitterController dismissViewControllerAnimated:YES completion:nil];
                    };
                    
                    [viewController presentViewController:twitterController animated:YES completion:nil];
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self localizedStringForKey:kTwitterNotEnabledTitleKey]
                                                                        message:[self localizedStringForKey:kTwitterNotEnabledMsgKey]
                                                                       delegate:nil
                                                              cancelButtonTitle:[self localizedStringForKey:kServiceNotAvailableOkButton]
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            // not available
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self localizedStringForKey:kTwitterNotAvailableTitleKey]
                                                                    message:[self localizedStringForKey:kTwitterNotAvailableMsgKey]
                                                                   delegate:nil
                                                          cancelButtonTitle:[self localizedStringForKey:kServiceNotAvailableOkButton]
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
            break;
            
            //Mail
        case BTSharingServiceTypeMail:
        {
            if ([MFMailComposeViewController canSendMail]) {
                [self setTintColors];
                
                MFMailComposeViewController *sendEmail = [[MFMailComposeViewController alloc] init];
                sendEmail.mailComposeDelegate = self;
                [sendEmail setSubject:subject];
                [sendEmail setMessageBody:body isHTML:YES];
                if (recipients != nil && recipients.count > 0) {
                    [sendEmail setToRecipients:recipients];
                }
                sendEmail.modalPresentationStyle = UIModalPresentationFormSheet;
                [viewController presentViewController:sendEmail animated:YES completion:NULL];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self localizedStringForKey:kMailNotEnabledTitleKey]
                                                                message:[self localizedStringForKey:kMailNotEnabledMsgKey]
                                                               delegate:nil
                                                      cancelButtonTitle:[self localizedStringForKey:kServiceNotAvailableOkButton]
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
            
            //iMessage
        case BTSharingServiceTypeiMessage:
        {
            if ([MFMessageComposeViewController canSendText]) {
                [self setTintColors];
                
                MFMessageComposeViewController *sendMessage = [[MFMessageComposeViewController alloc] init];
                sendMessage.messageComposeDelegate = self;
                [sendMessage setBody:body];
                sendMessage.modalPresentationStyle = UIModalPresentationFormSheet;
                [viewController presentViewController:sendMessage animated:YES completion:NULL];
            }
            // not available
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self localizedStringForKey:kiMessageNotEnabledTitleKey]
                                                                message:[self localizedStringForKey:kiMessageNotEnabledMsgKey]
                                                               delegate:nil
                                                      cancelButtonTitle:[self localizedStringForKey:kServiceNotAvailableOkButton]
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
            
            //Safari
        case BTSharingServiceTypeSafari:
        {
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
    }
}



#pragma mark - Custom methods
- (void)setTintColors
{
    if (self.shouldResetBarTintColor) {
        if ([UINavigationBar instancesRespondToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            self.presentedViewBarBackgroundImage = [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
            [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        }
        if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)]) {
            self.presentedViewBarTintColor = [[UINavigationBar appearance] barTintColor];
            [[UINavigationBar appearance] setBarTintColor:nil];
        }
    }
}

- (void)resetTintColors
{
    if (self.shouldResetBarTintColor) {
        if ([UINavigationBar instancesRespondToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [[UINavigationBar appearance] setBackgroundImage:self.presentedViewBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
            self.presentedViewBarBackgroundImage = nil;
        }
        if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)]) {
            [[UINavigationBar appearance] setBarTintColor:self.presentedViewBarTintColor];
            self.presentedViewBarTintColor = nil;
        }
    }
}



#pragma mark - MailComposer Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self resetTintColors];
    [[controller presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - iMessageComposer Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self resetTintColors];
    [[controller presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
}

@end
