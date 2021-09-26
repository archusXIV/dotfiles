#!/usr/bin/env python

import imaplib
obj = imaplib.IMAP4_SSL('IMAP_SERVER_NAME',993)
obj.login('USERNAME','PASSWORD')
obj.select()
print(len(obj.search(None, 'UnSeen')[1][0].split()))
