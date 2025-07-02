from typing import Optional, Union, Any
import asyncio
import subprocess
import os, os.path
import shlex
import sys

import libqtile
from libqtile import qtile, bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord as _KeyChord
from libqtile.lazy import lazy
from libqtile import hook
from libqtile import extension
from libqtile.extension import base
from libqtile.log_utils import logger
from xcffib.xproto import StackMode
import time

mod = "mod4"
terminal = 'kitty'

# Basic options.
focus_on_window_activation = "never"
reconfigure_screens: bool = True

# Allow programs to minimize themselves.
auto_minimize: bool = False
# Allow programs to fullscreen themselves.
auto_fullscreen: bool = True
# Make Java not be stupid.
wmname = "QTile"

dgroups_key_binder = None
dgroups_app_rules = []  # type: list

follow_mouse_focus: bool = False
bring_front_click: bool = True
cursor_warp: bool = False

HOME = os.getenv("HOME")

os.environ["GDK_CORE_DEVICE_EVENTS"] = "1"
os.environ["QT_QPA_PLATFORMTHEME"] = "gtk2"

gb0: widget.GroupBox = None
gb1: widget.GroupBox = None

class KeyChord(_KeyChord):
    def __init__(
        self,
        modifiers: list[str],
        key: str,
        submappings: list[Key | _KeyChord],
        mode: str = "",
        label: str = "",
    ) -> None:
        super().__init__(modifiers=modifiers, key=key, submappings=submappings, mode=mode)
        self.label = label

class ChordWidget(widget.Chord):
  defaults = [
        (
            "chords_colors",
            {},
            "colors per chord in form of tuple {'chord_name': ('bg', 'fg')}. "
            "Where a chord name is not in the dictionary, the default ``background`` and ``foreground``"
            " values will be used.",
        ),
        (
            "name_transform",
            lambda txt: txt,
            "preprocessor for chord name it is pure function string -> string",
        ),
    ]




@hook.subscribe.startup
def start_always():
    subprocess.run(["xsetroot", "-cursor_name", "left_ptr"])
    subprocess.run(["sh", os.path.join(HOME, ".fehbg")])
    subprocess.run(["setxkbmap", "-option", "compose:ralt"])
    #subprocess.run(["setxkbmap", "-option", "caps:escape_shifted_capslock"])
    subprocess.run(["setxkbmap", "-option", "caps:ctrl_modifier"])


@hook.subscribe.startup_once
def start_once():
    subprocess.run([
        "xrandr",
        "--output", "HDMI-0",
        "--rotate", "left",
        "--mode", "1920x1080",
        "--rate", "144",
        "--output", "DP-0",
        "--primary",
        "--pos", "0x480",
        "-s", "3640x1440"
    ])
    subprocess.run([
        "emacs", "--daemon",
    ])


def get_monitors() -> list[str]:
    xr = subprocess.check_output('xrandr --query | grep " connected"', shell=True).decode().split('\n')
    monitors = map(lambda x: x.split(' ')[0], xr)
    return list(monitors)

monitors = get_monitors()


def other_screen(qtile, direction=1):
    "Focus other screen."
    other_scr_index = (qtile.screens.index(qtile.currentScreen) + direction) % len(qtile.screens)
    qtile.focus_screen(other_scr_index)


class Rofi(base.RunCommand):
    rofi_command: str
    defaults = [
        ("rofi_command", "rofi", "rofi command"),
        ("modi", "drun,run", "Modi to enable"),
        ("show", "drun", "Mode to show"),
    ]

    def __init__(self, **config):
        base.RunCommand.__init__(self, **config)
        self.add_defaults(Rofi.defaults)

    def _configure(self, qtile):
        base.RunCommand._configure(self, qtile)

        rcommand = self.rofi_command or self.command
        if isinstance(rcommand, str):
            self.configured_command = shlex.split(rcommand)
        else:
            self.configured_command = list(rcommand)

        if self.modi:
            self.configured_command.extend(("-modi", self.modi))

        if self.show:
            self.configured_command.extend(("-show", self.show))


