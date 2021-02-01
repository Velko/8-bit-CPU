import sys, os.path

# Adds local paths for library search from localpath.conf
#
# The config file should be in the same directory as script
# and contain relative paths from it

# To use, install this package somewhere in existing
# Python path


conf_file = os.path.join(sys.path[0], "localpath.conf")

if os.path.exists(conf_file):
    for line in open(conf_file, "r"):
        sys.path.append(os.path.join(sys.path[0], line.strip()))
