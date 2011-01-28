#!/bin/bash

$HOME/.bin/todo.sh view context | sed -n '/\-\-\-  anywhere\|pc\|office\|call\|wait  \-\-\-/,/^$/p' > $HOME/todo.txt
