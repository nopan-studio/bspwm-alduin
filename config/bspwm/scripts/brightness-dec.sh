#!/bin/bash

level=$(xbacklight -get) 

if [ $level -gt 10 ]
then
	xbacklight -dec 10
	
fi


