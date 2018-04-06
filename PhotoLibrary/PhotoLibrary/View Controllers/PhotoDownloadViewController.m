//
//  PhotoDownloadViewController.m
//  PhotoLibrary
//
//  Created by Mariam Issa on 4/5/18.
//  Copyright © 2018 Mariam Al Ethawy. All rights reserved.
//

#import "PhotoDownloadViewController.h"
#import "PhotosData.h"

@interface PhotoDownloadViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@property (strong, nonatomic)  UIImageView *imageView;

@end

@implementation PhotoDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewImageForIndex:(NSInteger)index {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownloadCompletedSuccessfully:) name:kImageDownloadCompleted object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadCompletedWithError:) name:kDownloadCompletedWithError object:nil];
    
    NSData *imageData = [[PhotosData shared] imageForIndex:index];
    
    if (imageData) {
        [self setImage:imageData];
    }
}

-(void)imageDownloadCompletedSuccessfully:(NSNotification *)notification {
    NSDictionary *userInfo = notification.object;
    
     dispatch_async(dispatch_get_main_queue(), ^{
         [self setImage:userInfo[@"ImageData"]];
     });
}

-(void)setImage:(NSData *)imageData {    
    UIImage *image = [UIImage imageWithData:imageData];
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.scrollView.contentSize  = image.size;
    
    [self.scrollView addSubview:self.imageView];
    
    [self.imageView setUserInteractionEnabled:YES];
}

-(void)downloadCompletedWithError:(NSError *)error {
     dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Download Failed" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        
        [errorAlert addAction:okAction];
        
        [self presentViewController:errorAlert animated:YES completion:nil];
     });
}

- (IBAction)downloadButton:(id)sender {
    UIImage *image = self.imageView.image;
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.imageView setImage:nil];
    }];
}
@end
