# skeleton
CLI for fast generating multi language page objects from iOS and Android screens.


Prerequisites:
--------

#### Android
- Install [SDK Tools](http://developer.android.com/sdk/installing/index.html?pkg=tools).
- SDK tools are added to your $PATH. [OSX](https://stackoverflow.com/posts/19764254/revisions)
- Enable [USB Debugging](https://www.kingoapp.com/root-tutorials/how-to-enable-usb-debugging-mode-on-android.htm) on your device(s).

#### iOS
- Install [Xcode](https://developer.apple.com/xcode/download/).
- Install [Xcode Command Line Tools](http://railsapps.github.io/xcode-command-line-tools.html).
- [Setting up Skeleton for working with iOS real devices](https://github.com/forqa/skeleton/blob/master/docs/real-ios-device-config.md)

Installation:
------
    $ gem install skeleton-ui

Usage:
------
    $ skeleton --help

    DESCRIPTION:

    CLI for fast generating multi language page objects from iOS and Android screens.

    COMMANDS:

    clear Clear user cache
    scan  Make screen objects

    GLOBAL OPTIONS:

    -h, --help
    Display help documentation

    -v, --version
    Display version information

    -t, --trace
    Display backtrace when an error occurs

        $ skeleton scan --help
            
            EXAMPLES:
            
            skeleton scan -p (ios or android) -u 749575366595763538563 -b com.my.bundle
            
            OPTIONS:
            
            -p, --platform PLATFORM
            Set device platform: android or ios
            
            -u, --udid UDID
            Set device UDID
            
            -b, --bundle BUNDLE
            Set Bundle ID for your app [required for iOS]
        
        $ skeleton clear --help
            
            EXAMPLES:
            
            skeleton clear

## License

A tool is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


