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
@property(nonatomic, strong) NSArray *contentsData;
@property(nonatomic, strong) PhotosWebServices *photosServices;
@property(nonatomic, strong) NSMutableDictionary *thumbnails;
@property(nonatomic, strong) NSMutableDictionary *downloadedPhotos;
@end


@implementation PhotosData

-(instancetype) initWithDelegate:(id)delegatge{
    
    self = [super init];
    
    self.delegate = delegatge;
    self.contentsData = [[NSArray alloc] init];
    self.photosServices = [[PhotosWebServices alloc] initWithDelegate:self];
    self.thumbnails = [[NSMutableDictionary alloc] init];
    [self getPhotosData];
    
    return self;
}

-(void)getPhotosData {
    [self.photosServices getContentsFromUrl:@"https://jsonplaceholder.typicode.com/photos" for:InitialDownload withIndex:-1];
}

-(void)downloadCompletedWithData:(NSData *)responseData for:(DownloadType)type withIndex:(NSInteger)index {
    
    if (type == InitialDownload) {
        self.contentsData = [NSJSONSerialization
                           JSONObjectWithData:responseData
                           options:NSJSONReadingMutableLeaves
                           error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate dataLayerInitialSetupCompletedSuccessfully];
        });
    } else if(type == ThumbnailDownload) {
        [self.thumbnails setObject:responseData forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate thumbnailDownloadedSuccessfully:responseData forIndex:index];
        });
        
    } else if(type == FullImageDownload){
         [self.downloadedPhotos setObject:responseData forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate imageDownloadedSuccessfully:responseData forIndex:index];
        });
    }
}

- (void)downloadCompletedWithError:(NSError *)error {
    [self.delegate downloadCompletedWithError:error];
}

-(NSInteger)numberOfRows
{
    return (NSInteger)self.contentsData.count;
}

-(NSData *)thumbnailForIndex:(NSInteger)index
{
    NSData *photo = self.thumbnails[[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    
    if (photo) {
        return photo;
    }
    
    NSDictionary *photoData = self.contentsData[index];
    
    [self.photosServices getContentsFromUrl:photoData[@"thumbnailUrl"] for:ThumbnailDownload withIndex:index];
    
    return nil;
}

-(NSData *)imageForIndex:(NSInteger)index {
    
    NSData *image = self.downloadedPhotos[[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    
    if (image) {
        return image;
    }
    
    NSDictionary *photoData = self.contentsData[index];
    
    [self.photosServices getContentsFromUrl:photoData[@"url"] for:FullImageDownload withIndex:index];
    
    return nil;
}
@end
