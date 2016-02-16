Lenovo ThinkPad t550 scripts
============================

Collection of various scripts and rules for happy living with t550.

What it provides:
* Brightness control with Fn+F5/F6
* Volume control with Fn+F1/F2/F3/F4
* Automatic monitor configuration on cable plug/unplug and lid close/open

To accomplish such bold goals this scripts relies on ACPI and udev notifications

Installation
------------

### SELinux workaround

Currently, selinux denies access from acpid scripts to access almost everything.
For now, I'm suggesting set "SELINUX=permissive" in /etc/selinux/config, until I
figure out correct policy changes for acpid.

If you want to contribute, this is what you should try to do.

### PulseAudio configuration

Volume control is done via acpi actions. These actions run as "root" and it will
fail to work with PulseAudio because it runs under your user. One simple and
dirty hack to fix this is run PulseAudio system-wide but it is strongly
discouraged.

The way I suggest is allow user-wide PulseAudio server accept connections from
users in specified group. To do this, just edit your /etc/pulse/default.pa and
add 2 parameters "auth-group-enable" and "auth-group" to
module-native-protocol-unix:

    load-module module-native-protocol-unix auth-group-enable=true auth-group=pulse-access

"pulse-access" is the group created by PulseAudio installation.

After this, you may access PulseAudio under "root" user, but you have to provide
server socket. To get server socket location, run `pactl info` and look for
"Server String", usually it's `/var/run/user/<your id>/pulse/native`. Now, when
you know server socket, test working under root with the following command:

    # pactl -s /var/run/user/1000/pulse/native info
    Server String: /var/run/user/1000/pulse/native
    ...
    Default Sink: alsa_output.pci-0000_00_1b.0.analog-stereo
    Default Source: alsa_input.pci-0000_00_1b.0.analog-stereo

If it works, create /root/pulse/client.conf with following content:

    # CHANGE TO YOUR SOCKET
    default-server = /var/run/user/1000/pulse/native


