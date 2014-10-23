//
//  AddNoteViewController.h
//  MamaBsNotes
//
//  Created by OB Troy on 10/22/14.
//  Copyright (c) 2014 OB Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Note.h"

@interface AddNoteViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) Note *selectedNote;

@end
