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
@property(nonatomic, strong) NSURLSession *session;
@end

@implementation PhotosWebServices

-(instancetype)initWithDelegate:(id)delegatge {
    self = [super init];
    
    self.delegate = delegatge;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 30.0;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig];

    return self;
}


-(void)getContentsFromUrl:(NSString *)urlString for:(DownloadType)type withIndex:(NSInteger)index {
    NSURL *url = [NSURL URLWithString:urlString];
    
    __weak PhotosWebServices *weakSelf = self;
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [weakSelf.delegate downloadCompletedWithError:error];
        } else {
            [weakSelf.delegate downloadCompletedWithData:data for:type withIndex:index];
        }
    }];
    
    [dataTask resume];
}

@end
