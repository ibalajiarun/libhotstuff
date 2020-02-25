#!/usr/bin/env bash
set -euxo pipefail

curl -X POST ssrg:5060/register -d "instance=$POD_NAME&ip=$POD_IP" > raw_config.txt

head -n$(($(grep -n '\---' raw_config.txt | cut -f1 -d:)-1)) raw_config.txt > hotstuff.conf
tail -n+$(($(grep -n '\---' raw_config.txt | cut -f1 -d:)+1)) raw_config.txt > hotstuff-sec.conf