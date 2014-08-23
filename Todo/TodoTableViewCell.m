//
//  TodoTableViewCell.m
//  Todo
//
//  Created by Alexjander Bacalso on 8/19/14.
//  Copyright (c) 2014 Alexjander Bacalso. All rights reserved.
//

#import "TodoTableViewCell.h"

@implementation TodoTableViewCell {
    BOOL _isEditing;
    IBOutlet UIView *_labelView;
    IBOutlet UIButton *_btnCancel;
    NSString *_currentTextValue;
}

- (void)awakeFromNib
{
    // Initialization code
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(willEnterEditMode:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:recognizer];
    
    _isEditing = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willExitFromEditMode:)
                                                 name:@"cellWillEnterEditMode" object:nil];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)willEnterEditMode:(id)sender
{
    if (_isEditing) {
        return;
    }
    
    _currentTextValue = _titleField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellWillEnterEditMode" object:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(willCenterTitleField:)];
    [UIView setAnimationDidStopSelector:@selector(didEnterEditMode:)];
    
    [_labelView setFrame:CGRectMake(0, 0, _labelView.frame.size.width - 66, _labelView.frame.size.height)];
    [self.dateField setHidden:YES];
    
    [UIView commitAnimations];
}

- (void)willCenterTitleField:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [_labelView setCenter:CGPointMake(_labelView.center.x, _labelView.center.y)];
    [_labelView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.99 blue:0.88 alpha:1]];
    [self.dateField setHidden:YES];
    [self.titleField setFrame:CGRectMake(self.titleField.frame.origin.x, self.contentView.center.y - self.titleField.frame.size.height/2, self.titleField.bounds.size.width, self.titleField.bounds.size.height)];
    
    [UIView commitAnimations];
    
}
- (void)didEnterEditMode:(id)sender
{
    [self.titleField setEnabled:YES];
    [self.titleField becomeFirstResponder];
    _isEditing = true;
}
- (void)willExitFromEditMode:(id)sender
{
    
    if (!_isEditing) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didExitEditMode:)];
    
    [_labelView setFrame:CGRectMake(0, 0, _labelView.frame.size.width + 66, _labelView.frame.size.height)];
    [self.dateField setHidden:NO];
    
    [UIView commitAnimations];
}
- (void)didExitEditMode:(id)sender
{
    [self.titleField setEnabled:NO];
    [self.titleField resignFirstResponder];
    _isEditing = false;
}

#pragma Actions (event)
- (IBAction)saveChanges:(id)sender
{
    NSLog(@"ohhppss!! save edit entry!");
}
- (IBAction)textFieldHasBeganEditing:(id)sender
{
    if ([_titleField.text isEqualToString:_currentTextValue]) {
        [_btnCancel setHidden:NO];
        return;
    }
    
    if (!_btnCancel.isHidden) {
        [_btnCancel setHidden:YES];
    }
    
}

@end
