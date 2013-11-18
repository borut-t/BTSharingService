//
//  ViewController.m
//  BTSharingServiceExample
//
//  Created by Borut Tomažin on 8/30/13.
//  Copyright (c) 2013 Borut Tomažin. All rights reserved.
//

#import "ViewController.h"
#import "BTSharingService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender
{
    //Set language service uses instead system language
    //[[BTSharingService sharedInstance] setPreferredLanguage:@"sl"];
    
    BTSharingServiceType sharingType = 0;
    switch ([(UIButton *)sender tag]) {
        case 1: sharingType = BTSharingServiceTypeFacebook; break;
        case 2: sharingType = BTSharingServiceTypeTwitter; break;
        case 3: sharingType = BTSharingServiceTypeMail; break;
        case 4: sharingType = BTSharingServiceTypeiMessage; break;
        case 5: sharingType = BTSharingServiceTypeSafari; break;
    }
    
    if (sharingType) {
    [[BTSharingService sharedInstance] shareWithType:sharingType
                                             subject:@"Example"
                                                body:@"Example body text."
                                                 url:[NSURL URLWithString:@"http://www.apple.com"] recipients:nil
                                    onViewController:self];
    }
}

@end
