#!/bin/bash
xattr -r -d com.apple.quarantine "$1"
