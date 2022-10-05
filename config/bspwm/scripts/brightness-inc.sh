#!/bin/bash

level=$(xbacklight -get) 

if [ $level -lt 100 ]
then
	xbacklight -inc 5
	
fi


