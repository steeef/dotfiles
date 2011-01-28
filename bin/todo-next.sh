#!/bin/bash

$HOME/.bin/todo.sh view context | sed -n '/\-\-\-  anywhere\|pc\|office\|call\|wait|2nd_floor  \-\-\-/,/^$/p' > $HOME/todo.txt
