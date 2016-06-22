#!/bin/bash
#Program:
#	This program generate SHA512 password values
# 2016/06/07 Shujin Wu

#pip install passlib
python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"

