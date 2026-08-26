#import <Foundation/Foundation.h>
#include <lua.h>
#include <stdbool.h>

#ifdef MACOS_USE_BUNDLE
void set_macos_bundle_resources(lua_State *L)
{ @autoreleasepool
{
    NSString* resource_path = [[NSBundle mainBundle] resourcePath];
    lua_pushstring(L, [resource_path UTF8String]);
    lua_setglobal(L, "MACOS_RESOURCES");
}}
#endif

/* Thanks to mathewmariani, taken from his lite-macos github repository. */
void enable_momentum_scroll() {
  [[NSUserDefaults standardUserDefaults]
    setBool: YES
    forKey: @"AppleMomentumScrollSupported"];
}

/* Code fork: macOS-only — buffers the URLs the OS asks the app to open
 * (drag-onto-Dock-icon, Finder "Open With", command-line `open`, etc.) so
 * that the running instance can pick them up and open them as projects. */
static NSMutableArray<NSString *> *pendingOpenURLs = nil;

static void code_buffer_open_url(NSURL *url) {
  if (!url) return;
  if (!pendingOpenURLs) pendingOpenURLs = [NSMutableArray array];
  [pendingOpenURLs addObject:url.path];
}

/* Called by the AppDelegate when macOS asks the app to open files/URLs
 * (e.g. drag a folder onto the Dock icon). */
void code_app_open_url(NSURL *url) {
  code_buffer_open_url(url);
}

void code_app_open_urls(NSArray<NSURL *> *urls) {
  if (!urls) return;
  for (NSURL *u in urls) code_buffer_open_url(u);
}

/* Drained from Lua during startup; returns the buffered paths as a
 * comma-separated string and clears the buffer. Empty string if none. */
const char *code_take_pending_open_paths(void) {
  if (!pendingOpenURLs || pendingOpenURLs.count == 0) return "";
  NSMutableString *out = [NSMutableString string];
  for (NSUInteger i = 0; i < pendingOpenURLs.count; i++) {
    if (i > 0) [out appendString:@"\1"]; /* sentinel separator */
    [out appendString:pendingOpenURLs[i]];
  }
  [pendingOpenURLs removeAllObjects];
  return [out UTF8String];
}

/* Install an AppDelegate that forwards NSApplicationDelegate openURLs: /
 * openFiles: calls to the buffer above. Replaces whatever default
 * delegate Cocoa installed. */
static bool code_app_delegate_installed = false;
@interface CodeAppDelegate : NSObject <NSApplicationDelegate>
@end
@implementation CodeAppDelegate
- (void)application:(NSApplication *)sender openURLs:(NSArray<NSURL *> *)urls {
  code_app_open_urls(urls);
}
- (void)application:(NSApplication *)sender openFile:(NSString *)filename {
  code_buffer_open_url([NSURL fileURLWithPath:filename]);
}
- (void)application:(NSApplication *)sender openFiles:(NSArray<NSString *> *)filenames {
  for (NSString *f in filenames) code_buffer_open_url([NSURL fileURLWithPath:f]);
}
@end

void code_install_app_delegate(void) {
  if (code_app_delegate_installed) return;
  CodeAppDelegate *d = [[CodeAppDelegate alloc] init];
  [NSApp setDelegate:d];
  code_app_delegate_installed = true;
}