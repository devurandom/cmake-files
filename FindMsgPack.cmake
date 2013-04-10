# - Try to find MsgPack lib
# Once done this will define
#
#  MSGPACK_FOUND - system has msgpack lib
#  MSGPACK_LIBRARIES - the msgpack library
#  MSGPACK_INCLUDE_DIR - the msgpack include directory

# Copyright (c) 2011, Dennis Schridde <dennis.schridde@stud.uni-hannover.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (MSGPACK_LIBRARIES AND MSGPACK_INCLUDE_DIR)

  # in cache already
  set(MSGPACK_FOUND TRUE)

else (MSGPACK_LIBRARIES AND MSGPACK_INCLUDE_DIR)

  find_path(MSGPACK_INCLUDE_DIR NAMES msgpack.h
    PATH_SUFFIXES
      include
  )

  find_library(MSGPACK_LIBRARIES msgpack)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(MsgPack DEFAULT_MSG MSGPACK_INCLUDE_DIR MSGPACK_LIBRARIES)
  mark_as_advanced(MSGPACK_INCLUDE_DIR MSGPACK_LIBRARIES)

endif(MSGPACK_LIBRARIES AND MSGPACK_INCLUDE_DIR)

