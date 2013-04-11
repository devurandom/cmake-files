# Copyright (c) 2013, Dennis Schridde <dschridde@welfenlab.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

include(CheckCXXCompilerFlag)

check_cxx_compiler_flag(-std=c++11 CXX_HAS_CXX11)

if (CXX_HAS_CXX11)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif (CXX11_ALLOW_0X)
	check_cxx_compiler_flag(-std=c++0x CXX_HAS_CXX0X)

	if (CXX_HAS_CXX0X)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
	else (CXX_HAS_CXX11)
		message(FATAL_ERROR "C++11 support required. Set CXX and clear the cache")
	endif (CXX_HAS_CXX0X)
else (CXX_HAS_CXX11)
	message(FATAL_ERROR "C++11 support required. Set CXX and clear the cache")
endif (CXX_HAS_CXX11)
