#!/bin/bash
echo "=== Port Check ==="
ss -tlnp | grep LISTEN
echo "=================="
