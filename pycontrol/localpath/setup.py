#!/usr/bin/env python3

from setuptools import setup

setup(name='Localpath',
      version='0.1',
      description='Add local packages to path',
      author='Jurģis Brigmanis',
      author_email='velko.x@gmail.com',
      packages=['localpath'],
      package_dir={'localpath': '.'}
     )
