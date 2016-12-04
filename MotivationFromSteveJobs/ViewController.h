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

@property (nonatomic,retain) IBOutlet UITextView  *textQuote;
@property (nonatomic)  IBOutlet UIBarButtonItem   *barBtnSettings;
@property (nonatomic)  IBOutlet UIBarButtonItem   *barBtnSave;
@property (nonatomic)  IBOutlet UIBarButtonItem   *barBtnFacebook;
@property (nonatomic)  IBOutlet UIToolbar         *toolbar;
@property (nonatomic,strong) IBOutlet UIDatePicker *dateNotification;
@property (nonatomic)  IBOutlet UIToolbar         *toolbarNotification;
@end

