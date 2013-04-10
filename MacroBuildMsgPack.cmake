# Copyright (c) 2011, Dennis Schridde <dennis.schridde@stud.uni-hannover.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

macro(build_msgpack)
	include(MacroParseArguments)
	parse_arguments(MSGPACK "SOURCE_DIRECTORY;BUILD_SHARED_LIBS" "" ${ARGN})

	foreach (arg "SOURCE_DIRECTORY")
		if ("${MSGPACK_${arg}}" STREQUAL "")
			message(FATAL_ERROR "Argument ${arg} is required")
		endif ("${MSGPACK_${arg}}" STREQUAL "")
	endforeach (arg "SOURCE_DIRECTORY")

	if ("${MSGPACK_BUILD_SHARED_LIBS}" STREQUAL "")
		set(MSGPACK_BUILD_SHARED_LIBS True)
	endif ("${MSGPACK_BUILD_SHARED_LIBS}" STREQUAL "")

	if (${MSGPACK_BUILD_SHARED_LIBS})
		set(MSGPACK_LIBRARY_TYPE SHARED)
	else (${MSGPACK_BUILD_SHARED_LIBS})
		set(MSGPACK_LIBRARY_TYPE STATIC)
	endif (${MSGPACK_BUILD_SHARED_LIBS})


	if (MSGPACK_LIBRARIES AND MSGPACK_INCLUDE_DIR)

		# in cache already
		set(MSGPACK_FOUND True)

	else (MSGPACK_LIBRARIES AND MSGPACK_INCLUDE_DIR)

		if (NOT IS_DIRECTORY ${MSGPACK_SOURCE_DIRECTORY})
			message(FATAL_ERROR "MSGPACK_SOURCE_DIRECTORY is not a directory: ${MSGPACK_SOURCE_DIRECTORY}")
		endif (NOT IS_DIRECTORY ${MSGPACK_SOURCE_DIRECTORY})

		set(MSGPACK_DIR ${MSGPACK_SOURCE_DIRECTORY})

		add_custom_command(
			OUTPUT "${MSGPACK_DIR}/build/stamp-mkdir"
			DEPENDS "${MSGPACK_DIR}"
			COMMAND "${CMAKE_COMMAND}" -E make_directory "${MSGPACK_DIR}/build"
			COMMAND "${CMAKE_COMMAND}" -E touch "${MSGPACK_DIR}/build/stamp-mkdir"
			COMMENT "Creating MsgPack build directory"
		)
		add_custom_command(
			OUTPUT "${MSGPACK_DIR}/cpp/configure"
			DEPENDS "${MSGPACK_DIR}/cpp/bootstrap"
			COMMAND ./bootstrap
			WORKING_DIRECTORY "${MSGPACK_DIR}/cpp"
			COMMENT "Bootstrapping MsgPack ..."
		)
		add_custom_command(
			OUTPUT "${MSGPACK_DIR}/build/Makefile"
			DEPENDS
				"${MSGPACK_DIR}/build/stamp-mkdir"
				"${MSGPACK_DIR}/cpp/configure"
			COMMAND ../cpp/configure
			WORKING_DIRECTORY "${MSGPACK_DIR}/build"
			COMMENT "Configuring MsgPack ..."
		)
		add_custom_command(
			OUTPUT "${MSGPACK_DIR}/build/stamp-build"
			DEPENDS "${MSGPACK_DIR}/build/Makefile"
			COMMAND make
			COMMAND "${CMAKE_COMMAND}" -E touch "${MSGPACK_DIR}/build/stamp-build"
			WORKING_DIRECTORY "${MSGPACK_DIR}/build"
			COMMENT "Building MsgPack ..."
		)
		add_custom_command(
			OUTPUT
				"${MSGPACK_DIR}/local-install/usr/local/include/msgpack.h"
				"${MSGPACK_DIR}/local-install/usr/local/lib/${CMAKE_SHARED_LIBRARY_PREFIX}msgpack${CMAKE_SHARED_LIBRARY_SUFFIX}"
			DEPENDS "${MSGPACK_DIR}/build/stamp-build"
			COMMAND make DESTDIR="${MSGPACK_DIR}/local-install" install
			WORKING_DIRECTORY "${MSGPACK_DIR}/build"
			COMMENT "Installing MsgPack ..."
		)
		add_custom_target(CheckMsgPack
			DEPENDS
				"${MSGPACK_DIR}/local-install/usr/local/include/msgpack.h"
				"${MSGPACK_DIR}/local-install/usr/local/lib/${CMAKE_SHARED_LIBRARY_PREFIX}msgpack${CMAKE_SHARED_LIBRARY_SUFFIX}"
		)

		add_library(msgpack "${MSGPACK_LIBRARY_TYPE}" IMPORTED)
		add_dependencies(msgpack CheckMsgPack)
		set_property(TARGET msgpack PROPERTY IMPORTED_LOCATION "${MSGPACK_DIR}/local-install/usr/local/lib/${CMAKE_SHARED_LIBRARY_PREFIX}msgpack${CMAKE_SHARED_LIBRARY_SUFFIX}")

		message(STATUS "Using local MsgPack: ${MSGPACK_DIR}")

		set(MSGPACK_INCLUDE_DIR "${MSGPACK_DIR}/local-install/usr/local/include")
		set(MSGPACK_LIBRARIES msgpack)
		mark_as_advanced(MSGPACK_INCLUDE_DIR MSGPACK_LIBRARIES)

	endif (MSGPACK_LIBRARIES AND MSGPACK_INCLUDE_DIR)
endmacro(build_msgpack)
