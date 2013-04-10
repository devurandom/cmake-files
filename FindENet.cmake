# - Try to find ENet lib
# Once done this will define
#
#  ENET_FOUND - system has enet lib
#  ENET_LIBRARIES - the enet library
#  ENET_INCLUDE_DIR - the enet include directory

# Copyright (c) 2011, Dennis Schridde <dennis.schridde@stud.uni-hannover.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (ENET_LIBRARIES AND ENET_INCLUDE_DIR)

  # in cache already
  set(ENET_FOUND TRUE)

else (ENET_LIBRARIES AND ENET_INCLUDE_DIR)

  find_path(ENET_INCLUDE_DIR NAMES enet/enet.h
    PATH_SUFFIXES
      include
  )

  find_library(ENET_LIBRARIES enet)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(ENet DEFAULT_MSG ENET_INCLUDE_DIR ENET_LIBRARIES)
  mark_as_advanced(ENET_INCLUDE_DIR ENET_LIBRARIES)

endif(ENET_LIBRARIES AND ENET_INCLUDE_DIR)

