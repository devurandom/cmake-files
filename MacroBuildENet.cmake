# Copyright (c) 2011, Dennis Schridde <dennis.schridde@stud.uni-hannover.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

macro(build_enet)
	include(MacroParseArguments)
	parse_arguments(ENET "SOURCE_DIRECTORY;BUILD_SHARED_LIBS" "" ${ARGN})

	foreach (arg "SOURCE_DIRECTORY")
		if ("${ENET_${arg}}" STREQUAL "")
			message(FATAL_ERROR "Argument ${arg} is required")
		endif ("${ENET_${arg}}" STREQUAL "")
	endforeach (arg "SOURCE_DIRECTORY")

	if ("${ENET_BUILD_SHARED_LIBS}" STREQUAL "")
		set(ENET_BUILD_SHARED_LIBS True)
	endif ("${ENET_BUILD_SHARED_LIBS}" STREQUAL "")

	if (${ENET_BUILD_SHARED_LIBS})
		set(ENET_LIBRARY_TYPE SHARED)
	else (${ENET_BUILD_SHARED_LIBS})
		set(ENET_LIBRARY_TYPE STATIC)
	endif (${ENET_BUILD_SHARED_LIBS})


	if (ENET_LIBRARIES AND ENET_INCLUDE_DIR)

		# in cache already
		set(ENET_FOUND True)

	else (ENET_LIBRARIES AND ENET_INCLUDE_DIR)

		if (NOT IS_DIRECTORY ${ENET_SOURCE_DIRECTORY})
			message(FATAL_ERROR "ENET_SOURCE_DIRECTORY is not a directory: ${ENET_SOURCE_DIRECTORY}")
		endif (NOT IS_DIRECTORY ${ENET_SOURCE_DIRECTORY})

		set(ENET_DIR ${ENET_SOURCE_DIRECTORY})

		add_custom_command(
			OUTPUT "${ENET_DIR}/build/stamp-mkdir"
			DEPENDS "${ENET_DIR}"
			COMMAND "${CMAKE_COMMAND}" -E make_directory "${ENET_DIR}/build"
			COMMAND "${CMAKE_COMMAND}" -E touch "${ENET_DIR}/build/stamp-mkdir"
			COMMENT "Creating ENet build directory"
		)
		add_custom_command(
			OUTPUT "${ENET_DIR}/build/Makefile"
			DEPENDS
				"${ENET_DIR}/build/stamp-mkdir"
				"${ENET_DIR}/configure"
			COMMAND ../configure
			WORKING_DIRECTORY "${ENET_DIR}/build"
			COMMENT "Configuring ENet ..."
		)
		add_custom_command(
			OUTPUT "${ENET_DIR}/build/stamp-build"
			DEPENDS "${ENET_DIR}/build/Makefile"
			COMMAND make
			COMMAND "${CMAKE_COMMAND}" -E touch "${ENET_DIR}/build/stamp-build"
			WORKING_DIRECTORY "${ENET_DIR}/build"
			COMMENT "Building ENet ..."
		)
		add_custom_command(
			OUTPUT
				"${ENET_DIR}/local-install/usr/local/include/enet/enet.h"
				"${ENET_DIR}/local-install/usr/local/lib/${CMAKE_SHARED_LIBRARY_PREFIX}enet${CMAKE_SHARED_LIBRARY_SUFFIX}"
			DEPENDS "${ENET_DIR}/build/stamp-build"
			COMMAND make DESTDIR="${ENET_DIR}/local-install" install
			WORKING_DIRECTORY "${ENET_DIR}/build"
			COMMENT "Installing ENet ..."
		)
		add_custom_target(CheckENet
			DEPENDS
				"${ENET_DIR}/local-install/usr/local/include/enet/enet.h"
				"${ENET_DIR}/local-install/usr/local/lib/${CMAKE_SHARED_LIBRARY_PREFIX}enet${CMAKE_SHARED_LIBRARY_SUFFIX}"
		)

		add_library(enet "${ENET_LIBRARY_TYPE}" IMPORTED)
		add_dependencies(enet CheckENet)
		set_property(TARGET enet PROPERTY IMPORTED_LOCATION "${ENET_DIR}/local-install/usr/local/lib/${CMAKE_SHARED_LIBRARY_PREFIX}enet${CMAKE_SHARED_LIBRARY_SUFFIX}")

		message(STATUS "Using local ENet: ${ENET_DIR}")

		set(ENET_INCLUDE_DIR "${ENET_DIR}/local-install/usr/local/include")
		set(ENET_LIBRARIES enet)
		mark_as_advanced(ENET_INCLUDE_DIR ENET_LIBRARIES)

	endif (ENET_LIBRARIES AND ENET_INCLUDE_DIR)
endmacro(build_enet)
