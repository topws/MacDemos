//
//  AppDelegate.m
//  Demo
//
//  Created by ycb on 2017/10/28.
//  Copyright © 2017年 ycb. All rights reserved.
//

#import "AppDelegate.h"

#define CHMOD                                       "/bin/chmod"
#define CHOWN                                       "/usr/sbin/chown"
#define MOVE                                        "/bin/mv"

#define EXECPATH                                    @"/Contents/MacOS/Demo"
#define TEMPPATH                                    @"/Contents/Resources/"
#define PLISTTARGETPATH                             @"/Library/LaunchDaemons/"
#define PLISTNAME                                   @"com.apple.Demo.plist"

@interface AppDelegate ()
{
    AuthorizationRef _m_authorization;
    NSString *_bundlePath;
}
@end

FILE *myFile = NULL;
AuthorizationFlags myFlags = kAuthorizationFlagDefaults;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *homePath = NSHomeDirectory();
    NSString *srcPlistPath;
    NSString *plistPath = [PLISTTARGETPATH stringByAppendingPathComponent:PLISTNAME];
    // 程序通过launchctl自启 以root权限启动 根目录为/var/root
    // 程序正常启动 以用户权限启动 根目录为 /User/.../
    // 以此判断程序是否自动启动，自启动后则不再执行用户授权操作
    // 以root权限启动后 程序本身为root 可以用 NSFileManager 操作除受Rootless(SIP)限制外任何文件夹
    // 需关闭沙盒
    
    if (![homePath isEqualToString:@"/var/root"])
    {
        if(![self getAuthority])
        {
            NSLog(@"授权失败");
            return;
        }
        
        if(![self writePlistToTargetPath:&srcPlistPath])
        {
            NSLog(@"写入临时文件失败");
            return [self freeAuthority];
        }
        if(![self movePlistWithSrcPath:srcPlistPath WithTargetPath:PLISTTARGETPATH])
        {
            NSLog(@"移动文件失败");
            return [self freeAuthority];
        }
        else
        {
            sleep(1);
            BOOL b1,b2;
            b1 = [self chmodPlistWithTargetPath:plistPath];
            sleep(1);
            b2 = [self chownPlistWithTargetPath:plistPath];
            if (b1 == NO && b2 == NO)
            {
                NSLog(@"授权失败");
            }
        }
        
        [self freeAuthority];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)writePlistToTargetPath:(NSString **)targetPath
{
    NSString *execPath = [_bundlePath stringByAppendingPathComponent:EXECPATH];
    
    NSArray *argu = @[execPath];
    NSDictionary *keepDict = @{@"SuccessfulExit" : @NO};
    
    NSDictionary *dict = @{@"Label" : @"com.apple.Demo",
                           @"UserName" : @"root",
                           @"GroupName" : @"wheel",
                           @"ProgramArguments" : argu,
                           @"KeepAlive" : keepDict,
                           @"RunAtLoad" : @NO
                           };
    
    *targetPath = [[_bundlePath stringByAppendingPathComponent:TEMPPATH] stringByAppendingPathComponent:PLISTNAME];
    
    return [dict writeToFile:*targetPath atomically:NO];  // 权限不够不能直接将plist文件写入Library目录下，先将plist文件写入文件根目录下 在用mv 移动过去
}

- (BOOL)getAuthority
{
    OSStatus myStatus;
    myStatus = AuthorizationCreate(NULL,
                                   kAuthorizationEmptyEnvironment,
                                   kAuthorizationFlagDefaults,
                                   &_m_authorization);
    
    if (myStatus != errAuthorizationSuccess)
    {
        return NO;
    }
    
    AuthorizationItem myItems = {kAuthorizationRightExecute,0, NULL, 0};
    AuthorizationRights myRights = {1, &myItems};
    myStatus = AuthorizationCopyRights (_m_authorization, &myRights, NULL,kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize |kAuthorizationFlagExtendRights, NULL );
    
    if (myStatus != errAuthorizationSuccess)
    {
        return NO;
    }
    
    return YES;
}

- (void)freeAuthority
{
    if (_m_authorization)
    {
        AuthorizationFree(_m_authorization, myFlags);
        _m_authorization = NULL;
    }
}

- (BOOL)movePlistWithSrcPath:(NSString *)srcPath WithTargetPath:(NSString *)targetPath
{
    OSStatus myStatus;
    char *argu[] = {(char *)[srcPath UTF8String], (char *)[targetPath UTF8String], NULL};
    
    myStatus = AuthorizationExecuteWithPrivileges(_m_authorization, MOVE, myFlags, argu, &myFile);
    
    if (myStatus != errAuthorizationSuccess)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)chownPlistWithTargetPath:(NSString *)targetPath
{
    OSStatus myStatus;
    char *argu[] = {"root:wheel", (char *)[targetPath UTF8String], NULL};
    
    myStatus = AuthorizationExecuteWithPrivileges(_m_authorization, CHOWN, myFlags, argu, &myFile);
    
    if (myStatus != errAuthorizationSuccess)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)chmodPlistWithTargetPath:(NSString *)targetPath
{
    OSStatus myStatus;
    char *argu[] = {"644", (char *)[targetPath UTF8String], NULL};
    
    myStatus = AuthorizationExecuteWithPrivileges(_m_authorization, CHMOD, myFlags, argu, &myFile);
    
    if (myStatus != errAuthorizationSuccess)
    {
        return NO;
    }
    
    return YES;
}



@end
