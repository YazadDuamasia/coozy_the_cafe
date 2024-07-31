import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionScreen extends StatefulWidget {
  final VoidCallback onPermissionsGranted;

  AppPermissionScreen({Key? key, required this.onPermissionsGranted})
      : super(key: key);

  @override
  _AppPermissionScreenState createState() => _AppPermissionScreenState();
}

class _AppPermissionScreenState extends State<AppPermissionScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  // Map<String, dynamic> _deviceData = <String, dynamic>{};

/*  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    String currentPlatform = await Constants.getCurrentPlatform();
    try {
      if (currentPlatform != null && currentPlatform == "web") {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (currentPlatform) {
          "Android" =>
            _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
          "iOS" => _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
          "Linux" => _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
          "Windows" =>
            _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
          "macOS" => _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
          "Fuchsia" => <String, dynamic>{
              'Error:': 'Fuchsia platform isn\'t supported'
            },
          "IO" => <String, dynamic>{'Error:': 'IO platform isn\'t supported'},
          "Unknown platform" => <String, dynamic>{
              'Error:': 'Unknown platform isn\'t supported'
            },
          _ => <String, dynamic>{'Error:': 'Unsupported platform'},
        };
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }*/

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }

  final List<Permission> _permissions = [
    Permission.camera,
    Permission.ignoreBatteryOptimizations,
    // Permission.photos,
    // Permission.videos,
    // Permission.storage,
    Permission.location,
    Permission.notification,
    Permission.contacts,
    Permission.calendarWriteOnly,
    Permission.calendarFullAccess,
    Permission.scheduleExactAlarm,
    Permission.bluetoothScan,
    Permission.bluetoothAdvertise,
    Permission.bluetoothConnect,
    Permission.nearbyWifiDevices,
    Permission.systemAlertWindow,
  ];

  final List<PermissionWithService> _permissionWithService = [
    Permission.bluetooth,
    Permission.locationWhenInUse,
  ];

  Map<Permission, PermissionStatus> _permissionStatuses = {};

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = {};
    // await initPlatformState();

    if (Constants.isAndroid()) {
      AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
      if (build.version.sdkInt > 32) {
        _permissions.add(Permission.photos);
        _permissions.add(Permission.videos);
        setState(() {});
      } else {
        _permissions.add(Permission.storage);
        setState(() {});
      }
    }

    // Check statuses for permissions
    for (var permission in _permissions) {
      statuses[permission] = await permission.status;
    }

    // Check statuses for permissions with service
    for (var permission in _permissionWithService) {
      if (await permission.serviceStatus.isEnabled) {
        statuses[permission] = await permission.status;
      } else {
        statuses[permission] = PermissionStatus.denied;
      }
    }

    setState(() {
      _permissionStatuses = statuses;
    });

    // Check if all permissions are granted
    if (_allPermissionsGranted(statuses)) {
      widget.onPermissionsGranted();
    }
  }

  bool _allPermissionsGranted(Map<Permission, PermissionStatus> statuses) {
    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = {};

    // Request permissions
    for (var permission in _permissions) {
      statuses[permission] = await permission.request();
    }

    // Request permissions with service
    for (PermissionWithService permissionWithService
        in _permissionWithService) {
      if (await permissionWithService.serviceStatus.isEnabled) {
        statuses[permissionWithService] = await permissionWithService.request();
      } else {
        statuses[permissionWithService] = PermissionStatus.denied;
      }
    }

    setState(() {
      _permissionStatuses = statuses;
    });

    _handlePermissions(statuses);

    // Check if all permissions are granted
    if (_allPermissionsGranted(statuses)) {
      widget.onPermissionsGranted();
    }
  }

  void _handlePermissions(Map<Permission, PermissionStatus> statuses) {
    statuses.forEach((permission, status) {
      if (status.isDenied) {
        _showPermissionDeniedDialog(permission);
      } else if (status.isPermanentlyDenied) {
        _showPermissionPermanentlyDeniedDialog(permission);
      }
    });
  }

  void _showPermissionDeniedDialog(Permission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: Text(
            'The ${permission.toString().split('.').last} permission was denied. Please allow it to proceed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog(Permission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Permanently Denied'),
        content: Text(
            'The ${permission.toString().split('.').last} permission was permanently denied. Please enable it from the app settings.'),
        actions: [
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPermissionList() {
    return _permissions.map((permission) {
      return ListTile(
        onTap: () {
          if (!_permissionStatuses[permission]!.isGranted) {
            _handlePermissions(_permissionStatuses);
          } else {
            return null;
          }
        },
        title: Text(
          permission.toString().split('.').last,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'Permission Status : ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600)),
              TextSpan(
                text: '${_permissionStatuses[permission]?.name??""}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: _permissionStatuses[permission]?.isGranted ?? false
                        ? Colors.green
                        : Colors.red),
              ),
            ],
          ),
        ),
        trailing: _permissionStatuses[permission]?.isGranted ?? false
            ? Icon(MdiIcons.checkCircle, color: Colors.green)
            : Icon(MdiIcons.closeCircle, color: Colors.red),
      );
    }).toList()
      ..addAll(_permissionWithService.map((permission) {
        return ListTile(
          onTap: () {
            if (!_permissionStatuses[permission]!.isGranted) {
              _handlePermissions(_permissionStatuses);
            } else {
              return null;
            }
          },
          title: Text(
            permission.toString().split('.').last,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'Permission Status : ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600)),
                TextSpan(
                  text: '${_permissionStatuses[permission]!.name}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: _permissionStatuses[permission]?.isGranted ?? false
                          ? Colors.green
                          : Colors.red),
                ),
              ],
            ),
          ),
          trailing: _permissionStatuses[permission]?.isGranted ?? false
              ? Icon(MdiIcons.checkCircle, color: Colors.green)
              : Icon(MdiIcons.closeCircle, color: Colors.red),
        );
      }).toList());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('App Permissions'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 0, right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: const Text(
                      'Permissions Overview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: const Text(
                      'This app requires the following permissions to function correctly. Please review and grant the necessary permissions.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: _buildPermissionList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _requestPermissions,
                      child: const Text('Request Permissions'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkPermissions();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
