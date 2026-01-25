#!/usr/bin/env python3
"""DK Window Manager Configuration File - Python Version"""

import os
import subprocess
import time
import logging
from typing import Optional, List, Dict
from pathlib import Path

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class DKConfig:
    def __init__(self) -> None:
        self.home: Path = Path.home()
        self.config_dir: Path = Path(os.environ.get('XDG_CONFIG_HOME', self.home / '.config')) / 'dk'
        self.runtime_dir: Path = Path(os.environ.get('XDG_RUNTIME_DIR', '/tmp'))
        self.dksock: Optional[str] = None
        self.wsnum: int = 9
        self.monitors: List[str] = ['DisplayPort-0', 'DisplayPort-1', 'DisplayPort-2']
        self.ws_names: List[str] = ['G', 'R', 'R', 'W', 'R', 'R', 'T', 'R', 'R']
        self.colors: Dict[str, str] = {'red': '#ee5555', 'blue': '#6699cc', 'black': '#222222'}
        self.floating_apps: List[str] = []

    def run_cmd(self, cmd: Optional[str | List[str]], input_str: Optional[str] = None,
               check: bool = True, shell: bool = True) -> Optional[subprocess.CompletedProcess]:
        """Execute a command with optional input."""
        try:
            if input_str and self.dksock and os.path.exists(self.dksock):
                try:
                    return subprocess.run(['socat', '-', self.dksock],
                                       input=input_str,
                                       text=True,
                                       check=check,
                                       capture_output=True)
                except subprocess.CalledProcessError:
                    logger.error(f"Socat command failed: {input_str}")
                    return None
            if cmd:
                return subprocess.run(cmd,
                                   shell=shell,
                                   check=check,
                                   capture_output=True,
                                   text=True)
            return None
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            logger.error(f"Command failed: {e}")
            return None

    def load_configs(self):
        """Load colors from Xresources and floating apps list."""
        if self.run_cmd(['whereis', 'xrdb'], shell=False) and (self.home / '.Xresources').exists():
            self.run_cmd(['xrdb', '-load', str(self.home / '.Xresources')], shell=False)
            result = self.run_cmd(['xrdb', '-query'], shell=False)
            if result:
                for line in result.stdout.split('\n'):
                    if 'color1:' in line: self.colors['red'] = line.split()[-1]
                    elif 'color4:' in line: self.colors['blue'] = line.split()[-1]
                    elif 'color8:' in line: self.colors['black'] = line.split()[-1]

        floating_file = self.config_dir / 'FloatingApps'
        if floating_file.exists():
            with open(floating_file) as f:
                self.floating_apps = [line.strip() for line in f if line.strip()]

    def setup_workspaces(self):
        """Configure workspaces and layouts."""
        cmds = [
            f'dkcmd set numws="{self.wsnum}"',
            'dkcmd set ws=_ apply layout=rtile master=1 stack=3 pad {l,r,t,b}=6 gap=5 msplit=0.70 ssplit=0.5',
            'dkcmd set ws=1 layout=grid pad {l,r,t,b}=25 gap=50',
            'dkcmd set ws=4 layout=tstack msplit=0.85',
            'dkcmd set ws=7 layout=tile msplit=0.50',
            'dkcmd set static_ws=true'
        ]

        for i in range(self.wsnum):
            mon_idx = i // 3
            cmds.append(f'dkcmd set ws="{i+1}" name="{i+1}:{self.ws_names[i]}" mon="{self.monitors[mon_idx]}"')

        for cmd in cmds:
            self.run_cmd(cmd)

    def setup_general_rules(self):
        """Configure system settings."""
        settings = [
            'dkcmd set {focus_open,tile_tohead}=true',
            'dkcmd set {focus_{mouse,urgent},obey_motif,tile_hints,smart_{border,gap}}=false',
            'dkcmd set win_{minwh,minxy}=50',
            'dkcmd set mouse mod=super move=button1 resize=button2',
            'dkcmd set border width=2 outer_width=1',
            f'dkcmd set border colour {{focus,outer_focus}}="{self.colors["blue"]}" {{urgent,outer_urgent}}="{self.colors["red"]}" {{unfocus,outer_unfocus}}="{self.colors["black"]}"'
        ]

        for cmd in settings:
            self.run_cmd(cmd)

    def setup_apps_rules(self):
        """Configure window rules."""
        self.run_cmd('dkcmd rule remove "*"')

        # Apply floating rules
        for app in self.floating_apps:
            self.run_cmd(f'dkcmd rule class="^{app}$" focus=true float=true')

        # Application workspace assignments
        rules = {
            2: ['Brave-browser', 'Chromium'],
            3: ['file-roller', 'filezilla'],
            4: ['code', 'Cursor', 'Geany', 'com.lite_xl.LiteXL'],
            5: ['virt-manager', 'VirtualBox', 'Org.gnome.Boxes'],
            6: ['feh', 'Zathura'],
            8: ['Thunar', 'transmission-gtk', 'Worker'],
            9: ['obs', 'SimpleScreenRecorder', 'vokoscreenNG']
        }

        # Special cases
        self.run_cmd('dkcmd rule class="^mpv$" instance="^mpvk$" ws=5 focus=true')

        for ws, patterns in rules.items():
            for pattern in patterns:
                self.run_cmd(f'dkcmd rule class="^{pattern}$" ws={ws} focus=true')

        # Terminal and special rules
        special_rules = [
            'dkcmd rule class="^(URxvt|xterm|xterm-256color|Alacritty)$" terminal=true',
            'dkcmd rule class="^Org.gnome.five-or-more$" focus=true float=true w=434 h=488',
            'dkcmd rule class="^URxvt$" instance="^(bashterm|mpm)$" focus=true float=true w=1260 h=738',
            'dkcmd rule class="^hu.irl.cameractrls$" instance="^python3.13$" focus=true float=true w=320 h=180',
            'dkcmd rule class="^Screenkey$" ignore_cfg=true ignore_msg=true',
            'dkcmd rule instance="^(aur-cli|Browser|cal|floaterm|pacman-cli|somabox)$" focus=true float=true',
            'dkcmd rule title="^Event Tester$" no_absorb=true'
        ]

        for rule in special_rules:
            self.run_cmd(rule)

        # Wait for socket and apply socat rules
        MAX_WAIT_TIME = 30  # seconds
        start_time = time.time()
        while not self.dksock:
            if time.time() - start_time > MAX_WAIT_TIME:
                logger.error("Timeout waiting for dk socket")
                break
            socks = self.run_cmd('ls /tmp')
            if socks:
                for line in socks.stdout.split('\n'):
                    if 'dk__' in line:
                        self.dksock = f'/tmp/{line.strip()}'
                        logger.info(f"Found dk socket: {self.dksock}")
                        break
            time.sleep(0.5)

        socat_rules = [
            'rule class="^URxvt$" instance="^(cmus|ncmpcpp|pulsemixer|ripper)$" ws=1 focus=true',
            'rule class="^URxvt$" instance="^(btop|htop|jnettop|newboat)$" ws=7 focus=true',
            'rule class="^URxvt$" instance="^(ranger|sudoranger)$" ws=8 focus=true'
        ]

        for rule in socat_rules:
            self.run_cmd(None, input_str=rule)

        self.run_cmd('dkcmd rule apply "*"')

    def generate_status(self):
        """Generate status JSON files."""
        for type_name in ['full', 'ws']:
            try:
                # Create the status command process
                status_proc = subprocess.Popen(
                    ['dkcmd', 'status', f'type={type_name}', 'num=1'],
                    stdout=subprocess.PIPE,
                    text=True
                )
                # Pipe its output through dkcmd -p
                format_proc = subprocess.Popen(
                    ['dkcmd', '-p'],
                    stdin=status_proc.stdout,
                    stdout=subprocess.PIPE,
                    text=True
                )
                # Close the first pipe to avoid deadlocks
                status_proc.stdout.close()
                # Get the formatted output
                formatted_output = format_proc.communicate()[0]
                if formatted_output:
                    with open(self.config_dir / f'dk_{type_name}.json', 'w') as f:
                        f.write(formatted_output)
            except Exception as e:
                print(f"Failed to generate {type_name} status: {e}")

    def start_scripts(self) -> None:
        """Start additional scripts."""
        scripts = ['polybar_start', 'autostart', 'sxhkd_start']
        for script in scripts:
            if script != 'autostart' or not (self.runtime_dir / 'combined.list').exists():
                try:
                    subprocess.Popen([str(script)])
                    logger.info(f"Script {script} started successfully")
                except Exception as e:
                    logger.error(f"Failed to start script {script}: {e}")

    def run(self):
        """Main configuration routine."""
        self.load_configs()
        self.setup_workspaces()
        self.setup_general_rules()
        self.run_cmd('dkcmd ws view 4')
        self.setup_apps_rules()
        self.generate_status()
        self.start_scripts()

if __name__ == '__main__':
    DKConfig().run()
