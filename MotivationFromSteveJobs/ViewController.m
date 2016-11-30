//
//  ViewController.m
//  MotivationFromSteveJobs
//
//  Created by Tarpian Gabriel Lucian on 20/11/2016.
//  Copyright © 2016 Tarpian Gabriel Lucian. All rights reserved.
//

#import "ViewController.h"

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

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}


@end
