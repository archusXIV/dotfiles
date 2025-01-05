# Ivaylo Kuzev <ivkuzev@gmail.com>, 2014
# Xresources like colorscheme for https://github.com/hut/ranger.
# Use the 16 colors of your ~/.Xresources file.
# Copyright (C) 2009-2013  Roman Zimbelmann <hut@lepus.uberspace.de>
# This software is distributed under the terms of the GNU GPL version 3.

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default_colors, reverse, bold, normal, default


# pylint: disable=too-many-branches,too-many-statements
class Xresources(ColorScheme):
    progress_bar_color = 1

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                fg = 7
                bg = 8
            if context.border:
                fg = 7
            if context.image:
                fg = 3
            if context.video:
                fg = 6
            if context.audio:
                fg = 9
            if context.document:
                fg = 12
            if context.container:
                attr |= bold
                fg = 7
            if context.directory:
                attr |= bold
                fg = 10
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                attr |= bold
                fg = 2
            if context.socket:
                fg = 13
                attr |= bold
            if context.fifo or context.device:
                fg = 9
                if context.device:
                    attr |= bold
            if context.link:
                fg = 10 if context.good else 2
                bg = 8
            if context.bad:
                bg = 1
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (7, 11):
                    fg = 7
                else:
                    fg = 11
            if not context.selected and (context.cut or context.copied):
                fg = 2
                bg = 8
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 3
            if context.badinfo:
                if attr & reverse:
                    bg = 6
                else:
                    fg = 6

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 13 if context.bad else 6
            elif context.directory:
                fg = 3
            elif context.tab:
                if context.good:
                    bg = 8
            elif context.link:
                fg = 13

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 7
                elif context.bad:
                    fg = 13
            if context.marked:
                attr |= bold | reverse
                fg = 3
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 13
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 2
                attr &= ~bold
            if context.vcscommit:
                fg = 2
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 2

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 5
            elif context.vcschanged:
                fg = 13
            elif context.vcsunknown:
                fg = 13
            elif context.vcsstaged:
                fg = 2
            elif context.vcssync:
                fg = 2
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync:
                fg = 2
            elif context.vcsbehind:
                fg = 13
            elif context.vcsahead:
                fg = 5
            elif context.vcsdiverged:
                fg = 5
            elif context.vcsunknown:
                fg = 13

        return fg, bg, attr
