#!/bin/bash

mv sunrise-sunset-times.txt sunrise-sunset-times.old
echo "Moving previous version and creating new sunrise-sunset-times.txt file"
python sunrise_sunset.py 2023 2024 >> sunrise-sunset-times-scratch.txt
#echo "Sorting and removing duplicates"
awk '!seen[$0]++' sunrise-sunset-times-scratch.txt > sunrise-sunset-times.txt
rm sunrise-sunset-times-scratch.txt
echo "Done"
