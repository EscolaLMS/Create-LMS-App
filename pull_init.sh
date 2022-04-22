#!/bin/sh
git clone https://github.com/EscolaLMS/Create-LMS-App.git EscolaLMS 
cd EscolaLMS 
#rm -rf .git
#./init.sh
make init 
make success