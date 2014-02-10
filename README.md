BTSharingService
========

Nice and simple sharing service solution.


#Supported OS
iOS 5+


#Installation
To use the BTSharingService in an app, just drag the BTSharingService class files and BTSharingService.bundle into your project
or
Install it using cocoapods 
	pod 'BTSharingService'


#Properties
	@property (nonatomic, copy) NSString *preferredLanguage;

Set language if you do not want to have system's default language.

	@property (nonatomic, assign) BOOL shouldResetBarTintColor;

Set to YES if navigation bar colors should be reset to default values (ignoring app colors).


#Method
	- (void)shareWithType:(BTSharingServiceType)serviceType
              subject:(NSString *)subject
                 body:(NSString *)body
                  url:(NSURL *)url
           recipients:(NSArray *)recipients
     onViewController:(UIViewController *)viewController;

Composes a sharing view for selected serviceType.


## ARC Support

BTBadgeView fully supports ARC.
