//
//  PhotosWebServices.h
//  PhotoLibrary
//
//  Created by Mariam Issa on 4/4/18.
//  Copyright © 2018 Mariam Al Ethawy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DownloadType {
    InitialDownload = 0,
    ThumbnailDownload,
    FullImageDownload
    
} DownloadType;

@protocol PhotosServicesDelegate

@required
-(void)downloadCompletedWithData:(NSData *)responseData for:(DownloadType)type withIndex:(NSInteger)index;

@optional
-(void)downloadCompletedWithError:(NSError *) error;

@end

@interface PhotosWebServices : NSObject

-(instancetype)initWithDelegate:(id)delegatge;
-(void)getContentsFromUrl:(NSString *)urlString for:(DownloadType)type withIndex:(NSInteger)index;
@end
