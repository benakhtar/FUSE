#
# MIT License
#
# Copyright (c) 2022 Nora Khayata
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set(CMAKE_VERBOSE_MAKEFILE ON)
add_executable(fuse_dev_tutorial Tutorial.cpp)

target_link_libraries(fuse_dev_tutorial PRIVATE
FUSE
FUSE_Bristol
# FUSE_HyCC
# FUSE_MOTION
flatbuffers
${MASON_PACKAGE_zlib_STATIC_LIBS}
FUSE_DistGraph
)

target_include_directories(fuse_dev_tutorial PRIVATE
        ${FUSE_FBS_INCLUDE_PREFIX}
        ${FUSE_FLATBUFFERS_INCLUDE_DIR}
        ${FUSE_GZIP_INCLUDE_DIR})

set_target_properties(fuse_dev_tutorial
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
