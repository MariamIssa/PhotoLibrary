//
//  PhotoDownloadViewController.m
//  PhotoLibrary
//
//  Created by Mariam Issa on 4/5/18.
//  Copyright © 2018 Mariam Al Ethawy. All rights reserved.
//

#import "PhotoDownloadViewController.h"

@interface PhotoDownloadViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic)  UIImageView *imageView;

@end

@implementation PhotoDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.activityIndicator setHidesWhenStopped:NO];
    [self.activityIndicator startAnimating];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImage:(NSData *)imageData {
    
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.scrollView.contentSize  = image.size;

    [self.scrollView addSubview:self.imageView];

    [self.imageView setUserInteractionEnabled:YES];
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
