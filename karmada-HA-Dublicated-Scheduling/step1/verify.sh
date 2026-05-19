#!/bin/bash
set -e

# Verify node01 is reachable
ssh -o StrictHostKeyChecking=no root@172.30.2.2 "echo node01 ready"
