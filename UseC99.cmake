# Copyright (c) 2013, Dennis Schridde <dschridde@welfenlab.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

include(CheckCCompilerFlag)

check_c_compiler_flag(-std=c99 CC_HAS_C99)

if (CC_HAS_C99)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")
else (CC_HAS_C99)
	message(FATAL_ERROR "C99 support required. Set CC and clear the cache")
endif (CC_HAS_C99)
