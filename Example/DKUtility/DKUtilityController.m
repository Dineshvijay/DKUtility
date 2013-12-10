//
//  DKUtilityController.m
//  DKUtility
//
//  Created by Dineshkumar on 16/08/13.
//  Copyright (c) 2013 dinesh. All rights reserved.
//

#import "DKUtilityController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface DKUtilityController ()
{
    
    BOOL isVideo;
    BOOL isPhoto;
}
@end

@implementation DKUtilityController

@synthesize delegate;
@synthesize imagePickerController;
@synthesize mailComposer;
@synthesize smsComposer;
@synthesize datePicker;
@synthesize timePicker;
@synthesize pickerView;
@synthesize drawsignature;
@synthesize commentBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.frame=CGRectMake(0, 0, 320, 216);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openCameraForPhoto:(BOOL)photo
                  orVideo:(BOOL)video
{
    isVideo=video;
    isPhoto=photo;
    UIImagePickerController *tempImagePicker=[[UIImagePickerController alloc]init];
    tempImagePicker.delegate=self;
    tempImagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    
    if(photo && !video){
        tempImagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        NSArray *mediaTypes=[NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        tempImagePicker.mediaTypes=mediaTypes;
        self.imagePickerController=tempImagePicker;
        [self.delegate openCamera:self.imagePickerController];
        [tempImagePicker release];
    }
    else if(!photo &video){
        // tempImagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
        NSArray *mediaTypes=[NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
        tempImagePicker.mediaTypes=mediaTypes;
        self.imagePickerController=tempImagePicker;
        [self.delegate openCamera:self.imagePickerController];
        [tempImagePicker release];
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if(isPhoto && !isVideo){
        NSURL *mediaUrl;
        UIImage *capturedImage;
        mediaUrl=[info objectForKey:UIImagePickerControllerMediaURL];
        if(mediaUrl==NULL){
            capturedImage=[info objectForKey:UIImagePickerControllerEditedImage];
            if(capturedImage==NULL){
                capturedImage=[info objectForKey:UIImagePickerControllerOriginalImage];
                NSData *imageData=UIImagePNGRepresentation(capturedImage);
                [self.delegate savePhoto:imageData];
            }
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if (!isPhoto &&isVideo){
        
        NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
        
        if(CFStringCompare((CFStringRef)mediaType, kUTTypeMovie, 0)==kCFCompareEqualTo){
            NSURL *mediaURL=[info objectForKey:UIImagePickerControllerMediaURL];
            NSData *mediaData=[NSData dataWithContentsOfURL:mediaURL];
            [self.delegate saveVideo:mediaData];
            
        }
    }
    
}

-(void)sendEmail:(NSString *)message setRecipient:(NSArray *)recipient setSubject:(NSString *)subject{
    
    MFMailComposeViewController *tempMailComposer=[[MFMailComposeViewController alloc]init];
    tempMailComposer.mailComposeDelegate=self;
    [tempMailComposer setSubject:subject];
    [tempMailComposer setMessageBody:message isHTML:NO];
    //[mailComposer setToRecipients:recipient];
    tempMailComposer.modalPresentationStyle=UIModalPresentationFormSheet;
    self.mailComposer=tempMailComposer;
    [self.delegate openEmail:self.mailComposer];
    [tempMailComposer release];
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result) {
        case MFMailComposeResultCancelled:
            [self.delegate dismissEmailView];
            break;
        case MFMailComposeResultFailed:
            [self.delegate dismissEmailView];
            break;
        case MFMailComposeResultSaved:
            [self.delegate dismissEmailView];
            break;
        case MFMailComposeResultSent:
            [self.delegate dismissEmailView];
        default:
            break;
    }
    
}


-(void)sendSMS:(NSString *)message setRecipient:(NSString *)recipient{
    
    @try{
    MFMessageComposeViewController *tempSMSComposer=[[MFMessageComposeViewController alloc]init];
    tempSMSComposer.messageComposeDelegate=self;
    [tempSMSComposer setBody:message];
    tempSMSComposer.modalPresentationStyle=UIModalPresentationFormSheet;
    self.smsComposer=tempSMSComposer;
    [self.delegate openSMS:self.smsComposer];
    [tempSMSComposer release];
    }
    @catch (NSException *exception) {
        
    }
    
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            [self.delegate dismissSMSView];
            break;
        case MessageComposeResultFailed:
            [self.delegate dismissSMSView];
            break;
        case MessageComposeResultSent:
            [self.delegate dismissSMSView];
            break;
        default:
            break;
    }
}
-(void)openDatePicker{
    
    UIDatePicker *tempDatePicker=[[UIDatePicker alloc]init];
    tempDatePicker.datePickerMode=UIDatePickerModeDate;
    self.datePicker=tempDatePicker;
    [self.datePicker addTarget:self action:@selector(dateSelect:) forControlEvents:UIControlEventValueChanged];
    [tempDatePicker release];
    [self.view addSubview:self.datePicker];
    [self.delegate setDatePicker:self];
}
-(void)dateSelect:(id)sender{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    NSString *dateStr=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.datePicker.date]];
    [self.delegate setDate:dateStr];
    [dateFormatter release];
}

-(void)openTimePicker{
    
    UIDatePicker *tempTimePicker=[[UIDatePicker alloc]init];
    tempTimePicker.datePickerMode=UIDatePickerModeTime;
    self.timePicker=tempTimePicker;
    [self.timePicker addTarget:self action:@selector(timeSelect:) forControlEvents:UIControlEventValueChanged];
    [tempTimePicker release];
    [self.view addSubview:self.timePicker];
    [self.delegate setTimePicker:self];
    
}

-(void)timeSelect:(id)sender{
    
    NSDateFormatter *timeFormmater=[[NSDateFormatter alloc]init];
    [timeFormmater setDateFormat:@"HH:mm"];
    NSString *timeStr=[NSString stringWithFormat:@"%@",[timeFormmater stringFromDate:[timePicker date]]];
    [self.delegate setTime:timeStr];
    [timeFormmater release];
}

-(void)openCustomPickerListView{
    
    UIPickerView *picker=[[UIPickerView alloc]init];
    picker.showsSelectionIndicator=YES;
    picker.delegate=self;
    self.pickerView=picker;
    self.view.frame=CGRectMake(0, 0, 320, 216);
    [self.view addSubview:self.pickerView];
    [self.delegate setCustomPicker:self];
    [picker release];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 5;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
        return @"Property";
        return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
  
        
        [self.delegate selectedPicker:@"Property Selected"];
}

-(void)openSignatureView{
    
   DKSignature *signature=[[DKSignature alloc]initWithFrame:CGRectMake(0, 44, 320, 216)];
    self.drawsignature=signature;
    
    UINavigationBar *navigationBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    
    UIBarButtonItem *clearBtn=[[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearSign:)];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneSign:)];
    UINavigationItem *navigationItem=[[UINavigationItem alloc]init];
    navigationItem.leftBarButtonItem=clearBtn;
    navigationItem.rightBarButtonItem=doneBtn;
    navigationBar.items=[NSArray arrayWithObject:navigationItem];
    [self.view addSubview:navigationBar];
    [self.view addSubview:self.drawsignature];
    
    [signature release];
    [navigationBar release];
    [navigationItem release];
    
    [self.delegate setSignatureController:self];
    
}

