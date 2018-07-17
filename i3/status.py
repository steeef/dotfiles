from i3pystatus import Status

stat = Status(standalone=True)

cal_cmd = "notify-send 'Calendar' \"<tt>$(cal)</tt>\""

stat.register(
    "clock",
    interval=3,
    on_leftclick=cal_cmd,
    on_rightclick=["scroll_format", 1],
    format=[("%-m/%-d %-H:%M %Z", "America/Los_Angeles"), ("%-m/%-d %-H:%M %Z", "UTC")],
)

stat.register("alsa", format=" {volume}%", format_muted=" --", on_leftclick=["mate-volume-control"])

stat.register(
    "battery",
    interval=11,
    battery_ident="BAT0",
    critical_color="#ff0000",
    format="{status} {percentage:02.0f}% {remaining:%E%h:%M}",
    alert=False,
    alert_percentage=10,
    status={"DIS": u"()", "CHR": u"()", "FULL": u"(-)"},
)
stat.register(
    "battery",
    interval=13,
    battery_ident="BAT1",
    critical_color="#ff0000",
    format="{status} {percentage:02.0f}%" " {remaining:%E%h:%M}",
    alert=False,
    alert_percentage=10,
    status={"DIS": u"()", "CHR": u"()", "FULL": u"(-)"},
)

stat.register(
    "network",
    interval=7,
    interface="wlp3s0",
    color_up="#70F7AA",  # $sand in .i3 config
    color_down="#CCCCCC",
    format_up=" {essid}\[{v4}\]",
    format_down=" ",
)

stat.register("shell", command="~/.i3/status_scripts/update-stat.sh", interval=120)

stat.register("cpu_usage", format=" {usage:02}%")

stat.run()
