#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRPrinterSession : NSObject

- (void)printPDF:(nonnull NSString*) path copies:(NSUInteger) copies model:(NSInteger) model paperSettingsPath:(NSString *) paperSettingsPath ipAddress:(nonnull NSString*) ipAddress error:(NSError **)error;
- (void)printPDF:(nonnull NSString*) path copies:(NSUInteger) copies model:(NSInteger) model paperSettingsPath:(NSString *) paperSettingsPath serialNumber:(nonnull NSString*) serialNumber error:(NSError **)error;
- (void)printPDF:(nonnull NSString*) path copies:(NSUInteger) copies model:(NSInteger) model paperSettingsPath:(NSString *) paperSettingsPath bleAdvertiseLocalName:(nonnull NSString*) bleAdvertiseLocalName error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
