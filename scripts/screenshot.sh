#!/bin/env bash
# copy part of the screen into the system clipboard
# Needs: grim slurp wl-copy
# (by egnrse)

grim -g "$(slurp)" - | wl-copy
