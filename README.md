# Fork of the Endorphin web browser to target WEC2013
[![StandWithUkraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

Endorphin is a cross platform web browser built using Qt and WebKit.

This is a fork of the [Endorphin browser](https://github.com/EndorphinBrowser/browser),
which Aaron Dewes created as a fork of the [Arora browser](https://github.com/Arora/arora).

## WARNING
This project does not deliver a secure browser which is safe for browsing the internet.  
Read [Stop Using QtWebKit](https://blogs.gnome.org/mcatanzaro/2022/11/04/stop-using-qtwebkit/), and
know your responsibilities when deploying to production.

## Contributing

If you want to contribute, feel free to open an issue or a PR.


### Building

Endorphin uses the cmake build system. This fork of Endorphin is imported as a submodule into [SfQtWebKit](https://github.com/datadiode/SfQtWebKit), where it takes part in the Appveyor build.
I cannot give reproducible instructions on how to set up a local build environment.  Everything is scripted into the Appveyor build, which serves as the reference build environment.

#### Endorphin on HMI panel running WEC2013

![endorphin-welcome-page](https://user-images.githubusercontent.com/10423465/211192045-00672b4f-7c96-4e01-b8cc-bfa5c3ccda14.png)

![endorphin-html5-test](https://user-images.githubusercontent.com/10423465/221110409-c43c0020-84f8-48c7-8a8b-b24f7dd85e51.png)

#### Impact of JavaScript execution performance in a user scenario involving a SIMATIC RF600 family UHF RFID Reader

![switch-between-start-page-and-tag-monitor-endorphin-gifgit-freeconvert](https://user-images.githubusercontent.com/10423465/216931503-20111779-366e-48c2-963e-8959166a3881.gif)

![switch-between-start-page-and-tag-monitor-zetakey-gifgit-freeconvert](https://user-images.githubusercontent.com/10423465/216931811-fcb4fa51-ec8d-49f4-b11f-e7a178c2606e.gif)
