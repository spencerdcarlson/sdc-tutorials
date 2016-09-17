# Make sure you have the latest version of GNU Not Unix! Privacy Guard (GPG) installed
# https://www.gnupg.org/download/index.en.html

bob@host ~ $ gpg --version
# gpg (GnuPG) 1.4.20

bob@host ~ $ gpg --gen-key
# Please select what kind of key you want:
#   (1) RSA and RSA (default)
#   (2) DSA and Elgamal
#   (3) DSA (sign only)
#   (4) RSA (sign only)
# Your selection? 1

# enter for default size (2048)
# Key is valid for? (0) 1y
# y to confirm
# Real name: "Bob Marley"
# Email address: bob@gmail.com
# Comment: 
# Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
# Enter passphrase: mrbobman
# Repeat passphrase: mrbobman
# wait ...

# after your keys are generated, you can see that they are stored in your 
# keyrings
bob@host ~ $ gpg --list-keys
# /home/bob/.gnupg/pubring.gpg
# ----------------------------
# pub   2048R/D89AD723 2016-09-17 [expires: 2017-09-17]
# uid                  "Bob Marley" <bob@gmail.com>
# sub   2048R/C60639C2 2016-09-17 [expires: 2017-09-17]

# you can also display the full user id
# helpful when possible id collisions
bob@host ~ $ gpg --list-keys --keyid-format LONG

# create a second user
bob@host ~ $ sudo adduser alice
# Adding user `alice' ...
# Adding new group `alice' (1001) ...
# Adding new user `alice' (1001) with group `alice' ...
# Creating home directory `/home/alice' ...
# Copying files from `/etc/skel' ...
# Enter new UNIX password: mrsalice
# Retype new UNIX password: mrsalice
# passwd: password updated successfully
# Changing the user information for alice
# Enter the new value, or press ENTER for the default
#	Full Name []: Alice
#	Room Number []: 
#	Work Phone []: 
#	Home Phone []: 
#	Other []: 
# Is the information correct? [Y/n] y

# add alice to sudo group
bob@host ~ $ sudo adduser alice sudo
# [sudo] password for bob: mrbobman
# Adding user `alice' to group `sudo' ...
# Adding user alice to group sudo
# Done.

# change users to alice
bob@host ~ $ su alice
# Password: mrsalice
alice@host /home/bob $ cd ~/

# change directories to alice's home directory
alice@host ~ $ 

# vierify that alice does not have any keys
alice@host ~ $ gpg --list-keys
# gpg: directory `/home/alice/.gnupg' created
# gpg: new configuration file `/home/alice/.gnupg/gpg.conf' created
# gpg: WARNING: options in `/home/alice/.gnupg/gpg.conf' are not yet active during this run
# gpg: keyring `/home/alice/.gnupg/pubring.gpg' created
# gpg: /home/alice/.gnupg/trustdb.gpg: trustdb created

# You can see that alic has no keys, when we try and list them, the keyring database gets created

# generate keys for alice, flow the same steps we did for bob, but make up information for Alice
alice@host ~ $ gpg --gen-key
# ... see bob's q & a
# Real name: "Alice Liddell"
# Email address: alice@gmail.com

# list Alie's keys
alice@host ~ $ gpg --list-keys
# /home/alice/.gnupg/pubring.gpg
# ------------------------------
# pub   2048R/268E5500 2016-09-17 [expires: 2017-09-17]
# uid                  "Alice Liddell" <alice@gmail.com>
# sub   2048R/9C1C4C83 2016-09-17 [expires: 2017-09-17]

# lets make bob & alice friends by sharing and trusting each other's PUBLIC keys
alice@host ~ $ exit # switch back to bob
# export your key in ASCII format to a file
bob@host ~ $ gpg --export -a "Bob Marley" > bob-marley.key
bob@host ~ $ gpg --export -a bob > bob-marley.key # you can use bob's first name
# NOTE: you can use the abbreviated id or full length id when identifying a user
bob@host ~ $ gpg --export -a D89AD723 > bob-marley.key
bob@host ~ $ gpg --export -a C7D8DB93D89AD723 > bob-marley.key
# copy Bob's public key to Alice's home directory
bob@host ~ $ sudo cp bob-marley.key /home/alice/
# switch users to alice
bob@host ~ $ su alice
# Password: mrsalice
alice@host /home/bob $ cd ~/ # change directoies to alice's home directory
# import Bob's public key into Alice's keyring
alice@host ~ $ gpg --import bob-marley.key 
# gpg: key D89AD723: public key ""Bob Marley" <bob@gmail.com>" imported
# gpg: Total number processed: 1
# gpg:               imported: 1  (RSA: 1)

# we can now see Bob's key in Alice's keyring
alice@host ~ $ gpg --list-keys
# /home/alice/.gnupg/pubring.gpg
# ------------------------------
# pub   2048R/268E5500 2016-09-17 [expires: 2017-09-17]
# uid                  "Alice Liddell" <alice@gmail.com>
# sub   2048R/9C1C4C83 2016-09-17 [expires: 2017-09-17]

# pub   2048R/D89AD723 2016-09-17 [expires: 2017-09-17]
# uid                  "Bob Marley" <bob@gmail.com>
# sub   2048R/C60639C2 2016-09-17 [expires: 2017-09-17]

# tell Alice to trust Bob's key
alice@host ~ $ gpg --edit-key "Bob Marley"
gpg> trust
# Please decide how far you trust this user to correctly verify other users' keys
# (by looking at passports, checking fingerprints from different sources, etc.)

