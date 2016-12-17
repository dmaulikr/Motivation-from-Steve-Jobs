//
//  ViewController.h
//  MotivationFromSteveJobs
//
//  Created by Tarpian Gabriel Lucian on 20/11/2016.
//  Copyright © 2016 Tarpian Gabriel Lucian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
///    Notification become independent from UIKit
@import UserNotifications;

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView  *textQuote;
@property (nonatomic, retain)  IBOutlet UIBarButtonItem   *barBtnSettings;
@property (nonatomic, retain)  IBOutlet UIBarButtonItem   *barBtnSave;
@property (nonatomic, retain)  IBOutlet UIBarButtonItem   *barBtnFacebook;
@property (nonatomic, retain)  IBOutlet UIToolbar         *toolbar;
@property (nonatomic, retain) IBOutlet UIDatePicker *dateNotification;
@property (nonatomic, retain)  IBOutlet UIToolbar         *toolbarNotification;
@property (nonatomic, retain) IBOutlet UITextView  *textAuthor;
@end

