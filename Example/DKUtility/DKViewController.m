//
//  DKViewController.m
//  DKUtility
//
//  Created by Dineshkumar on 16/08/13.
//  Copyright (c) 2013 dinesh. All rights reserved.
//

#define  PHOTO 0
#define  VIDEO 1
#define EMAIL 2
#define SMS 3
#define DATE 4
#define TIME 5
#define PICKER 6
#define SIGNATURE 7
#define COMMENT 8

#define VIDEOFILE @"videofile.mov"
#import "DKViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DKViewController ()

@end

@implementation DKViewController
@synthesize utilis;
@synthesize popOver;
@synthesize fileName;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    utilis=[[DKUtilityController alloc]init];
    utilis.delegate=self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonActions:(id)sender {
    
    switch ([sender tag]) {
            
        case PHOTO:
            [utilis openCameraForPhoto:YES orVideo:NO];
            break;
        case VIDEO:
            [utilis openCameraForPhoto:NO orVideo:YES];
            NSLog(@"video");
            break;
        case EMAIL:
            [utilis sendEmail:@"message" setRecipient:nil setSubject:@"test"];
            break;
        case SMS:
            [utilis sendSMS:@"message" setRecipient:nil];
            break;
        case DATE:
            [utilis openDatePicker];
            break;
        case TIME:
            [utilis openTimePicker];
            break;
        case PICKER:
            [utilis openCustomPickerListView];
            break;
        case COMMENT:
            [utilis openSignatureView];
            break;
        case SIGNATURE:
            [utilis openCommentBox];
            break;
        default:
            break;
    }
    
}
///////////////VIDEO/////////////////////////////////////
- (IBAction)playVideo:(id)sender {
    NSLog(@"Play Video");
    if([[NSFileManager defaultManager]fileExistsAtPath:self.fileName]){
        
        NSLog(@"FILE PATH AFTER SAVE %@",self.fileName);
        MPMoviePlayerViewController *controller=[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:self.fileName]];
        controller.contentSizeForViewInPopover=CGSizeMake(600, 600);
        UIPopoverController *tempPopOver=[[UIPopoverController alloc]initWithContentViewController:controller];
        self.popOver=tempPopOver;
        [self.popOver presentPopoverFromRect:self.videoButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        [tempPopOver release];
        [controller release];
    }
    
    
}
-(void)saveVideo:(NSData *)data{
    
    if([[NSFileManager defaultManager]fileExistsAtPath:self.fileName]){
        
        NSError *error;
        [[NSFileManager defaultManager]removeItemAtPath:self.fileName error:&error];
    }
    else{
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[array objectAtIndex:0];
        NSString *tempfileName=[path stringByAppendingPathComponent:VIDEOFILE];
        [data writeToFile:tempfileName atomically:YES];
        self.fileName=tempfileName;
        MPMoviePlayerController *controller=[[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:tempfileName]];
        UIImage *preview=[controller thumbnailImageAtTime:0.5 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [self.videoPreview setImage:preview forState:UIControlStateNormal];
        [controller release];
        [self.popOver dismissPopoverAnimated:YES];
    }
    
}

-(void)movieFinish:(NSNotification *)notification{
    
    [self.popOver dismissPopoverAnimated:YES];
    MPMoviePlayerViewController *moviePlayer=[notification object];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
}

//////////////////////////CAMERA//////////////////////////////////////////
-(void)openCamera:(UIImagePickerController *)imageController{
    
    UIPopoverController *tempPopover=[[UIPopoverController alloc]initWithContentViewController:imageController];
    self.popOver=tempPopover;
    [self.popOver presentPopoverFromRect:self.photoButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    [tempPopover release];
    
    
}
-(void)savePhoto:(NSData *)data{
    
    _imagePreview.image=[UIImage imageWithData:data];
    [self.popOver dismissPopoverAnimated:YES];
}

/////////////////////EMAIL////////////////////////////////////////////
-(void)openEmail:(MFMailComposeViewController *)mailComposer{
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}

-(void)dismissEmailView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/////////////////////SMS//////////////////////////////////////////////
-(void)openSMS:(MFMessageComposeViewController *)smsComposer{
    [self presentViewController:smsComposer animated:YES completion:nil];
}
-(void)dismissSMSView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//////////////////DATE PICKER////////////////////////////////////
-(void)setDatePicker:(UIViewController *)date_Picker{
    
    date_Picker.contentSizeForViewInPopover=CGSizeMake(320, 216);
    UIPopoverController *tempPopover=[[UIPopoverController alloc]initWithContentViewController:date_Picker];
    self.popOver=tempPopover;
    [self.popOver presentPopoverFromRect:self.dateButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [tempPopover release];
    
    
}
-(void)setDate:(NSString *)dateText{
    
    _dateLabel.text=dateText;
}

/////////////////////TIME PICKER//////////////////////
-(void)setTimePicker:(UIViewController *)time_Picker{
    
    
    time_Picker.contentSizeForViewInPopover=CGSizeMake(320, 216);
    UIPopoverController *tempPopover=[[UIPopoverController alloc]initWithContentViewController:time_Picker];
    self.popOver=tempPopover;
    [self.popOver presentPopoverFromRect:self.timeButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [tempPopover release];
    
}

-(void)setTime:(NSString *)timeText{
    
    _timeLabel.text=timeText;
}

//////////////////OPEN CUSTOM PICKER VIEW////////////////////////////
-(void)setCustomPicker:(UIViewController *)customPickerView{
    
    UIPopoverController *tempPopover=[[UIPopoverController alloc]initWithContentViewController:customPickerView];
    self.popOver=tempPopover;
    customPickerView.contentSizeForViewInPopover=CGSizeMake(320, 216);
    [self.popOver presentPopoverFromRect:self.pickerButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [tempPopover release];
}

-(void)selectedPicker:(NSString *)pickerName{
    
    _pickerListLabel.text=pickerName;
    
}


///SIGNATURE VIEW////
-(void)setSignatureController:(UIViewController *)controller{
    
    controller.contentSizeForViewInPopover=CGSizeMake(320, 216);
    UIPopoverController *tempPopover=[[UIPopoverController alloc]initWithContentViewController:controller];
    self.popOver=tempPopover;
    [self.popOver presentPopoverFromRect:self.signBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [tempPopover release];
    
    
}

-(void)setSignature:(UIView *)signView{
    signView.frame=_signView.bounds;
    [_signView addSubview:signView];
    [self.popOver dismissPopoverAnimated:YES];
    
}

//COMMENT BOX
-(void)setComments:(UIViewController *)controller{
    UIPopoverController *tempPopover=[[UIPopoverController alloc]initWithContentViewController:controller];
    tempPopover.popoverContentSize=CGSizeMake(320, 216);
    self.popOver=tempPopover;
    controller.contentSizeForViewInPopover=CGSizeMake(320, 216);
    [self.popOver presentPopoverFromRect:self.commentButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [tempPopover release];
    
}
-(void)setCommentDone:(NSString *)comments{
    
    self.commentsTxt.text=comments;
    [self.popOver dismissPopoverAnimated:YES];
    
}
-(void)setCommentCancel
{
    [self.popOver dismissPopoverAnimated:YES];
    
}
- (void)dealloc {
    [_imagePreview release];
    [_videoPreview release];
    [_photoButton release];
    [_videoButton release];
    [_videoPreview release];
    [_dateLabel release];
    [_timeLabel release];
    [_emailButton release];
    [_smsButton release];
    [_dateButton release];
    [_timeButton release];
    [_pickerListLabel release];
    [_pickerButton release];
    [_signView release];
    [_signBtn release];
    [_commentButton release];
    [_commentsTxt release];
    [super dealloc];
}


@end
