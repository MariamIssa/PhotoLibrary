//
//  PhotosData.h
//  PhotoLibrary
//
//  Created by Mariam Issa on 4/4/18.
//  Copyright © 2018 Mariam Al Ethawy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotosWebServices.h"

static NSString * const kDataLayerInitialSetupCompleted = @"DataLayerInitialSetupCompleted";
static NSString * const kThumbnailDownloadCompleted = @"ThumbnailDownloadCompleted";
static NSString * const kImageDownloadCompleted = @"ImageDownloadCompleted";
static NSString * const kDownloadCompletedWithError = @"DownloadCompletedWithError";

@interface PhotosData : NSObject<PhotosServicesDelegate>

+ (id) shared;
-(instancetype)init;
-(NSInteger)numberOfRows;
-(NSData *)thumbnailForIndex:(NSInteger)index;
-(NSData *)imageForIndex:(NSInteger)index;
@end