class RofiMenu(base.RunCommand):
    rofi_command: str
    defaults = [
        ("rofi_command", "rofi -dmenu", "rofi command"),
        ("items", None, "Items to list"),
    ]

    def __init__(self, **config):
        base.RunCommand.__init__(self, **config)
        self.add_defaults(Rofi.defaults)

    def _configure(self, qtile):
        base.RunCommand._configure(self, qtile)

        rcommand: str | list[str] = self.rofi_command or self.command
        if isinstance(rcommand, str):
            self.configured_command = shlex.split(rcommand)
        else:
            self.configured_command = list(rcommand)


        if self.dmenu_bottom:
            self.configured_command.append("-b")
        if self.dmenu_ignorecase:
            self.configured_command.append("-i")
        if self.dmenu_lines:
            self.configured_command.extend(("-l", str(self.dmenu_lines)))
        if self.dmenu_prompt:
            self.configured_command.extend(("-p", self.dmenu_prompt))

        font = None
        if self.dmenu_font:
            font = self.dmenu_font
        elif self.font:
            if self.fontsize:
                font = "{}-{}".format(self.font, self.fontsize)
            else:
                font = self.font

        if font:
            self.configured_command.extend(("-fn", font))

        if self.background:
            self.configured_command.extend(("-nb", self.background))
        if self.foreground:
            self.configured_command.extend(("-nf", self.foreground))
        if self.selected_background:
            self.configured_command.extend(("-sb", self.selected_background))
        if self.selected_foreground:
            self.configured_command.extend(("-sf", self.selected_foreground))
        # NOTE: The original dmenu doesn't support the '-h' option
        if self.dmenu_height:
            self.configured_command.extend(("-h", str(self.dmenu_height)))

    def run(self, items=None):
        if items and self.dmenu_lines:
            lines = min(len(items), int(self.dmenu_lines))
            self.configured_command.extend(("-l", str(lines)))

        proc = super().run()

        if items:
            input_str = "\n".join([i for i in items]) + "\n"
            return proc.communicate(str.encode(input_str))[0].decode("utf-8")

        return proc



@hook.subscribe.client_new
def float_steam(window):
    wm_class = window.window.get_wm_class()
    w_name = window.window.get_name()
    if (
        wm_class == ("Steam", "Steam")
        and (
            w_name != "Steam"
            # w_name == "Friends List"
            # or w_name == "Screenshot Uploader"
            # or w_name.startswith("Steam - News")
            or "PMaxSize" in window.window.get_wm_normal_hints().get("flags", ())
        )
    ):
        window.floating = True

last_swap_time = time.time()
@hook.subscribe.client_focus
def on_focus(w):
    global last_swap_time
    ws_screen = None

    #logger.warn("w option: {}".format(w.qtile.config.focus_on_window_activation))

    old_screen = qtile.current_screen
    old_group = qtile.current_group


    for i in range(len(workspaces)):
        for ws in workspaces[i]:
            if ws['name'] == w.group.name:
                ws_screen = i

    if ws_screen:
        now = time.time()
        if now - last_swap_time > 2:
            last_swap_time = now
            #w.group.cmd_toscreen(screen=ws_screen, toggle=False)



@hook.subscribe.layout_change
def change_layout(layout, group):
    try:
        bar = qtile.current_screen.bottom
        screen = qtile.current_screen
    except AttributeError:
        return

    if layout.name == "max":
        bar._initial_margin = [0, 0, 0, 0]
        bar.border_width = [1, 0, 0, 0]
    else:
        bar._initial_margin = [4, 8, 16, 8]
        bar.border_width = [1, 1, 1, 1]

    if gb0 and gb1:
        gb0.visible_groups = [g['group'].name for g in workspaces[0]]
        gb1.visible_groups = [g['group'].name for g in workspaces[1]]

    bar._configure(qtile, qtile.current_screen, reconfigure=True)
    bar.draw()
    screen.group.layout_all()

    logger.debug(repr([g.label for g in groups]))
    logger.debug(repr([g.label for g in qtile.groups]))
    for i in range(len(qtile.screens)):
        logger.debug("[{}] {}".format(i, [w['name'] for w in workspaces[i]]))