#  1 = I don't know or won't say
#  2 = I do NOT trust
#  3 = I trust marginally
#  4 = I trust fully
#  5 = I trust ultimately
#  m = back to the main menu

Your decision? 5
## verify that the trust level is edited
gpg> quit

# export Alice's public key (ASCII) and share it with Bob
alice@host ~ $ gpg --export -a alice > alice-liddell.key  # export Alice's public key to a file
alice@host ~ $ sudo cp alice-liddell.key /home/bob/       # copy Alice's public key to Bob's home directory
# [sudo] password for alice: mrsalice

# switch to user Bob and import Alice's public key
alice@host ~ $ exit
bob@host ~ $ gpg --import alice-liddell.key 
# gpg: key 268E5500: public key ""Alice Liddell" <alice@gmail.com>" imported
# gpg: Total number processed: 1
# gpg:               imported: 1  (RSA: 1)

# Tell Bob to turst Alice
bob@host ~ $ gpg --edit-key alice
gpg> trust
# ...
Your decision? 5 
gpg> quit

# Bob & Alice can now recieve encrypted messages from one another
# let's send Alice a message from bob that is encrypted and signed by Bob
bob@host ~ $ echo "Hello Alice. Have you ever been down a rabbit hole?" > msg.txt

bob@host ~ $ gpg -esr alice msg.txt
# You need a passphrase to unlock the secret key for
# user: ""Bob Marley" <bob@gmail.com>"
# 2048-bit RSA key, ID D89AD723, created 2016-09-17

# You are prompted for Bob's password becuase the message is going to be encrypted with Bob's priavte key.
# priavte keys must be protected, thefore a password is required even to use them for encryption.
# never share your private key with anyone. -- Ever

# if you didn't edit the trust attribute of Alice's key, then you would get a warning.

# You can now see msg.txt.gpg which, has a different size than the msg.txt file
# msg.txt.gpg is encrypted and signed by Bob. 
bob@host ~ $ ls -ltr
# total 48
# drwxr-xr-x 2 bob  bob  4096 Sep 16 19:00 Videos
# ...
# -rw-r--r-- 1 bob  bob  1710 Sep 16 23:47 bob-marley.key
# -rw-r--r-- 1 root root 1718 Sep 17 00:42 alice-liddell.key
# -rw-r--r-- 1 bob  bob    52 Sep 17 01:10 msg.txt
# -rw-r--r-- 1 bob  bob   697 Sep 17 01:11 msg.txt.gpg

# send the message to alice
bob@host ~ $ sudo cp msg.txt.gpg /home/alice
# [sudo] password for bob: mrbobman

# Switch to Alice and decrypt the message
bob@host ~ $ su alice
# Password: mrsalice
alice@host /home/bob $ cd ~/ # switch to Alice's home directory

# try and read the encrypted message
alice@host ~ $ less msg.txt.gpg 
# "msg.txt.gpg" may be a binary file.  See it anyway? y
# ... garbage

# decrypt the message, verify that it came form bob, and prove that I am Alice, which allows me to decrypt it.
alice@host ~ $ gpg msg.txt.gpg 

# You need a passphrase to unlock the secret key for
# user: ""Alice Liddell" <alice@gmail.com>"
# 2048-bit RSA key, ID 9C1C4C83, created 2016-09-17 (main key ID 268E5500)
# Enter passphrase: mrsalice

# msg.txt file is created
# Read the file
alice@host ~ $ less msg.txt
# Hello Alice. Have you ever been down a rabbit hole?

# Anoter usefule tool is to sign a file, which you don't need to encrypt
# this is a common pracitce used when distributing software. 
# 1.) create a checksum file
# 2.) sign the checksum file
# 3.) distribute both the software and the checksum file
# Reciepents if the checksum verification passes, then recipeinets can verify that your software has not been modified 
# if the checksum file is singed by you, then recpients know it is from you.

# create some software (a txt file) as Alice
alice@host ~ $ echo "This file was created by Alice Liddell" > alice-author.txt
# pacakge your appliction into a compressed file 
alice@host ~ $ tar -czvf alice-author.txt.tar.gz alice-author.txt
# create a checksum digest of the previous file.
alice@host ~ $ shasum -a 256 alice-author.txt.tar.gz > SHA256SUM
# sign, but do not encrypt the checksum file
alice@host ~ $ gpg --clearsign -a SHA256SUM
# SHA256SUM.asc file is created. .asc is append for ASCII file
# Send the software and checksum files to Bob
alice@host ~ $ sudo cp ~/{alice-author.txt.tar.gz,SHA256SUM.asc} /home/bob/
# [sudo] password for alice: mrsalice
# switch back to Bob
alice@host ~ $ exit

# verify that the checksum comes from Alice
bob@host ~ $ gpg --verify SHA256SUM.asc 
# gpg: Signature made Sat 17 Sep 2016 01:51:00 AM HST using RSA key ID 268E5500
# gpg: Good signature from ""Alice Liddell" <alice@gmail.com>"

# Verify the tar.gz file against the checksum file
bob@host ~ $ shasum -c SHA256SUM.asc # Note, SHA256SUM.asc file and alice-author.txt.tar.gz files must be in the same directory
# alice-author.txt.tar.gz: OK

# inore the waring
# shasum: WARNING: 14 lines are improperly formatted 
# this is because of the signature that was added to the file

# we now know that alice created the checksum file 
# and that and that lice-author.txt.tar.gz has not been altered by anyone 
# after alice created the checksum digest file

# it is safe to un zip the file and install
bob@host ~ $ tar -xzvf alice-author.txt.tar.gz
# alice-author.txt
# read the file
bob@host ~ $ cat alice-author.txt