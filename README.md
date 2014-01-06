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


#Property
              @property (nonatomic, copy) NSString *preferredLanguage;

Set language if you do not want to have system's default language.


#Method
              - (void)shareWithType:(BTSharingServiceType)serviceType
                            subject:(NSString *)subject
                               body:(NSString *)body
                                url:(NSURL *)url
                         recipients:(NSArray *)recipients
                   onViewController:(UIViewController *)viewController;

Trigger share widget.


## ARC Support

BTBadgeView fully supports ARC.
