# Executes "https://grpc.io/docs/languages/cpp/quickstart/" quick start.

export MY_INSTALL_DIR=$HOME/.local;
mkdir -p $MY_INSTALL_DIR;
export PATH="$MY_INSTALL_DIR/bin:$PATH";

wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3-linux-x86_64.sh;
sh cmake-linux.sh -- --skip-license --prefix=$MY_INSTALL_DIR;
rm cmake-linux.sh;

sudo apt install -y build-essential autoconf libtool pkg-config

cd ../;

git clone --recurse-submodules -b v1.62.0 --depth 1 --shallow-submodules https://github.com/grpc/grpc;

cd grpc;
mkdir -p cmake/build;
pushd cmake/build;
cmake -DgRPC_INSTALL=ON \ -DgRPC_BUILD_TESTS=OFF \ -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR \ ../..;
make -j 4;
make install;
popd;

cd examples/cpp/helloworld;
mkdir -p cmake/build;
pushd cmake/build;
cmake -DCMAKE_PREFIX_PATH=$MY_INSTALL_DIR ../..;
make -j 4;

./greeter_server; # Server side
#./greeter_client; # Client side