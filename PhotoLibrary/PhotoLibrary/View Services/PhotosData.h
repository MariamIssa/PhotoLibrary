//
//  PhotosData.h
//  PhotoLibrary
//
//  Created by Mariam Issa on 4/4/18.
//  Copyright © 2018 Mariam Al Ethawy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotosWebServices.h"

@protocol PhotosDataDelegate

@required
-(void)dataLayerInitialSetupCompletedSuccessfully;
-(void)thumbnailDownloadedSuccessfully:(NSData *)image forIndex:(NSInteger)index;

@optional
-(void)imageDownloadedSuccessfully:(NSData *)image forIndex:(NSInteger)index;
-(void)dataLayerInitialSetupCompletedWithError:(NSError *)error;
-(void)downloadCompletedWithError:(NSError *)error;
@end

@interface PhotosData : NSObject<PhotosServicesDelegate>
-(instancetype)initWithDelegate:(id)delegatge;
-(NSInteger)numberOfRows;
-(NSData *)thumbnailForIndex:(NSInteger)index;
-(NSData *)imageForIndex:(NSInteger)index;
@end
