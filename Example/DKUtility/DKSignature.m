//
//  DKSignature.m
//  DKUtility
//
//  Created by Dineshkumar on 16/08/13.
//  Copyright (c) 2013 dinesh. All rights reserved.
//

#import "DKSignature.h"

@implementation DKSignature

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];
        path=[[UIBezierPath alloc]init];
        path.lineWidth=8.0;
        path.lineCapStyle=kCGLineCapRound;
        path.miterLimit=0;
        brush=[UIColor blackColor];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [brush setStroke];
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *myTouch=[[touches allObjects]objectAtIndex:0];
    [path moveToPoint:[myTouch locationInView:self]];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *myTouch=[[touches allObjects]objectAtIndex:0];
    [path addLineToPoint:[myTouch locationInView:self]];
    [self setNeedsDisplay];
    
}



@end
