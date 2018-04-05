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

@property (strong, nonatomic) PhotosData *dataLayer;
@property (strong, nonatomic)PhotoDownloadViewController *photoDownloadViewController;
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

-(void) initialSetup
{
    [self.mainActivityIndicator startAnimating];
    self.dataLayer = [[PhotosData alloc] initWithDelegate:self];
}

-(void)dataLayerInitialSetupCompletedSuccessfully
{
    [self.collectionView reloadData];
    [self.mainActivityIndicator stopAnimating];
    [self.mainActivityIndicator setHidesWhenStopped:YES];
}

-(void)thumbnailDownloadedSuccessfully:(NSData *)image forIndex:(NSInteger)index
{
   UICollectionViewCell *cell = [self.collectionView.dataSource collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    if (cell && image) {
        UIActivityIndicatorView *activityIndicator = [cell viewWithTag:2];
        [activityIndicator stopAnimating];
        [activityIndicator setHidden:YES];

        UIImageView *imageView = [cell viewWithTag:1];
        [imageView setImage:[UIImage imageWithData:image]];
    }
}

-(void)imageDownloadedSuccessfully:(NSData *)image forIndex:(NSInteger)index
{
    [self.photoDownloadViewController setImage:image];
}

-(void)downloadCompletedWithError:(NSError *)error {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Download Failed" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    
    [errorAlert addAction:okAction];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
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
    if (self.photoDownloadViewController) {
        [self presentViewController:self.photoDownloadViewController animated:YES completion:^{
            NSData *photoData = [self.dataLayer imageForIndex:indexPath.row];
            
            if (photoData) {
                [self.photoDownloadViewController setImage:photoData];
            } else {
                [self.dataLayer imageForIndex:indexPath.row];
            }
        }];
    } else {
        self.photoDownloadViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoDownloadViewController"];
        
        [self presentViewController:self.photoDownloadViewController animated:YES completion:^{
            NSData *photoData = [self.dataLayer imageForIndex:indexPath.row];
            
            if (photoData) {
                [self.photoDownloadViewController setImage:photoData];
            } else {
                [self.dataLayer imageForIndex:indexPath.row];
            }
        }];
    }
}

@end
