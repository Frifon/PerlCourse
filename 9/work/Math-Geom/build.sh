#!/bin/sh
perl Makefile.PL && make && echo 'READY' && time perl -Iblib/lib -Iblib/arch main.pl