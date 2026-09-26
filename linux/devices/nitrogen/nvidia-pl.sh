#!/bin/bash
# Set 70% power limit for nvidia GPU
#Enable persistence mode
sudo nvidia-smi -pm ENABLED
sudo nvidia-smi -pl 315