def to_other_screen(qtile):
    if not qtile.current_window: return

    screens = qtile.screens
    cscr = qtile.current_screen
    i = cscr.index

    newi = i + 1
    newi = 0 if newi >= len(screens) else newi

    qtile.current_window.cmd_toscreen(newi)


def select_ws(qtile, nth):
    screen = qtile.current_screen
    scri = screen.index

    ws_scr_list = workspaces[scri] if scri in range(len(workspaces)) else None
    if ws_scr_list == None: return

    ws_dict = ws_scr_list[nth] if nth in range(len(ws_scr_list)) else None

    if ws_dict:
        group = ws_dict['group']
        realGroup = qtile.groups[groups.index(group)]
        realGroup.cmd_toscreen()

        return True

def move_to_ws(qtile, nth):
    screen = qtile.current_screen
    scri = screen.index

    ws_scr_list = workspaces[scri] if scri in range(len(workspaces)) else None
    if ws_scr_list == None: return

    ws_dict = ws_scr_list[nth] if nth in range(len(ws_scr_list)) else None

    if ws_dict:
        group = ws_dict['group']
        qtile.current_window.cmd_togroup(group.name)

def push_ws(qtile, nexti=None):
    screen = qtile.current_screen
    scri = screen.index
    nexti = screen.index if nexti == "current" else nexti
    nexti = screen.index + 1 if nexti == None else nexti
    if nexti >= len(qtile.screens):
        nexti = 0


    logger.debug("scri {}, nexti {}".format(scri, nexti))

    ws_scr_list = workspaces[scri] if scri in range(len(workspaces)) else None
    if ws_scr_list == None: return

    currentGroup = qtile.current_group

    nth: int | None = None
    for j in range(len(ws_scr_list)):
        if ws_scr_list[j]['name'] == currentGroup.name:
            nth = j
            break

    if nth == None:
        return

    ws_dict = ws_scr_list[nth] if nth in range(len(ws_scr_list)) else None

    logger.debug("scri {}, nexti {}, ws_scr_list ({} items), nth {}".format(scri, nexti, len(ws_scr_list), nth))
    if ws_dict:
        d = ws_scr_list.pop(nth)
        workspaces[nexti].append(d)
        ii = groups.index(d['group'])
        realGroup = qtile.groups[ii]
        realGroup.cmd_toscreen(nexti)
        update_group_names()

        qtile.groups.append(qtile.groups.pop(ii))
        groups.append(groups.pop(ii))

        select_ws(qtile, nth) or select_ws(qtile, 0) # pyright: ignore[reportUnusedExpression]


vol_sound = "/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"

@lazy.function
def lazy_bring_to_front_safe(_):
    if qtile.current_window:
        qtile.current_window.window.configure(stackmode=StackMode.Above)

keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move left"),
    Key([mod], "l", lazy.layout.right(), desc="Move  right"),
    Key([mod], "j", lazy.layout.down(), desc="Move  down"),
    Key([mod], "k", lazy.layout.up(), desc="Move up"),

    #Key([mod], "Tab", lazy.layout.rotate(), desc="Focus other?"),
    Key(["mod1"], "Tab", lazy.group.next_window(), lazy_bring_to_front_safe(), desc="Cycle through windows"),
    Key(["mod1", "shift"], "Tab", lazy.group.prev_window(), lazy_bring_to_front_safe(), desc="Cycle through windows reverse"),

    #Moving
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow up"),

    Key([mod], "n", lazy.layout.normalize(), desc="Reset sizes"),
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Group/ungroup stack side"),

    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "f2", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "r", lazy.run_extension(Rofi())),
    Key([mod, "shift"], "f", lazy.window.toggle_floating()),
    Key([mod], "f11", lazy.window.toggle_fullscreen()),
    Key([mod], "o", lazy.next_screen()),
    Key([mod, "shift"], "o", lazy.function(to_other_screen)),
    Key([mod, "shift", "control"], "o", lazy.function(push_ws)),
    Key([mod, "shift", "mod1"], "o", lazy.function(push_ws, "current")),
    Key([], "Sys_Req", lazy.spawn("spectacle")),
    Key([mod, "shift"], "s", lazy.spawn("spectacle")),

    KeyChord([mod], 'd', [
        Key([], 'w', lazy.run_extension(Rofi(modi="window", show="window"))),
    ],
    ),

    Key([], "XF86AudioPlay", lazy.spawn("mpc toggle")),
    Key([], "XF86AudioNext", lazy.spawn("mpc next")),
    Key([], "XF86AudioPrev", lazy.spawn("mpc prev")),

    Key(["shift"], "XF86AudioRaiseVolume", lazy.spawn("mpc volume +5"), lazy.spawn("play " + vol_sound)),
    Key(["shift"], "XF86AudioLowerVolume", lazy.spawn("mpc volume -5"), lazy.spawn("play " + vol_sound)),

    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5"), lazy.spawn("play " + vol_sound)),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5"), lazy.spawn("play " + vol_sound)),
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t")),
]


wkeys = [
    {"key": "1", "sym": "₁"},
    {"key": "2", "sym": "₂"},
    {"key": "3", "sym": "₃"},
    {"key": "4", "sym": "₄"},
    {"key": "5", "sym": "₅"},
    {"key": "6", "sym": "₆"},
    {"key": "7", "sym": "₇"},
    {"key": "8", "sym": "₈"},
    {"key": "9", "sym": "₉"},
    {"key": "0", "sym": "₀"},
]

workspaces = [
[
    {"name": "", "matches": [], "layout": "columns"},
    {"name": "", "matches": [], "layout": "columns"},
    {"name": "", "matches": [], "layout": "columns"},
    {"name": "", "matches": [], "layout": "columns"},
    {"name": "", "matches": [Match(wm_class=["Firefox", "Waterfox", "Navigator"])], "layout": "columns"},
],
[
    {"name": "", "matches": [Match(wm_class=["discord"])], "layout": "columns"},
]]


def update_group_names():
    global gb0, gb1
    for i in range(len(workspaces)):
        for j in range(len(workspaces[i])):
            w = workspaces[i][j]

            try:
                realGroup = qtile.groups[groups.index(w['group'])]
                realGroup.label = w['name'] + wkeys[j]['sym']
            except IndexError:
                logger.info("Couldn't update group name for {}. Possibly new group?".format(w['name']))
            w['group'].label = w['name'] + wkeys[j]['sym']

    if gb0 and gb1:
        gb0.visible_groups = [g['group'].name for g in workspaces[0]]
        gb1.visible_groups = [g['group'].name for g in workspaces[1]]


for i in range(len(wkeys)):
    keys.append(Key([mod], wkeys[i]['key'],
        lazy.function(select_ws, i),
        desc="Select {}th group on current screen.".format([i+1])
    ))
    keys.append(Key([mod, "shift"], wkeys[i]['key'],
        lazy.function(move_to_ws, i),
        desc="Window to {}th group on current screen.".format([i+1])
    ))

    #keys.append(Key([mod], w['key'], lazy.group[w['name']].toscreen(), desc="Switch to group {}".format(w['name'])))
    #keys.append(Key([mod, "shift"], w['key'], lazy.window.togroup(w['name']), desc="Window to group {}".format(w['name'])))



groups = []
for w in [w for scr in workspaces for w in scr]:
    matches = w.get("matches")
    lo = w.get("layout")
    w['group'] = Group(w['name'], matches=matches, layout=lo)
    groups.append(w['group'])

update_group_names()


layout_theme = {
    "border_width": 3,
    "margin": 8,
    "border_focus": "#ffaadd",
    "border_focus_stack": "#ffffff",
    "border_normal": "#000000",
}

