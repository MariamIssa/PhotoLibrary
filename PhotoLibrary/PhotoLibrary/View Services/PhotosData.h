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

@optional
-(void)dataLayerInitialSetupCompletedWithError:(NSError*)error;


@end

@interface PhotosData : NSObject<PhotosServicesDelegate>
-(instancetype) initWithDelegate:(id)delegatge;
-(NSInteger) numberOfRows;
-(NSData *) imageForIndexPath:(NSUInteger)index;
@end
