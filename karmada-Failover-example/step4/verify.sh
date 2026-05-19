#!/bin/bash
set -e

clusters=$(ssh -o StrictHostKeyChecking=no root@172.30.2.2 "kind get clusters")
echo "$clusters" | grep -x member1
echo "$clusters" | grep -x member2