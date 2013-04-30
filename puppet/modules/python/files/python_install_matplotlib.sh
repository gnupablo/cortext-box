#!/bin/sh
#install matplotlib
cd /home/vagrant
git clone git://github.com/matplotlib/matplotlib.git
cd matplotlib
python setup.py install