//
//  DKViewController.h
//  DKUtility
//
//  Created by Dineshkumar on 16/08/13.
//  Copyright (c) 2013 dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKUtilityController.h"

@interface DKViewController : UIViewController
<DKUtilityDelegate>


@property (nonatomic,retain)DKUtilityController *utilis;
@property (nonatomic,retain)NSString *fileName;
@property (retain, nonatomic) IBOutlet UIButton *videoPreview;
@property (retain, nonatomic) IBOutlet UIImageView *imagePreview;
@property (retain,nonatomic) UIPopoverController *popOver;
@property (retain, nonatomic) IBOutlet UIButton *photoButton;
@property (retain, nonatomic) IBOutlet UIButton *videoButton;
@property (retain, nonatomic) IBOutlet UIButton *emailButton;
@property (retain, nonatomic) IBOutlet UIButton *smsButton;
@property (retain, nonatomic) IBOutlet UIButton *dateButton;
@property (retain, nonatomic) IBOutlet UIButton *timeButton;
@property (retain, nonatomic) IBOutlet UIButton *pickerButton;
@property (retain, nonatomic) IBOutlet UIButton *commentButton;
@property (retain, nonatomic) IBOutlet UIButton *signBtn;

@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *pickerListLabel;
@property (retain, nonatomic) IBOutlet UITextView *commentsTxt;

@property (retain, nonatomic) IBOutlet UIView *signView;


- (IBAction)buttonActions:(id)sender;

@end