layouts = [
    layout.Columns(**layout_theme),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    #layout.Stack(num_stacks=2),
    #layout.Bsp(),
    #layout.Matrix(),
    #layout.MonadTall(),
    #layout.MonadWide(),
    #layout.RatioTile(),
    #layout.Tile(),
    #layout.TreeTab(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Zoomy(**layout_theme),
]

widget_defaults = dict(
    font="Terminus Bold",
    fontsize=22,
    padding=3,
)
extension_defaults = widget_defaults.copy()

gb0 = widget.GroupBox(
    border_width=2,
    active="ffffff",
    inactive="969696",
    this_current_screen_border="ffffff",
    this_screen_border="aaaaaa",
    other_current_screen_border="ffffff",
    other_screen_border="aaaaaa",
    font="Terminus",
    fontsize=18,
    highlight_method="line",
    highlight_color=['00004400', '00004400'],
)
gb1 = widget.GroupBox(
    border_width=2,
    active="ffffff",
    inactive="969696",
    this_current_screen_border="ffffff",
    this_screen_border="aaaaaa",
    other_current_screen_border="ffffff",
    other_screen_border="aaaaaa",
    font="Terminus",
    fontsize=18,
    highlight_method="line",
    highlight_color=['00004400', '00004400'],
)


pom_sound = "/usr/share/sounds/gnome/default/alerts/glass.ogg"

class LunaPom(widget.Pomodoro):
    def _send_notification(self, urgent, message):
        super()._send_notification(urgent, message)

        if urgent == "normal":
            subprocess.run(["play", pom_sound])



screens = []
for monitor in range(len(monitors)):
    if monitor == 0:
        screens.append(
            Screen(
                bottom=bar.Bar(
                    [
                        gb0,
                        widget.CurrentLayoutIcon(),
                        widget.Prompt(),
                        widget.Chord(
                            chords_colors={
                                "launch": ("#ff0000", "#ffffff"),
                            },
                            name_transform=lambda name: "*{}*".format(name),
                        ),
                        widget.WindowName(),
                        #widget.TaskList(
                        #    font="Terminus",
                        #    fontsize=18,
                        #    margin=0,
                        #    highlight_method="block",
                        #    rounded=False,
                        #    border_width=2,
                        #    border="000000",
                        #    icon_size=18,
                        #    title_width_method="uniform",
                        #    ),
                        #widget.WindowTabs(),
                        widget.Mpd2(status_format='{play_status} {artist}/{title} '
                                '[{repeat}{random}{single}{consume}{updating_db}] {volume}%'),
                        widget.Systray(),
                        widget.PulseVolume(),
                        widget.Clock(format="%I:%M %p"),
                        #widget.QuickExit(),
                    ],
                    28,
                    background="#000044FF",
                    margin=[4, 8, 16, 8],
                    border_width=[1, 1, 1, 1],
                    border_color="#888888",
                ),
            )
        )
    else:
        screens.append(
            Screen(
                bottom=bar.Bar(
                    [
                        gb1,
                        widget.CurrentLayoutIcon(),
                        widget.Chord(
                            chords_colors={
                                "launch": ("#ff0000", "#ffffff"),
                            },
                            name_transform=lambda name: "*{}*".format(name),
                        ),
                        widget.WindowName(),
                        LunaPom(
                            prefix_inactive="",
                            prefix_active=" ",
                            prefix_break=" ",
                            prefix_long_break=" ",
                            prefix_paused=" PAUSED",
                        ),
                        widget.Clock(format="%I:%M %p"),
                    ],
                    28,
                    background="#000044FF",
                    margin=[4, 8, 16, 8],
                    border_width=[1, 1, 1, 1],
                    border_color="#888888",
                )
            )
        )

def focus_and_get_pos(qtile):
    for w in qtile.windows():
        pass

    lazy.window.focus()
    return lazy.window.get_position()

# Drag floating layouts.
mouse = [
    #Click([mod], "Button1", lazy.window.bring_to_front()),
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    #Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.function(focus_and_get_pos)),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
]

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    **layout_theme,
)


