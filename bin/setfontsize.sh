#!/bin/bash

printf '\33]50;%s\007' "xft:terminus-font:size=${1:-10}"
