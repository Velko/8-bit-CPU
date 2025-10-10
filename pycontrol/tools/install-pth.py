#!/usr/bin/env python3

import os, site

libpath = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sitepath = site.getusersitepackages()
pthfile = os.path.join(sitepath, "8-bit-CPU.pth")

print (f"echo {libpath} > {pthfile}" )

if not os.path.exists(sitepath):
    os.makedirs(sitepath)

with open(pthfile, "w") as f:
    f.write(libpath + "\n")
