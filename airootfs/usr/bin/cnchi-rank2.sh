#!/bin/bash
if  (tail -F -n1 /tmp/cnchi.log &) | grep -q "Auto mirror selection has been run successfully"
then
echo "Done! Closing out of Cnchi's "Ranking Mirrors" popup box..."
else
sudo cnchi-rank2.sh
fi
