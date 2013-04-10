# - Try to find GLEW lib
# Once done this will define
#
#  GLEW_FOUND - system has glew lib
#  GLEW_LIBRARY - the glew library
#  GLEW_INCLUDE_DIR - the glew include directory

# Copyright (c) 2010, Dennis Schridde <dennis.schridde@stud.uni-hannover.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (GLEW_LIBRARY AND GLEW_INCLUDE_DIR)

  # in cache already
  set(GLEW_FOUND TRUE)

else (GLEW_LIBRARY AND GLEW_INCLUDE_DIR)

  find_path(GLEW_INCLUDE_DIR NAMES GL/glew.h
    PATH_SUFFIXES
      include
  )

  find_library(GLEW_LIBRARY GLEW)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(GLEW DEFAULT_MSG GLEW_INCLUDE_DIR GLEW_LIBRARY)
  mark_as_advanced(GLEW_INCLUDE_DIR GLEW_LIBRARY)

endif(GLEW_LIBRARY AND GLEW_INCLUDE_DIR)

