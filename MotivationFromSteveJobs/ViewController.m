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
    
    [self.view addSubview:_textQuote];
    
}

// Function that vertically aligns the text view
-(void)adjustContentSize:(UITextView*)tv{
    CGFloat deadSpace = ([tv bounds].size.height - [tv contentSize].height);
    CGFloat inset = MAX(0, deadSpace/2.0);
    tv.contentInset = UIEdgeInsetsMake(inset, tv.contentInset.left, inset, tv.contentInset.right);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
