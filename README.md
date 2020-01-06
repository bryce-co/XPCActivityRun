# XPCActivityRun

A command line tool for jailbroken devices that allows you to manually trigger XPC Activities.

Best paired with [this post](https://bryce.co/running-xpc-activities-on-demand/) on [bryce.co](https://bryce.co/)
for background context and a walkthrough of the initial implementation.


## Usage

```bash
$ xpc-activity-run
Usage: xpcactivityrun [activity name 1] [activity name 2] [...]

# Example:
$ xpc-activity-run com.apple.CacheDelete.daily
```

The above example will cause the XPC Activity named `com.apple.CacheDelete.daily` (implemented by `deleted`)
to run immediately, regardless of schedule or activity criteria.

## Building

### Prerequisites

Install [Theos](https://github.com/theos/theos/) and [ldid](http://iphonedevwiki.net/index.php/Ldid).
As noted above, you will also need a jailbroken device to run the tool.

### Build

`make package`

## Installation

If you have `THEOS_DEVICE_IP` and `THEOS_DEVICE_PORT` set (see [Theos setup](https://iphonedevwiki.net/index.php/Theos/Setup)) :

`make package install`

Otherwise, you can copy the `.deb` file created by `make package` onto your device and install manually with `dpkg`.
