#!/bin/bash
kubectl delete all --all -n escolalms
kubectl apply -f .    