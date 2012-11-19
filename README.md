dan_test_dev_as_user
====================

## Description

Same as dan_test_dev -- Run it as a user instead of admin

## Procedure

As a user,

1. Get the list of amis using ec2-describe-images, choose a random one
2. Get the list of keypairs using ec2-describe-keypairs, choose a random one
3. Get the list of address for admin account using ec2-describe-addresses, choose a random one
4. Get the list of groups using ec2-describe-groups, choose a random one
5. Run this instance and check that the ec2-run-instances returns the instance information
6. Gather all info about Instances and add them to a arrays if they are pending or running
7. If the network is managed then check the addresses and add them to arrays containing the IPs, and grab a random IP and instance ID
8. Check that the instance with the ID from step 2 has an exising IP other than blank or 0.0.0.0
9. Disassociate the address with the ec2-disassociate-address command
10. Associate the random address from step 2 with the instance with ID from step 2
11. Login to each instance using the appropriate keys and run a command (ifconfig)
12. If the instances dont return properly after 100 tries then use euca-get-console-output to deterimine the proper error



# Eucalyptus Testunit Framework

Eucalyptus Testunit Framework is designed to run a list of test scripts written by Eucalyptus developers.



## How to Set Up Testunit Environment

On **Ubuntu** Linux Distribution,

### 1. UPDATE THE IMAGE

<code>
apt-get -y update
</code>

### 2. BE SURE THAT THE CLOCK IS IN SYNC

<code>
apt-get -y install ntp
</code>

<code>
date
</code>

### 3. INSTALL DEPENDENCIES
<note>
YOUR TESTUNIT **MIGHT NOT** NEED ALL THE PACKAGES BELOW; CHECK THE TESTUNIT DESCRIPTION.
</note>

<code>
apt-get -y install git-core bzr gcc make ruby libopenssl-ruby curl rubygems swig help2man libssl-dev python-dev libright-aws-ruby nfs-common openjdk-6-jdk zip libdigest-hmac-perl libio-pty-perl libnet-ssh-perl euca2ools
</code>

### 4. CLONE test_share DIRECTORY FOR TESTUNIT
<note>
YOUR TESTUNIT **MIGHT NOT** NEED test_share DIRECTORY. CHECK THE TESTUNIT DESCRIPTION.
</note>

<code>
git clone git://github.com/eucalyptus-qa/test_share.git
</code>

### 4.1. CREATE /home/test-server/test_share DIRECTORY AND LINK IT TO THE CLONED test_share

<code>
mkdir -p /home/test-server
</code>

<code>
ln -s ~/test_share/ /home/test-server/.
</code>

### 5. CLONE TESTUNIT OF YOUR CHOICE

<code>
git clone git://github.com/eucalyptus-qa/**testunit_of_your_choice**
</code>

### 6. CHANGE DIRECTORY

<code>
cd ./**testunit_of_your_choice**
</code>

### 7. CREATE 2b_tested.lst FILE in ./input DIRECTORY

<code>
vim ./input/2b_tested.lst
</code>

### 7.1. TEMPLATE OF 2b_tested.lst, SEPARATED BY TAB

<sample>
192.168.51.85	CENTOS	6.3	64	REPO	[CC00 UI CLC SC00 WS]

192.168.51.86	CENTOS	6.3	64	REPO	[NC00]
</sample>

### 7.2. BE SURE THAT YOUR MACHINE's id_rsa.pub KEY IS INCLUDED THE CLC's authorized_keys LIST

ON **YOUR TEST MACHINE**:

<code>
cat ~/.ssh/id_rsa.pub
</code>

ON **CLC MACHINE**:

<code>
vim ~/.ssh/authorized_keys
</code>

### 8. RUN THE TEST

<code>
./run_test.pl **testunit_of_your_choice.conf**
</code>


## How to Examine the Test Result

### 1. GO TO THE artifacts DIRECTORY

<code>
cd ./artifacts
</code>

### 2. CHECK OUT THE RESULT FILES

<code>
ls -l
</code>


## How to Rerun the Testunit

### 1. CLEAN UP THE ARTIFACTS

<code>
./cleanup_test.pl
</code>

### 2. RERUN THE TEST

<code>
./run_test.pl **testunit_of_your_choice.conf**
</code>


