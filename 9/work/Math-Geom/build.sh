#!/bin/sh
perl Makefile.PL && make && echo 'READY' && perl5.18 -Iblib/lib -Iblib/arch main.pl