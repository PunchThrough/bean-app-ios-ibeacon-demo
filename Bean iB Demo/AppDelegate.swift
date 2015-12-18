import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    // MARK: - Local variables

    var window: UIWindow?

    // CLLocationManager is really, really tricky to use properly. Check out the Apple docs for guidance:
    // https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLLocationManager_Class/index.html
    var locationManager: CLLocationManager?
    
    var authStatusStrings = [
        CLAuthorizationStatus.NotDetermined: "Not determined",
        CLAuthorizationStatus.Restricted: "Restricted",
        CLAuthorizationStatus.Denied: "Denied",
        CLAuthorizationStatus.AuthorizedAlways: "Authorized always",
        CLAuthorizationStatus.AuthorizedWhenInUse: "Authorized when in use",
    ]
    
    // MARK: - AppDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupLocationManager()
        checkAuthorization()
        subscribeToBeacons()
        return true
    }
    
    // MARK: - Set up beacon monitoring
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
    }
    
    func checkAuthorization() {
        print("Location services enabled: \(CLLocationManager.locationServicesEnabled())")
        locationManager!.requestAlwaysAuthorization()
    }
    
    func subscribeToBeacons() {
        print("Device supports Bluetooth beacon ranging: \(CLLocationManager.isRangingAvailable())")
        
        let uuid = NSUUID.init(UUIDString: "A495DEAD-C5B1-4B44-B512-1370F02D74DE")
        let major: CLBeaconMajorValue = 0xBEEF
        let minor: CLBeaconMinorValue = 0xCAFE
        
        let region = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: "Bean iBeacon")
        
        locationManager!.startMonitoringForRegion(region)
        locationManager!.startRangingBeaconsInRegion(region)
        
        let majorHex = String(format: "%X", major)
        let minorHex = String(format: "%X", minor)
        print("Scanning for iBeacons with UUID: \(uuid!.UUIDString), major: \(majorHex), minor: \(minorHex)")
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // MARK: Incoming data
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Location auth status changed: \(authStatusStrings[status]!)")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered region: \(region.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited region: \(region.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if (beacons.count > 0) {
            print("Found \(beacons.count) iBeacon(s) in region: \(region.identifier)")
            for beacon in beacons {
                print("    RSSI: \(beacon.rssi)")
            }
        }
    }
    
    // MARK: Handling errors
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region: \(region?.identifier), error: \(error)")
    }
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        print("Ranging beacons failed for region: \(region.identifier), error: \(error)")        
    }

}

