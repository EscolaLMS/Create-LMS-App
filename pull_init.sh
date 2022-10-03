#!/bin/sh
git clone https://github.com/EscolaLMS/Create-LMS-App.git EscolaLMS 
cd EscolaLMS 
rm -rf .git
if $(nc -z -v -w5 localhost 80  2>&1 | grep -q 'succeeded'); then echo "Port 80 is not free. Exiting. ";exit 1; else echo "Port 80 is free"; fi;
make init 
make success
