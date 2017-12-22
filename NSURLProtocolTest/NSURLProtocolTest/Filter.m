//
//  Filter.m
//  NSURLProtocolTest
//
//  Created by Avazu Holding on 2017/12/6.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//


#import "Filter.h"

static NSString*const sourUrl  = @"http://cdn.web.chelaile.net.cn/ch5/styles/main-1cb999d572.css";
static NSString*const localUrl = @"http://h5apps.scity.cn/hack/cdn.web.chelaile.net.cn/ch5/styles/main-1cb999d572.css";
static NSString*const FilteredCssKey = @"filteredCssKey";
@interface Filter()
@property (nonatomic, strong) NSMutableData   *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@end
@implementation Filter

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
	NSLog(@"request.URL.absoluteString = %@",request.URL.absoluteString);
	//只处理http和https请求
	NSString *scheme = [[request URL] scheme];
	if ( ([scheme caseInsensitiveCompare:@"http"]  == NSOrderedSame ||
		  [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ))
	{
		//看看是否已经处理过了，防止无限循环
		if ([NSURLProtocol propertyForKey:FilteredCssKey inRequest:request])
			return NO;
		
		return YES;
	}
	return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
	NSMutableURLRequest *mutableReqeust = [request mutableCopy];
	//截取重定向
	if ([request.URL.absoluteString isEqualToString:sourUrl])
	{
		NSURL* url1 = [NSURL URLWithString:localUrl];
		mutableReqeust = [NSMutableURLRequest requestWithURL:url1];
	}
	return mutableReqeust;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
	return [super requestIsCacheEquivalent:a toRequest:b];
}


- (void)startLoading
{
	NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
	//给我们处理过的请求设置一个标识符, 防止无限循环,
	[NSURLProtocol setProperty:@YES forKey:FilteredCssKey inRequest:mutableReqeust];
	
	BOOL enableDebug = NO;
	//这里最好加上缓存判断
	if (enableDebug)
	{
		NSString *str = @"写代码是一门艺术";
		NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
		NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
															MIMEType:@"text/plain"
											   expectedContentLength:data.length
													textEncodingName:nil];
		[self.client URLProtocol:self
			  didReceiveResponse:response
			  cacheStoragePolicy:NSURLCacheStorageNotAllowed];
		[self.client URLProtocol:self didLoadData:data];
		[self.client URLProtocolDidFinishLoading:self];
	}
	else
	{
		self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
	}
}

- (void)stopLoading
{
	if (self.connection != nil)
	{
		[self.connection cancel];
		self.connection = nil;
	}
}
#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.responseData = [[NSMutableData alloc] init];
	[self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
	[self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self.client URLProtocolDidFinishLoading:self];
}


@end
