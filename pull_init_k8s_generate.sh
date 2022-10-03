#!/bin/sh
git clone https://github.com/EscolaLMS/Create-LMS-App.git EscolaLMS 
cd EscolaLMS 
rm -rf .git
make k8s-generate-yaml
echo "Check k8s folder for your generated *.yaml files.";
echo "Run k8b with command 'kubectl apply -f k8s' ."
