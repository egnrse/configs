#!/bin/env bash
# copy part of the screen into the system clipboard
# (by egnrse)

grim -g "$(slurp)" - | wl-copy
