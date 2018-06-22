#!/usr/bin/env bash

echo  $(( $(checkupdates | wc -l) + $(aurman -Qu | wc -l) ))
