# Copyright (c) 2010, Dennis Schridde <dennis.schridde@stud.uni-hannover.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

macro(get_top_source_dir TOP_SOURCE_DIR FIND_DIR)
	set("${TOP_SOURCE_DIR}" ".")

	while (NOT IS_DIRECTORY "${${TOP_SOURCE_DIR}}/${FIND_DIR}" AND NOT "${${TOP_SOURCE_DIR}}" STREQUAL "/")
	  set("${TOP_SOURCE_DIR}" "${${TOP_SOURCE_DIR}}/..")
	  get_filename_component("${TOP_SOURCE_DIR}" "${${TOP_SOURCE_DIR}}" ABSOLUTE)
	endwhile (NOT IS_DIRECTORY "${${TOP_SOURCE_DIR}}/${FIND_DIR}" AND NOT "${${TOP_SOURCE_DIR}}" STREQUAL "/")

	if (NOT IS_DIRECTORY "${${TOP_SOURCE_DIR}}/${FIND_DIR}")
		unset("${TOP_SOURCE_DIR}")
	endif (NOT IS_DIRECTORY "${${TOP_SOURCE_DIR}}/${FIND_DIR}")
endmacro(get_top_source_dir)
