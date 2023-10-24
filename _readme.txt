
-- Starting your MSc:

Ask Professor Jose Gaspar to create a GIT repository


-- Create an MSc folder in your PC (suggestions for Windows OS):

mkdir c:\msc
mkdir c:\msc\GIT
mkdir c:\msc\matlab.my

Install TortoiseGIT and "checkout" your repository into c:\msc\GIT\.
(See next how to install "matlab.my")

Your GIT contains default folders:
c:\msc\GIT\refs		folder containing papers and other references (PDF)
c:\msc\GIT\sw		folder to contain software packages, others and yours
c:\msc\GIT\sw_tst	tests and experiments based on the sw packages
c:\msc\GIT\data		datasets to use
c:\msc\GIT\tex		documentation to develop (latex), i.e. reports and the thesis


-- Download and install Matlab utils on your PC (folder "matlab.my")

Start by installing TortoiseSVN. See install details in:
http://users.isr.ist.utl.pt/~jag/software/matlab_my.htm

Function "addpathx.m" gets available after installing "matlab.my".
In Matlab, goto to the "matlab.my" root folder and type:
	>> mtlmyini( 'install' )

You can install also "matlab.extras". It is recomended but not mandatory.

After installing "matlab.my" you can install automatically your MSc GIT folder:
	>> mtlmyini( 'install_this_folder' )
which places information into "matlab.my\mtlmyini_path.m".

