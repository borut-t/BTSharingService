BTSharingService
========

Nice and simple sharing service solution.


Installation
--------------

To use the BTSharingService in an app, just drag the BTSharingService class files and BTSharingService.bundle into your project
or
Install it using cocoapods pod 'BTSharingService'


Methods
--------------

The BTProgressView has the following properties:

              - (void)setPreferredLanguage:(NSString *)language;

Set language if you do not want to have system's default language.

              - (void)shareWithType:(BTSharingServiceType)serviceType
                            subject:(NSString *)subject
                               body:(NSString *)body
                                url:(NSURL *)url
                         recipients:(NSArray *)recipients
                   onViewController:(UIViewController *)viewController;

Trigger share widget.


## ARC Support

BTBadgeView fully supports ARC.
