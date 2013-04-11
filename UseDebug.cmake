# Copyright (c) 2013, Dennis Schridde <dschridde@welfenlab.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

set(DEBUG_HELP "Enable debugging compiler flags")
set(DEBUG False CACHE BOOL "${DEBUG_HELP}")

include(FeatureSummary)
add_feature_info(Debug DEBUG "${DEBUG_HELP}")

if (DEBUG)
	include(CheckCCompilerFlag)
	include(CheckCXXCompilerFlag)

	check_c_compiler_flag(-Og CC_HAS_OG)
	check_cxx_compiler_flag(-Og CXX_HAS_OG)

	if (CC_HAS_OG)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Og")
	else (CC_HAS_OG)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0")
	endif (CC_HAS_OG)

	if (CXX_HAS_OG)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Og")
	else (CXX_HAS_OG)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0")
	endif (CXX_HAS_OG)

	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
endif (DEBUG)
