# Dockerfile — LLVM build image (fixed permissions & build as root)
ARG LLVM_VERSION=20
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ARG LLVM_VERSION

# Basic build deps + required helper packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget gnupg lsb-release software-properties-common \
    build-essential cmake ninja-build git python3 pkg-config \
  && rm -rf /var/lib/apt/lists/*

# Install apt.llvm.org helper script and requested LLVM packages
RUN wget -q https://apt.llvm.org/llvm.sh -O /tmp/llvm.sh \
  && chmod +x /tmp/llvm.sh \
  && /tmp/llvm.sh ${LLVM_VERSION} \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
     clang-${LLVM_VERSION} \
     llvm-${LLVM_VERSION} \
     llvm-${LLVM_VERSION}-dev \
     libclang-${LLVM_VERSION}-dev \
     lld-${LLVM_VERSION} \
     llvm-${LLVM_VERSION}-tools \
  && rm -rf /var/lib/apt/lists/* /tmp/llvm.sh

ENV LLVM_DIR=/usr/lib/llvm-${LLVM_VERSION}/lib/cmake/llvm
ENV PATH=/usr/lib/llvm-${LLVM_VERSION}/bin:${PATH}

# Create user early (home dir created)
RUN useradd -ms /bin/bash builder

# Set working dir (root owns it for now)
WORKDIR /home/builder/project

# Copy project files (runs as root) and ensure ownership for the builder user
COPY . /home/builder/project
RUN chown -R builder:builder /home/builder/project

# Create build dir and make sure it's writable (CMake try_compile needs this)
RUN mkdir -p /home/builder/project/build \
  && chown -R builder:builder /home/builder/project/build

# Run CMake and build as root (avoids subtle permission restrictions during try_compile).
# If you prefer, you can switch to USER builder and run as that user instead.
RUN cmake -S /home/builder/project -B /home/builder/project/build -G Ninja -DLLVM_DIR=${LLVM_DIR} \
  && cmake --build /home/builder/project/build -- -j$(nproc)

# Make builder the user for interactive runs; build artifacts are chowned to builder earlier.
USER builder
WORKDIR /home/builder/project

CMD ["/bin/bash"]
