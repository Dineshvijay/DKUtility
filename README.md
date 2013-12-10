DKUtility
========

Single package which contains Camera, Video, Email, SMS, Date Picker, Time Picker, Custome Picker, Signature capture, Comment box for iPad. You can access these feature with few lines of code.

Download the DKUtility project

Do the following

1)Import the  MobileCoreServices framework

2)Import the following files into your project

    DKUtilityController.h

    DKUtilityController.m

    DKSignature.h

    DKSignature.m

3) add the delegate in your view controller.h

    <DKUtilityDelegate>

4) create a DKUtilityController object and set its delegate self

    DKUtilityController *dkUtility=[[DKUtilityController alloc]init];

    dkUtility.delegate=self;
    
  
For example to capture signature when clicking a button

* add the below line in your button action method

    [dkUtility openSignatureView];

*then add the following lines

    -(void)setSignatureController:(UIViewController *)controller{
   
    controller.contentSizeForViewInPopover=CGSizeMake(320, 216);
    UIPopoverController *tempPopover=[[UIPopoverController alloc]initWithContentViewController:controller]; 
    self.popOver=tempPopover;
    [self.popOver presentPopoverFromRect:self.signBtn.frame inView:self.view   
    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [tempPopover release];
    
    }

    -(void)setSignature:(UIView *)signView{
    
      signView.frame=_signView.bounds;
     [_signView addSubview:signView];
     [self.popOver dismissPopoverAnimated:YES];
     
     }

