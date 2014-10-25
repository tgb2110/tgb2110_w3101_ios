//
//  AddNoteViewController.m
//  MamaBsNotes
//
//  Created by OB Troy on 10/22/14.
//  Copyright (c) 2014 OB Troy. All rights reserved.
//

#import "AddNoteViewController.h"
#import "DataStore.h"


@interface AddNoteViewController ()

@property (strong, nonatomic) DataStore *dataStore;

@property (weak, nonatomic) IBOutlet UIImageView *noteImageView;
@property (weak, nonatomic) IBOutlet UITextField *noteTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteBodyTextView;

- (IBAction)hideKeyboard:(UIControl *)sender;


@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeVariablesAndDelegates];
    [self setUpNavigationButtons];
    [self setUpDataFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)initializeVariablesAndDelegates {
    self.dataStore = [DataStore sharedDataStore];
    self.noteTitleTextField.delegate = self;
    self.noteBodyTextView.delegate = self;
}

- (void)setUpNavigationButtons {
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(emailNote:)];
    UIBarButtonItem *btnCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(pickImageSource:)];
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNoteAndExit:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnSave, btnShare, btnCamera, nil]];

}

- (void)setUpDataFields {
    if (self.selectedNote != NULL) {
        if (self.selectedNote.noteImage != nil) {
            self.noteImageView.image = self.selectedNote.noteImage;
        } else {
            self.noteImageView.backgroundColor = [UIColor blackColor];
        }
        self.noteTitleTextField.text = self.selectedNote.noteTitle;
        self.noteBodyTextView.text = self.selectedNote.noteBody;
    }
    else {
        self.noteImageView.backgroundColor = [UIColor blackColor];
        self.noteBodyTextView.text = @"Please enter the body of your note here.";
    }
}

-(void) saveNoteAndExit:(UIBarButtonItem *)sender  {
    
    [self saveNote];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MFMailCompose delegate methods

- (IBAction)emailNote:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        if (self.selectedNote == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message not Ready"
                                                            message:@"Please save note before emailing"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        NSString *messageSubject = self.selectedNote.noteTitle;
        NSString *messageBody = [NSString stringWithFormat:@"%@\n\n%@", self.selectedNote.noteBody, self.selectedNote.noteTime];
        
        NSData *imageData = UIImageJPEGRepresentation(self.noteImageView.image, 1);
        [mailViewController addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"NoteAttachment.jpg"];
        
        [mailViewController setSubject:messageSubject];
        [mailViewController setMessageBody:messageBody isHTML:NO];
        
        [self.navigationController presentViewController:mailViewController animated:YES completion:nil];
        
    }
    else {UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Device is unable to send email in its current state."
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:nil];
        [alert show];
        return;
    }
}

-(void)saveNote {
    [self adjustViewCenterWithOffset:0];
    NSString *newTitle = self.noteTitleTextField.text;
    NSString *newBody = self.noteBodyTextView.text;
    UIImage *newImage = self.noteImageView.image;
    
    if (self.selectedNote == nil) {
        [self.dataStore createNoteInDataStoreWithTitle:newTitle withBody:newBody withImage:newImage];
    }
    else {
        self.selectedNote.noteTitle = newTitle;
        self.selectedNote.noteBody = newBody;
        self.selectedNote.noteImage = newImage;
    }
    
    [self.dataStore saveNotes];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - UIImagePicker methods

- (IBAction)pickImageSource:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Source"
                                                    message:@"Select the Photo Source"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Photo Library", @"Take Photo", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        [self pickImageFromLibrary:YES];
    } else if (buttonIndex == 2) {
        [self pickImageFromLibrary:NO];
    }
}

- (void)pickImageFromLibrary: (BOOL)pickedFromLibrary {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    if(pickedFromLibrary == YES) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Device has no camera"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
            [noCameraAlert show];
            return;
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.noteImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.noteImageView.backgroundColor = [UIColor blackColor];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Text and Keyboard Management

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self adjustViewCenterWithOffset:0];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [textView selectAll:textView.text];
    [self adjustViewCenterWithOffset:-80];
}

- (IBAction)hideKeyboard:(UIControl *)sender {
    [[self view] endEditing:YES];
}

-(void)adjustViewCenterWithOffset:(NSInteger) offset {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,offset,320,480);
    [UIView commitAnimations];
}
@end
