set(CMAKE_VERBOSE_MAKEFILE ON)
add_executable(vec_pass vec_main.cpp)
add_executable(sub_pass sub_repl_main.cpp)

target_link_libraries(vec_pass PRIVATE
        FUSE
        FUSE_Bristol
        ${MASON_PACKAGE_zlib_STATIC_LIBS}
        # pthread
)

target_link_libraries(sub_pass PRIVATE
        FUSE
        FUSE_Bristol
        FUSE_DistGraph
        flatbuffers
        ${MASON_PACKAGE_zlib_STATIC_LIBS}
)

target_include_directories(sub_pass PRIVATE
        ${FUSE_FBS_INCLUDE_PREFIX}
        ${FUSE_FLATBUFFERS_INCLUDE_DIR}
        ${FUSE_GZIP_INCLUDE_DIR})

set_target_properties(sub_pass
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

set_target_properties(vec_pass
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
