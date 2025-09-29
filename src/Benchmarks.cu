#include "Benchmarks.cuh"
#include <System/CudaDevice/CudaKernelLauncher.cu>
#include <System/CudaDevice/CudaDeviceUtils.cuh>

namespace mn
{

Benchmarks::Benchmarks(MPMSimulator& simulator)
    : _kSimulator(simulator)
{
}

Benchmarks::~Benchmarks() {}

void Benchmarks::run()
{
    SimulatorBuilder builder;
    auto             opt = 0;
    builder.build(_kSimulator, opt);
    _kSimulator.simulateToFrame(60);
}

}  // namespace mn