-(void)clearSign:(id)sender{
    
    [self.drawsignature removeFromSuperview];
    DKSignature *signature=[[DKSignature alloc]initWithFrame:CGRectMake(0, 44, 320, 216)];
    self.drawsignature=signature;
    [self.view addSubview:self.drawsignature];
    [signature release];
    
}
-(void)doneSign:(id)sender{
    [self.delegate setSignature:self.drawsignature];
}

-(void)openCommentBox{
    
    UITextView *tempTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 44, 320, 216)];
    self.commentBox=tempTextView;
    
    UINavigationBar *navigationBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *clearBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CancelCommentBox:)];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneCommentBox:)];
    UINavigationItem *navigationItem=[[UINavigationItem alloc]init];
    navigationItem.leftBarButtonItem=clearBtn;
    navigationItem.rightBarButtonItem=doneBtn;
    navigationBar.items=[NSArray arrayWithObject:navigationItem];
    [self.view addSubview:navigationBar];
    [self.view addSubview:self.commentBox];
    [self.delegate setComments:self];
    [navigationBar release];
    [navigationItem release];
    [tempTextView release];
    
    
}
-(void)CancelCommentBox:(id)sender{
    
    [self.delegate setCommentCancel];
    
}
-(void)doneCommentBox:(id)sender{
    
    [self.delegate setCommentDone:commentBox.text];
}

-(void)dealloc{
    
    [super dealloc];
    [imagePickerController release];
    [mailComposer release];
    [smsComposer release];
    [datePicker release];
    [timePicker release];
    [pickerView release];
}

@end
