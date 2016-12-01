//
//  ViewController.m
//  MotivationFromSteveJobs
//
//  Created by Tarpian Gabriel Lucian on 20/11/2016.
//  Copyright © 2016 Tarpian Gabriel Lucian. All rights reserved.
//

#import "ViewController.h"

// imported for screenshot
#import <QuartzCore/QuartzCore.h>

// imported for sharing on facebook
#import <Social/Social.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Get screen dimension
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;
    
    // creating the quote text label
    int labelPosX = width / 3;
    int labelPosY = height / 7;
    int labelWidth = width - labelPosX;
    int labelHeight = height - labelPosY *2.5;
    _textQuote = [[UITextView alloc]initWithFrame:CGRectMake(labelPosX, labelPosY,labelWidth,labelHeight)];
    
    // Create wallpaper
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    UIImage *image = [UIImage imageNamed:@"Wallpaper"];
    imageHolder.image = image;
    [self.view addSubview:imageHolder];
    
    // create the toolbar
    _toolbar = [[UIToolbar alloc] init];
    _toolbar.frame = CGRectMake(0, 0, width, 50);
    
    // create color for toolbar
    UIColor *colorToolbar = [UIColor colorWithRed:10.0f/255.0f
                    green:10.0f/255.0f
                     blue:10.0f/255.0f
                    alpha:1.0f];
    _toolbar.barTintColor = colorToolbar;
     
    
    // ************************************************************************ Settings button
    UIImage *imgSettings = [UIImage imageNamed:@"Settings.png"];
    
    UIButton *btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
   [btnSettings addTarget:self action:@selector(settingsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnSettings.bounds = CGRectMake( 0, 5, 40, 40 );
    [btnSettings setImage:imgSettings forState:UIControlStateNormal];
    [btnSettings setShowsTouchWhenHighlighted:TRUE];
    _barBtnSettings = [[UIBarButtonItem alloc] initWithCustomView:btnSettings];
    // ****************************************************************************************
    
    // ************************************************************************ Save button
    UIImage *imgSave = [UIImage imageNamed:@"SaveFile_Revert.png"];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnSave.bounds = CGRectMake( 100, 5, 40, 40 );
    [btnSave setImage:imgSave forState:UIControlStateNormal];
    [btnSave setShowsTouchWhenHighlighted:TRUE];
    _barBtnSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    // ****************************************************************************************
    
    // ************************************************************************ Facebook button
    UIImage *imgFacebook = [UIImage imageNamed:@"FacebookLogo_Revert.png"];
    
    UIButton *btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFacebook addTarget:self action:@selector(facebookButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnFacebook.bounds = CGRectMake( 200, 5, 40, 40 );
    [btnFacebook setImage:imgFacebook forState:UIControlStateNormal];
    [btnFacebook setShowsTouchWhenHighlighted:TRUE];
    _barBtnFacebook = [[UIBarButtonItem alloc] initWithCustomView:btnFacebook];
    // ****************************************************************************************
    
    // make visible items on the toolbar
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *items = [NSArray arrayWithObjects: _barBtnSettings, flexibleSpace,_barBtnSave, flexibleSpace,_barBtnFacebook, nil];
    _toolbar.items = items;
    
    // get current day of the month
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
    int day = (int) (components.day);
    
    // get quote of the day
    NSString *quote = [[DBManager getSharedInstance] findById:day];
    
    NSLog(@"Current day is %d\n",day);
    NSLog(@"Quote of the day is: %@\n",quote);
    
    // create a font
    UIFont *textViewfont = [UIFont fontWithName:@"Courier" size:20];
    
    // Assign quote to label
    _textQuote.text = quote;
    _textQuote.textColor = [UIColor whiteColor];
    _textQuote.backgroundColor = [UIColor blackColor];
    [_textQuote setUserInteractionEnabled:NO];
    _textQuote.font = textViewfont;
    _textQuote.textAlignment = NSTextAlignmentCenter;
    
    // Vertical center alignment
    [self adjustContentSize:_textQuote];
    
    // Get if this is the first time of running the app
    BOOL boNotFirstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTime"];
    
    if(boNotFirstTime == NO)
    {
        // create push notification when running app for first time
        [self createPushNotification:9 m:0];
        
        // store these values
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FirstTime"];
        [[NSUserDefaults standardUserDefaults]setInteger:9 forKey:@"Hour"];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"Minute"];
    }

    [self.view addSubview:_textQuote];
    [self.view addSubview:_toolbar];
}

// Function that vertically aligns the text view
-(void)adjustContentSize:(UITextView*)tv{
    CGFloat deadSpace = ([tv bounds].size.height - [tv contentSize].height);
    CGFloat inset = MAX(0, deadSpace/2.0);
    tv.contentInset = UIEdgeInsetsMake(inset, tv.contentInset.left, inset, tv.contentInset.right);
}

-(void) createPushNotification:(int)hour m:(int)minute
{
    // first of all, cancel all notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendarN = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // create the date from today at the desired hour
    NSDateComponents *componentsN = [calendarN components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [componentsN setHour:hour];
    [componentsN setMinute:minute];
    
    // Gives us today's date but at desired hour
    NSDate *nextNotificationDate = [calendarN dateFromComponents:componentsN];
    if ([nextNotificationDate timeIntervalSinceNow] < 0) {
        // If today's 9am already occurred, add 24hours to get to tomorrow's
        nextNotificationDate = [nextNotificationDate dateByAddingTimeInterval:60*60*24];
    }
    
    // create the notification
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = nextNotificationDate;
    notification.alertBody = @"New quote by Steve Jobs!";
    notification.soundName = UILocalNotificationDefaultSoundName;
    // Set a repeat interval to daily
    notification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


// settings button pressed function
-(IBAction)settingsButtonPressed:(id)sender
{
    NSLog(@"Settings button is pressed \n");
}

// save button pressed function
-(IBAction)saveButtonPressed:(id)sender
{
    NSLog(@"Facebook button is pressed \n");
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
    
    _toolbar.hidden = YES;
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _toolbar.hidden = NO;
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData)
    {
        //[imageData writeToFile:@"screenshot.png" atomically:YES];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        NSLog(@"Imaged saved succesfully \n");
        
        // send a confirmation alert
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Confirmation"
                                     message:@"Photo saved succesfully, please check you gallery"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"Great"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        NSLog(@"error while taking screenshot");
        
        // send a confirmation alert
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:@"Errow while saving the photo. Please try again"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// facebook button pressed function
-(IBAction)facebookButtonPressed:(id)sender
{
    NSLog(@"Facebook button is pressed\n");
    
    // get current quote screenshot
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
    
    _toolbar.hidden = YES;
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _toolbar.hidden = NO;

    // post on facebook
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookShare = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSString *shareText = @"Quote of the day by 'Motivation from Steve Jobs' App!";
        [facebookShare setInitialText:shareText];
        [facebookShare addImage:image];
        
        [facebookShare setCompletionHandler:^(SLComposeViewControllerResult result)
        {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        
        [self presentViewController:facebookShare animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// disable auto rotation
- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

// hide the status bar (the one that contains carrier, name of the app and time on the upper part)
-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}


@end
