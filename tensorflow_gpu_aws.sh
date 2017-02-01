#! /usr/bin/env bash

#########
## You may want to run the script step by step
#########

echo "Installation begins"


CUDNN_URL=

# Request for cuDNN URL if it doesn't exist
if [ -z "$CUDNN_URL" ]; then
    echo "Enter URL to download cuDNN from: "
    read CUDNN_URL
    echo "cuDNN will be downloaded from: $CUDNN_URL"
fi

# Install dependencies
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y build-essential git python-pip libfreetype6-dev libxft-dev libncurses-dev libopenblas-dev gfortran python-matplotlib libblas-dev liblapack-dev libatlas-base-dev python-dev python-pydot linux-headers-generic linux-image-extra-virtual unzip python-numpy swig python-pandas python-sklearn zip
sudo pip install -U pip

# Install CUDA
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1410/x86_64/cuda-repo-ubuntu1410_7.0-28_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1410_7.0-28_amd64.deb
rm cuda-repo-ubuntu1410_7.0-28_amd64.deb
sudo apt-get update
sudo apt-get install -y cuda

# Install cuDNN
wget $CUDNN_URL
tar -zxf cudnn-7.0-linux-x64-v4.0-prod.tgz && rm cudnn-7.0-linux-x64-v4.0-prod.tgz
sudo cp cuda/lib64/* /usr/local/cuda/lib64/
sudo cp cuda/include/cudnn.h /usr/local/cuda/include/

# Add environmental variables
echo >> .bashrc
echo "export CUDA_HOME=/usr/local/cuda" >> .bashrc
echo "export CUDA_ROOT=/usr/local/cuda" >> .bashrc
echo "export PATH=$PATH:/usr/local/cuda/bin:$HOME/bin" >> .bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64" >> .bashrc

# Install Java for Bazel
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
# Hack to silently agree license agreement
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer

# Install Bazel
sudo apt-get install pkg-config zip g++ zlib1g-dev unzip
wget https://github.com/bazelbuild/bazel/releases/download/0.2.3/bazel-0.2.3-installer-linux-x86_64.sh
chmod +x bazel-0.2.3-installer-linux-x86_64.sh
./bazel-0.2.3-installer-linux-x86_64.sh --user
rm bazel-0.2.3-installer-linux-x86_64.sh

# Clone tensorflow repo
git clone --recurse-submodules https://github.com/tensorflow/tensorflow

# Switch to tensorflow directory
cd tensorflow

# Running tensorflow configuration
echo "Set Cuda compute capability to 3.0 (Default is 3.5,5.2)"
echo "Use default values for all other parameters"
TF_UNOFFICIAL_SETTING=1 ./configure

# Build tensorflow
bazel build -c opt --config=cuda //tensorflow/cc:tutorials_example_trainer
bazel build -c opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
sudo pip install --upgrade /tmp/tensorflow_pkg/*.whl


echo "Installation completed"
