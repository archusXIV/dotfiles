#!/usr/bin/env python3
"""Fix malformed JSON from dkcmd by escaping embedded control characters."""
import sys, json, re

raw = sys.stdin.read()

# Escape newlines, tabs, carriage returns inside quoted strings
def escape_controls(match):
    s = match.group(1)
    s = s.replace('\n', '\\n').replace('\r', '\\r').replace('\t', '\\t')
    return '"' + s + '"'

cleaned = re.sub(r'"([^"]*)"', escape_controls, raw)
data = json.loads(cleaned)
print(json.dumps(data, indent=2))
