#! /bin/bash -eu

# Copyright (C) 2014 mru@sisyphus.teil.cc

# called by the gps_watch_monitor.py when the watch is connected.
# starts the watch client to import new tracks, starts mytourbook


# to customize this script, 
# copy it to ~/.gps_watch_onconnect.sh and modify it to suit your needs.


serial_device=$1
tb=~/opt/tourbook/mytourbook/mytourbook


destdir=$HOME/Documents/TcxTracks
mkdir -p $destdir
cd $destdir

trap '{
echo "failed to receive watch data";
}' ERR

sleep 1

echo "importing data"

crane_gps_watch_client --device $serial_device --verbose

# if mytourbook is not started, start it
if [[ -z "$(pgrep -f $tb)" ]]; then
  echo "starting $tb"
  nohup $tb &
else
  # else bring it to front
  wmctrl -a $(basename $tb) || true
fi

echo "completed"
