//
//  DKUtilityController.h
//  DKUtility
//
//  Created by Dineshkumar on 16/08/13.
//  Copyright (c) 2013 dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DKSignature.h"


@protocol DKUtilityDelegate <NSObject>

@optional
//Camera & Video//
-(void)openCamera:(UIImagePickerController *)imageController;
-(void)savePhoto:(NSData *)data;
-(void)saveVideo:(NSData *)data;

//Email
-(void)openEmail:(MFMailComposeViewController *)mailComposer;
-(void)dismissEmailView;

//SMS
-(void)openSMS:(MFMessageComposeViewController *)smsComposer;
-(void)dismissSMSView;

//Date Picker
-(void)setDatePicker:(UIViewController *)date_Picker;
-(void)setDate:(NSString *)dateText;

//Time Picker
-(void)setTimePicker:(UIViewController *)time_Picker;
-(void)setTime:(NSString *)timeText;

//Custom Picker view
-(void)setCustomPicker:(UIViewController *)customPickerView;
-(void)selectedPicker:(NSString *)pickerName;

//Signature Capture
-(void)setSignatureController:(UIViewController *)controller;
-(void)setSignature:(UIView *)signView;

//COMMENT BOX
-(void)setComments:(UIViewController *)controller;
-(void)setCommentCancel;
-(void)setCommentDone:(NSString *)comments;
@end

@interface DKUtilityController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    
    id<DKUtilityDelegate>delegate;
}
@property (nonatomic,assign)id<DKUtilityDelegate>delegate;
@property (nonatomic,retain)UIImagePickerController *imagePickerController;
@property (nonatomic,retain)MFMailComposeViewController *mailComposer;
@property (nonatomic,retain)MFMessageComposeViewController *smsComposer;
@property (nonatomic,retain)UIDatePicker *datePicker;
@property (nonatomic,retain)UIDatePicker *timePicker;
@property (nonatomic,retain)UIPickerView *pickerView;
@property (nonatomic,retain)DKSignature *drawsignature;
@property (nonatomic,retain)UITextView *commentBox;


-(void)openCameraForPhoto:(BOOL)photo
                  orVideo:(BOOL)video;


-(void)sendEmail:(NSString *)message setRecipient:(NSArray *)recipient setSubject:(NSString *)subject;
-(void)sendSMS:(NSString *)message setRecipient:(NSString *)recipient;
-(void)openDatePicker;
-(void)openTimePicker;
-(void)openCustomPickerListView;
-(void)openSignatureView;
-(void)openCommentBox;


@end
