//
//  PhotosViewController.m
//  PhotoLibrary
//
//  Created by Mariam Issa on 4/4/18.
//  Copyright © 2018 Mariam Al Ethawy. All rights reserved.
//

#import "PhotosViewController.h"

@interface PhotosViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) PhotosData *dataLayer;

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
    self.dataLayer = [[PhotosData alloc] initWithDelegate:self];
}

-(void)dataLayerInitialSetupCompletedSuccessfully
{
    [self.collectionView reloadData];
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
    
    NSData *photoData= [self.dataLayer imageForIndexPath:indexPath.row];
    
    if (photoData) {
        UIImageView *imageView = [cell viewWithTag:1];
        [imageView setImage:[UIImage imageWithData:photoData]];
    }
    
    return cell;
}

@end
