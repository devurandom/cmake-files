# Copyright (c) 2010, Dennis Schridde <dennis.schridde@stud.uni-hannover.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

macro(download_file)
	include(MacroParseArguments)
	parse_arguments(DOWNLOAD_FILE "FILE;URL;MD5SUM;STATUS" "VERBOSE;VERBOSE_ERRORS" ${ARGN})

	foreach (arg "FILE" "URL" "MD5SUM")
		if ("${DOWNLOAD_FILE_${arg}}" STREQUAL "")
			message(FATAL_ERROR "${arg} argument required")
		endif ("${DOWNLOAD_FILE_${arg}}" STREQUAL "")
	endforeach(arg "FILE" "URL" "MD5SUM")

	if (DOWNLOAD_FILE_VERBOSE)
		set(DOWNLOAD_FILE_VERBOSE_ERRORS True)
	endif (DOWNLOAD_FILE_VERBOSE)

	if (NOT DOWNLOAD_FILE_VERBOSE_ERRORS AND NOT "${DOWNLOAD_FILE_STATUS}" STREQUAL "")
		message("WARNING: Neither VERBOSE_ERRORS nor STATUS set, will not report any errors!")
	endif (NOT DOWNLOAD_FILE_VERBOSE_ERRORS AND NOT "${DOWNLOAD_FILE_STATUS}" STREQUAL "")


	execute_process(
		COMMAND ${CMAKE_COMMAND} -E md5sum ${DOWNLOAD_FILE_FILE}
		OUTPUT_VARIABLE FOUND_MD5SUM
		ERROR_QUIET
	)
	if (NOT "${FOUND_MD5SUM}" MATCHES "^${DOWNLOAD_FILE_MD5SUM}")
		if (DOWNLOAD_FILE_VERBOSE)
			message("Downloading ${DOWNLOAD_FILE_FILE} ...")
		endif (DOWNLOAD_FILE_VERBOSE)

		file(DOWNLOAD ${DOWNLOAD_FILE_URL} ${DOWNLOAD_FILE_FILE} STATUS DOWNLOAD_STATUS)

		list(GET DOWNLOAD_STATUS 0 TMP)
		if (NOT ${TMP} EQUAL 0)
			if (NOT "${DOWNLOAD_FILE_STATUS}" STREQUAL "")
				set(${DOWNLOAD_FILE_STATUS} False)
			endif (NOT "${DOWNLOAD_FILE_STATUS}" STREQUAL "")

			if (DOWNLOAD_FILE_VERBOSE_ERRORS)
				list(GET DOWNLOAD_STATUS 1 TMP)
				message(SEND_ERROR "Download failed: ${TMP}")
			endif (DOWNLOAD_FILE_VERBOSE_ERRORS)

			return()
		endif (NOT ${TMP} EQUAL 0)

		if (DOWNLOAD_FILE_VERBOSE)
			message("Verifying downloaded ${DOWNLOAD_FILE_FILE} ...")
		endif (DOWNLOAD_FILE_VERBOSE)

		execute_process(
			COMMAND ${CMAKE_COMMAND} -E md5sum ${DOWNLOAD_FILE_FILE}
			OUTPUT_VARIABLE FOUND_MD5SUM
			ERROR_QUIET
		)

		if (NOT "${FOUND_MD5SUM}" MATCHES "^${DOWNLOAD_FILE_MD5SUM}")
			if (NOT "${DOWNLOAD_FILE_STATUS}" STREQUAL "")
				set(${DOWNLOAD_FILE_STATUS} False)
			endif (NOT "${DOWNLOAD_FILE_STATUS}" STREQUAL "")

			if (DOWNLOAD_FILE_VERBOSE_ERRORS)
				string(STRIP "${DOWNLOAD_FILE_MD5SUM}" TMP_EXPECTED)
				string(STRIP "${FOUND_MD5SUM}" TMP_GOT)
				message(SEND_ERROR "Download failed: md5sum mismatch! Expected: ${TMP_EXPECTED}, got: ${TMP_GOT}")
			endif (DOWNLOAD_FILE_VERBOSE_ERRORS)
	
			return()
		endif (NOT "${FOUND_MD5SUM}" MATCHES "^${DOWNLOAD_FILE_MD5SUM}")

	endif (NOT "${FOUND_MD5SUM}" MATCHES "^${DOWNLOAD_FILE_MD5SUM}")
endmacro(download_file)
