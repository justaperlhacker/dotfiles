#!/usr/bin/env bash

BG='#1d2021'
TEXT='#ebdbb2'
RING='#d65d0e'
WRONG='#cc241d'
VERIFY='#98971a'
KEYHL='#458588'
BSHL='#cc241d'

i3lock \
  --insidever-color=$BG     \
  --ringver-color=$VERIFY   \
  --insidewrong-color=$BG   \
  --ringwrong-color=$WRONG  \
  --inside-color=$BG        \
  --ring-color=$RING        \
  --line-color=$BG          \
  --separator-color=$RING   \
  --verif-color=$TEXT       \
  --wrong-color=$WRONG      \
  --time-color=$TEXT        \
  --date-color=$TEXT        \
  --layout-color=$TEXT      \
  --keyhl-color=$KEYHL      \
  --bshl-color=$BSHL        \
  --screen 1                \
  --blur 10                 \
  --clock                   \
  --indicator               \
  --radius=120              \
  --ring-width=15           \
  --time-str="%H:%M:%S"     \
  --date-str="%Y-%m-%d"
