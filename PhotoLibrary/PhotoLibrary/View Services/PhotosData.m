//
//  PhotosData.m
//  PhotoLibrary
//
//  Created by Mariam Issa on 4/4/18.
//  Copyright © 2018 Mariam Al Ethawy. All rights reserved.
//

#import "PhotosData.h"

@interface PhotosData()
@property(nonatomic, weak) id <PhotosDataDelegate> delegate;
@property(nonatomic, strong) NSArray *photosData;
@property(nonatomic, strong) PhotosWebServices *photosServices;
@property(nonatomic, strong) NSMutableDictionary *photos;

@end


@implementation PhotosData

-(instancetype) initWithDelegate:(id)delegatge{
    
    self = [super init];
    
    self.delegate = delegatge;
    self.photosData = [[NSArray alloc] init];
    self.photosServices = [[PhotosWebServices alloc] initWithDelegate:self];
    self.photos = [[NSMutableDictionary alloc] init];
    [self getPhotosData];
    
    return self;
}

-(void)getPhotosData {
    [self.photosServices getContentsFromUrl:@"https://jsonplaceholder.typicode.com/photos" forIndex:-1];
}

-(void)downloadCompletedWithData:(NSData *)responseData forIndex:(NSInteger)index{
    
    if (index < 0) {
        self.photosData = [NSJSONSerialization
                           JSONObjectWithData:responseData
                           options:NSJSONReadingMutableLeaves
                           error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate dataLayerInitialSetupCompletedSuccessfully];
        });
    } else {
        [self.photos setObject:responseData forKey:[NSString stringWithFormat:@"%ld",(long)index]];
    }
}

-(NSInteger) numberOfRows
{
    return self.photosData.count;
}

-(NSData *) imageForIndexPath:(NSUInteger)index
{
    NSData *photo = self.photos[[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    
    if (photo) {
        return photo;
    }
    
    NSDictionary *photoData = self.photosData[index];
    
    [self.photosServices getContentsFromUrl:photoData[@"thumbnailUrl"] forIndex:index];
    
    return nil;
}

@end
