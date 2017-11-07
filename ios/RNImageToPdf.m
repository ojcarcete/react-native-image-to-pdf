//
//  RNImageToPdf.m
//  pdfConverter
//
//  Created by Philipp Müller on 22/09/2017.
//  Copyright © 2017 Anyline. All rights reserved.
//

#import "RNImageToPdf.h"

@interface RNImageToPdf ()
@property (strong, nonatomic) NSMutableArray *imageViewArray;
@property (strong, nonatomic) NSMutableDictionary *resultDict;
@property (nonatomic) BOOL forceSinglePage;

@end

@implementation RNImageToPdf {
    RCTPromiseResolveBlock _resolveBlock;
    RCTPromiseRejectBlock _rejectBlock;
}

// This RCT (React) "macro" exposes the current module to JavaScript
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(createPDFbyImages:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    _resolveBlock = resolve;
    _rejectBlock = reject;
    
    self.resultDict = [[NSMutableDictionary alloc] init];
    self.imageViewArray = [[NSMutableArray alloc] init];
    self.forceSinglePage = [[options objectForKey:@"forceSinglePage"] boolValue];
    
    NSString *filename = [options objectForKey:@"name"];
    
    NSArray *imagePathArray = [options objectForKey:@"imagePaths"];
    
    for (NSString *imagePath in imagePathArray) {
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
        [self.imageViewArray addObject:imageView];
    }
    
    [self createPDFWithFilename:filename];
    NSLog(@"PDF was created successfully");
}

- (void)createPDFWithFilename:(NSString *)filename {
    
    UIImageView *firstImageView = self.imageViewArray.firstObject;
    //Start with pdf:
    NSMutableData *pdfData = [NSMutableData data];
    //Start pdf context:
    UIGraphicsBeginPDFContextToData(pdfData, firstImageView.bounds, nil);
    
    if (self.forceSinglePage) {
        //Calculate dimensions for vertically merged images:
        CGFloat totalWidth = 0;
        CGFloat totalHeight = 0;
        
        for (UIImageView *iv in self.imageViewArray) {
            totalWidth = MAX(iv.bounds.size.width, totalWidth);
            totalHeight += iv.bounds.size.height;
        }
        
        //Generate single page:
        CGRect pageFrame = CGRectMake(0, 0, totalWidth, totalHeight);
        CGContextRef pdfContext = UIGraphicsGetCurrentContext();
        UIGraphicsBeginPDFPageWithInfo(pageFrame, nil);
        
        for (UIImageView *iv in self.imageViewArray) {
            //Render image layer to context:
            [iv.layer renderInContext:pdfContext];
            //Translate context coordinates vertically:
            CGFloat fixWhiteOffsetY = 1.0f;
            CGContextTranslateCTM(pdfContext, 0, iv.bounds.size.height - fixWhiteOffsetY);
        }
    }
    else {
        CGContextRef pdfContext;
        for (UIImageView *iv in self.imageViewArray) {
            //Start new page with image bounds:
            UIGraphicsBeginPDFPageWithInfo(iv.bounds, nil);
            pdfContext = UIGraphicsGetCurrentContext();
            //Render image layer to context:
            [iv.layer renderInContext:pdfContext];
        }
    }
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", filename]];
    
    NSLog(@"filePath: %@",documentDirectoryFilename);
    if (!pdfData) {
        _rejectBlock(RCTErrorUnspecified, nil, RCTErrorWithMessage(@"PDF couldn't be saved."));
        return;
    }
    
    //Write pdf file
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    
    //Add filepath to resultDict. This will be send back to RN
    [self.resultDict setObject:documentDirectoryFilename forKey:@"filePath"];
    
    _resolveBlock(self.resultDict);
}

@end

