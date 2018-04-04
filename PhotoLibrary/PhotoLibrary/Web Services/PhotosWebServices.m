//
//  PhotosWebServices.m
//  PhotoLibrary
//
//  Created by Mariam Issa on 4/4/18.
//  Copyright © 2018 Mariam Al Ethawy. All rights reserved.
//

#import "PhotosWebServices.h"



@interface PhotosWebServices()

@property(nonatomic, weak) id <PhotosServicesDelegate> delegate;
@end

@implementation PhotosWebServices

-(instancetype)initWithDelegate:(id)delegatge {
    self = [super init];
    
    self.delegate = delegatge;
    
    return self;
}


-(void)getContentsFromUrl:(NSString *)urlString forIndex:(NSInteger)index {
    NSURL *url = [NSURL URLWithString:urlString];
    
    __weak PhotosWebServices *weakSelf = self;
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakSelf.delegate downloadCompletedWithData:data forIndex:index];
       
    }];
    
    [dataTask resume];
}

@end
