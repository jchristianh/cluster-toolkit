#!/bin/bash

watch -t -n .3 'uptime;echo;kubectl get nodes;echo;kubectl get pods --all-namespaces'
