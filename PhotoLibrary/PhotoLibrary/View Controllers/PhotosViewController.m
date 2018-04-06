//
//  PhotosViewController.m
//  PhotoLibrary
//
//  Created by Mariam Issa on 4/4/18.
//  Copyright © 2018 Mariam Al Ethawy. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoDownloadViewController.h"

@interface PhotosViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mainActivityIndicator;

@property (nonatomic) BOOL didErrorOccured;
@property (strong, nonatomic)PhotosData *dataLayer;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialSetup];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) initialSetup
{
    [self.mainActivityIndicator startAnimating];
    [self.mainActivityIndicator setHidesWhenStopped:YES];
    self.didErrorOccured = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLayerInitialSetupCompletedSuccessfully) name:kDataLayerInitialSetupCompleted object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thumbnailDownloadedSuccessfullyForIndex:) name:kThumbnailDownloadCompleted object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadCompletedWithError) name:kDownloadCompletedWithError object:nil];
    
    self.dataLayer = [PhotosData shared];
}

-(void)dataLayerInitialSetupCompletedSuccessfully
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.mainActivityIndicator stopAnimating];
    });
}

-(void)thumbnailDownloadedSuccessfullyForIndex:(NSNotification *)notification
{
     dispatch_async(dispatch_get_main_queue(), ^{
         NSDictionary *userInfo = notification.object;

         NSInteger index = [(NSNumber *)userInfo[@"Index"] integerValue];
         
         [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    });
}

-(void)downloadCompletedWithError {
    if (self.didErrorOccured) {
        return;
    }
     dispatch_async(dispatch_get_main_queue(), ^{
         
         [self.mainActivityIndicator stopAnimating];
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Download Failed" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        
        [errorAlert addAction:okAction];
        
        [self presentViewController:errorAlert animated:YES completion:nil];
     });
    
    self.didErrorOccured = YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataLayer numberOfRows];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    UIActivityIndicatorView *activityIndicator = [cell viewWithTag:2];
    [activityIndicator startAnimating];
    
    NSData *photoData = [self.dataLayer thumbnailForIndex:indexPath.row];
    
    if (photoData) {
        UIImageView *imageView = [cell viewWithTag:1];
        [imageView setImage:[UIImage imageWithData:photoData]];
        [activityIndicator stopAnimating];
        [activityIndicator setHidden:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PhotoDownloadViewController *photoDownloadViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoDownloadViewController"];
    
    [self presentViewController:photoDownloadViewController animated:YES completion:^{
        [photoDownloadViewController viewImageForIndex:indexPath.row];
    }];
}

@end
