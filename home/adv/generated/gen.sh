#!/usr/bin/bash
base=$(dirname "$0")

echo "Generating dependencies... (this should take a few seconds)"
adv gen class_number -n 100 -o "${base}/class_number.adv"
adv gen array -n 8 -o "${base}/array.adv"
