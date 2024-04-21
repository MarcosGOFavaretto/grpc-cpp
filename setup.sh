# Executes "https://grpc.io/docs/languages/cpp/quickstart/" quick start.

export MY_INSTALL_DIR=$HOME/.local;
mkdir -p $MY_INSTALL_DIR;
export PATH="$MY_INSTALL_DIR/bin:$PATH";

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