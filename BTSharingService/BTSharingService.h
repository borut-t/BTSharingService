//
//  BTSharingService.h
//
//  Version 1.3
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BTSharingServiceType) {
    BTSharingServiceTypeFacebook = 1,
    BTSharingServiceTypeTwitter,
    BTSharingServiceTypeMail,
    BTSharingServiceTypeiMessage,
    BTSharingServiceTypeSafari
};

FOUNDATION_EXPORT NSString *const BTSharingServiceLanguageEnglish;
FOUNDATION_EXPORT NSString *const BTSharingServiceLanguageSlovenian;

@interface BTSharingService : NSObject

/**
 Set default language instead of system one. If empty, system language is used.
 */
@property (nonatomic, copy) NSString *preferredLanguage;

/**
 Set to YES if navigation bar colors should be reset to default values (ignoring app colors).
 */
@property (nonatomic, assign) BOOL shouldResetBarTintColor;

/**
 BTSharingService singleton method
 */
+ (id)sharedInstance;

/**
 Composes a sharing view for selected serviceType.
 
 @param serviceType A BTSharingServiceType to choose from. Use constant BTSharingServiceType.
 @param subject A subject string to set.
 @param body A budy string to set.
 @param url A NSURL object for link.
 @param recipients (Optional)Recipients list to send to.
 @param viewController A target view controller to create sharing view on.
 */
- (void)shareWithType:(BTSharingServiceType)serviceType
              subject:(NSString *)subject
                 body:(NSString *)body
                  url:(NSURL *)url
           recipients:(NSArray *)recipients
     onViewController:(UIViewController *)viewController;

@end
