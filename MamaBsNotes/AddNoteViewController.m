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
    // Dispose of any resources that can be recreated.
}


- (void)initializeVariablesAndDelegates {
    self.dataStore = [DataStore sharedDataStore];
    self.noteTitleTextField.delegate = self;
    self.noteBodyTextView.delegate = self;
}

- (void)setUpNavigationButtons {
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(emailNote:)];
    UIBarButtonItem *btnCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(pickImageSource:)];
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnSave, btnShare, btnCamera, nil]];

}

- (void)setUpDataFields {
    if (self.selectedNote != NULL) {
        self.noteImageView.image = self.selectedNote.noteImage;
        self.noteTitleTextField.text = self.selectedNote.noteTitle;
        self.noteBodyTextView.text = self.selectedNote.noteBody;
    }
    else {
        self.noteImageView.image = [UIImage imageNamed:@"Note-Icon.jpg"];
        self.noteBodyTextView.text = @"Please enter the body of your note here.";
    }
}

-(void) saveNote:(UIBarButtonItem *)sender  {
    
    NSString *newTitle = self.noteTitleTextField.text;
    NSString *newBody = self.noteBodyTextView.text;
    UIImage *newImage = self.noteImageView.image;
    
    if (self.selectedNote == nil) {
        [self.dataStore createNoteWithTitle:newTitle withBody:newBody withImage:newImage];
    }
    else {
        self.selectedNote.noteTitle = self.noteTitleTextField.text;
        self.selectedNote.noteBody = self.noteBodyTextView.text;
        self.selectedNote.noteImage = self.noteImageView.image;
    }
    
    [self.dataStore saveNotes];
}

#pragma mark - MFMailCompose delegate methods

- (IBAction)emailNote:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        NSString *messageSubject;
        NSString *messageBody;
        
        NSData *imageData = UIImageJPEGRepresentation(self.noteImageView.image, 1);
        [mailViewController addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"NoteAttachment.jpg"];
        
        [mailViewController setSubject:messageSubject];
        [mailViewController setMessageBody:messageBody isHTML:NO];
        
        [self.navigationController presentViewController:mailViewController animated:YES completion:nil];
        
    }
    else {
        
        NSLog(@"Device is unable to send email in its current state.");
        
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
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
    
    if ([textView.text isEqualToString:@""]){
        textView.text = @"Please enter the body of your note here.";
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [textView selectAll:textView.text];
}


- (IBAction)hideKeyboard:(UIControl *)sender {
    [[self view] endEditing:YES];
}
@end
