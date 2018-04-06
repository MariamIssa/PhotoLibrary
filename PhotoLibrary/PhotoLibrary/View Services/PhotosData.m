//
//  PhotosData.m
//  PhotoLibrary
//
//  Created by Mariam Issa on 4/4/18.
//  Copyright © 2018 Mariam Al Ethawy. All rights reserved.
//

#import "PhotosData.h"

@interface PhotosData()
@property(nonatomic, strong) NSArray *contentsData;
@property(nonatomic, strong) PhotosWebServices *photosServices;
@property(nonatomic, strong) NSMutableDictionary *thumbnails;
@property(nonatomic, strong) NSMutableDictionary *downloadedPhotos;
@end


@implementation PhotosData

+ (id) shared {
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(instancetype) init{
    
    if(self = [super init]){
        self.contentsData = [[NSArray alloc] init];
        self.photosServices = [[PhotosWebServices alloc] initWithDelegate:self];
        self.thumbnails = [[NSMutableDictionary alloc] init];
        [self getPhotosData];
    }
    
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
        
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:self.contentsData forKey:@"ContentsData"];

        [[NSNotificationCenter defaultCenter] postNotificationName:kDataLayerInitialSetupCompleted object:userInfo];
        
    } else if(type == ThumbnailDownload) {
        [self.thumbnails setObject:responseData forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:responseData forKey:@"ImageData"];
        
       [[NSNotificationCenter defaultCenter] postNotificationName:kThumbnailDownloadCompleted object:userInfo];
        
    } else if(type == FullImageDownload){
         [self.downloadedPhotos setObject:responseData forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:responseData forKey:@"ImageData"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kImageDownloadCompleted object:userInfo];
    }
}

- (void)downloadCompletedWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadCompletedWithError object:nil];
    
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
