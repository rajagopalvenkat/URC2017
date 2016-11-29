sudo apt-get install subversion
sudo apt-get install libv4l-dev
sudo apt-get install libjpeg8-dev
sudo apt-get install imagemagick
svn co https://svn.code.sf.net/p/mjpg-streamer/code/
cd mjpg-streamer/mjpg-streamer
make USE_LIBV4L2=true clean all
make DESTDIR=/usr install
