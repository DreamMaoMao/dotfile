# dam

dam is a itsy-bitsy dwm-esque bar for [river].

![](dam-demo.jpg)

To use a status-bar, you can pass in status text via stdin:
```
slstatus -s | dam
```

## Building

To build dam first ensure that you have the following dependencies:

* wayland
* wayland-protocols
* fcft
* pixman
* pkg-config

Afterwards, run:
```
make
make install
```

## Usage

Run `dam`.

To hide the current selected output's monitor, the `USR1` signal can be
sent to do so.

[river]: https://codeberg.org/river
