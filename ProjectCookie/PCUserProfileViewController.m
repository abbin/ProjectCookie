//
//  PCUserProfileViewController.m
//  ProjectCookie
//
//  Created by Abbin Varghese on 17/10/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "PCUserProfileViewController.h"
#import "PCManager.h"

@interface PCUserProfileViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic)  NSURL *imageUrl;
@property (nonatomic, strong) void(^completionHandler)(void);

@end

@implementation PCUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatarImageView.layer.cornerRadius = 25;
    self.avatarImageView.layer.masksToBounds = YES;
    self.nameTextField.inputAccessoryView = self.toolBar;
    self.toolBar.tintColor = [PCManager mainColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.nameTextField becomeFirstResponder];
}

- (IBAction)doneButtonClicked:(id)sender {
    NSString* result = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (result.length>0) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setURL:self.imageUrl forKey:kPCUserImage];
        [userDefault setObject:result forKey:kPCUserName];
        [userDefault synchronize];
        [PCManager updateUser];
        _completionHandler();
    }
}

-(void)completionHandler:(void(^)(void))handler{
    _completionHandler = handler;
}

- (IBAction)didTapOnImage:(id)sender {
    [self.nameTextField resignFirstResponder];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.nameTextField becomeFirstResponder];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = (UIImage*)[info valueForKey:UIImagePickerControllerOriginalImage];
    [self.avatarImageView setImage:image];
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSString *imageName = imageURL.path.lastPathComponent;
    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSString *localPath = [documentDirectory stringByAppendingPathComponent:imageName];
    
    self.imageUrl = [NSURL fileURLWithPath:localPath];
    
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:localPath atomically:YES];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
