# Install environment for Adjoint-enhanced LESGO


SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

## Install environment modules
sudo apt-get update
sudo apt-get install environment-modules

## Install GCC-14.2.0
sudo apt install build-essential
sudo apt install libmpfr-dev libgmp3-dev libmpc-dev -y
sudo apt-get install flex

cd ~/Downloads
wget http://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz
tar -xf gcc-14.2.0.tar.gz
cd gcc-14.2.0
./configure -v --prefix=/opt/gcc-14.2.0 --enable-languages=c,c++,fortran --disable-multilib
make -j16
sudo make install

sudo ln -s /opt/gcc-14.2.0 /opt/gcc-14

sudo mkdir -p /usr/local/Modules/modulefiles/gcc
sudo cp ${SCRIPTPATH}/modulefiles/gcc-14.2.0 /usr/local/Modules/modulefiles/gcc/14.2.0


## Install OPENMPI
## Download [Open-MPI](https://www.open-mpi.org/software/ompi/v4.1/) and install following the [guidance](https://www.open-mpi.org/faq/?category=building).
cd ~/Downloads
wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.5.tar.gz
tar -xf openmpi-5.0.5.tar.gz
cd openmpi-5.0.5

./configure --prefix=/opt/openmpi-5.0.5/GCC-14.2.0 2>&1 | tee config.out
## ./configure --prefix=/usr/local/openmpi-4.1.5/9.3.0 --with-cuda=/usr/local/cuda-11.8
make -j16 all 2>&1 | tee make.out
sudo make install 2>&1 | tee install.out


sudo mkdir -p /usr/local/Modules/modulefiles/openmpi/gcc-14
sudo cp ${SCRIPTPATH}/modulefiles/openmpi-5.0.5 /usr/local/Modules/modulefiles/openmpi/gcc-14/5.0.5

## Install FFTW
cd ~/Downloads
wget https://www.fftw.org/fftw-3.3.10.tar.gz
tar -xf fftw-3.3.10.tar.gz
cd cd fftw-3.3.10


## First load OPENMPI and GCC to compile FFTW
module load openmpi

## Compile
./configure --prefix=/opt/fftw/OPENMPI-5-GCC-14 --enable-mpi
make
make install


sudo mkdir -p /usr/local/Modules/modulefiles/fftw/OPENMPI-5-GCC-14
sudo cp ${SCRIPTPATH}/modulefiles/fftw-3.3.10 /usr/local/Modules/modulefiles/fftw/OPENMPI-5-GCC-14/3.3.10