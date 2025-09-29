cmake_minimum_required(VERSION 3.27)

project(mpm)

include(cmake/utils.cmake)
pull_all_submodules()

find_package(ZLIB REQUIRED)

set(CMAKE_CXX_STANDARD 17)

enable_language(CXX CUDA)

# ---------------------------------------------------------------------
# External Libraries
# Partio
# ---------------------------------------------------------------------
add_subdirectory(external)

# ---------------------------------------------------------------------
# MPM-CPP
# ---------------------------------------------------------------------
add_library(mpm-cpp STATIC)
target_sources(mpm-cpp PRIVATE
	src/Simulation/Material/Material.cpp
	src/Simulation/Particle/ParticleDomain.cpp
	src/Simulation/Grid/GridDomain.cpp
	src/Simulation/DomainTransform/DomainTransformer.cpp
	src/Simulation/MPM/Simulator.cpp
	src/Simulation/MPM/SimulatorBuilder.cpp
	src/MnBase/Math/Probability/Probability.cpp)
target_include_directories(mpm-cpp PUBLIC src/)
target_link_libraries(mpm-cpp PRIVATE ZLIB::ZLIB partio)
target_compile_definitions(mpm-cpp PRIVATE -DMPM_PROJECT_SOURCE_DIR="${PROJECT_SOURCE_DIR}/src")

# ---------------------------------------------------------------------
# MPM-CUDA
# ---------------------------------------------------------------------
set(CMAKE_CUDA_ARCHITECTURES native)
add_library(mpm-cuda STATIC)

set_target_properties(mpm-cuda PROPERTIES
	CUDA_SEPARABLE_COMPILATION ON
    CUDA_RESOLVE_DEVICE_SYMBOLS ON
	CUDA_STANDARD 17
	CUDA_STANDARD_REQUIRED ON
)

target_sources(mpm-cuda PRIVATE
	src/Simulation/MPM/Simulator.cu
	src/Simulation/MPM/SimulatorKernels.cu
	src/Simulation/Particle/ParticleDomain.cu
	src/Simulation/Particle/ParticleKernels.cu
	src/Simulation/DomainTransform/DomainTransformer.cu
	src/Simulation/DomainTransform/DomainTransformKernels.cu
	src/Simulation/Grid/GridDomain.cu
	src/Simulation/Grid/GridKernels.cu
	src/Simulation/TimeIntegrator/MPMTimeIntegrator.cu
	src/Simulation/TimeIntegrator/ExplicitTimeIntegrator.cu
	src/Simulation/TimeIntegrator/ImplicitTimeIntegrator.cu
	src/Simulation/TimeIntegrator/P2GKernels.cu
	src/Simulation/TimeIntegrator/GridUpdateKernels.cu
	src/Simulation/TimeIntegrator/G2PKernels.cu
	src/Simulation/TimeIntegrator/MPMComputationKernels.cu
	src/Benchmarks.cu
	src/MnBase/Math/Matrix/MatrixKernels.cu
	src/System/CudaDevice/CudaDeviceUtils.cu
	src/System/CudaDevice/CudaDevice.cpp
	src/SPGrid_Geometry.cpp
	src/SPGrid_Utilities.cpp
	src/System/CudaDevice/CudaHostUtils.hpp
)
target_include_directories(mpm-cuda PUBLIC src/)
target_link_libraries(mpm-cuda PRIVATE mpm-cpp ZLIB::ZLIB)
target_link_libraries(mpm-cuda PUBLIC partio)
target_compile_definitions(mpm-cuda PRIVATE -DMPM_PROJECT_SOURCE_DIR="${PROJECT_SOURCE_DIR}/src")

# ---------------------------------------------------------------------
# Executable
# ---------------------------------------------------------------------
add_executable(main src/main.cpp)
target_link_libraries(main PRIVATE mpm-cuda)