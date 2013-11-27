# Copyright (c) 2013, Dennis Schridde <dschridde@welfenlab.de>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

set(OPTIMISE_HELP "Enable optimisation compiler flags")
set(OPTIMISE False CACHE BOOL "${OPTIMISE_HELP}")
set(OPTIMISE_ARCH False CACHE BOOL "Enable arch specific optimisations")
set(OPTIMISE_EXTREME False CACHE BOOL "Enable optimisations that may affect code correctness")

if (OPTIMISE AND DEBUG)
	message(WARNING "Debug and Optimise enabled -- Debug takes precedence")
	set(OPTIMISE False)
endif (OPTIMISE AND DEBUG)

include(FeatureSummary)
add_feature_info(Optimise OPTIMISE "${OPTIMISE_HELP}")

if (OPTIMISE)
	include(CheckCCompilerFlag)
	include(CheckCXXCompilerFlag)

	check_c_compiler_flag(-O2 CC_HAS_O2)
	check_cxx_compiler_flag(-O2 CXX_HAS_O2)

	check_c_compiler_flag(-flto CC_HAS_LTO)
	check_cxx_compiler_flag(-flto CXX_HAS_LTO)

	check_c_compiler_flag(-fuse-linker-plugin CC_HAS_LINKER_PLUGIN)
	check_cxx_compiler_flag(-fuse-linker-plugin CXX_HAS_LINKER_PLUGIN)

	if (OPTIMISE_ARCH)
		check_c_compiler_flag(-march=native CC_HAS_MARCH_NATIVE)
		check_cxx_compiler_flag(-march=native CXX_HAS_MARCH_NATIVE)

		check_c_compiler_flag(-mfpmath=sse CC_HAS_MFPMATH_SSE)
		check_cxx_compiler_flag(-mfpmath=sse CXX_HAS_MFPMATH_SSE)
	endif (OPTIMISE_ARCH)

	if (OPTIMISE_EXTREME)
		check_c_compiler_flag(-O3 CC_HAS_O3)
		check_cxx_compiler_flag(-O3 CXX_HAS_O3)

		check_c_compiler_flag(-ffast-mmath CC_HAS_FAST_MATH)
		check_cxx_compiler_flag(-ffast-mmath CXX_HAS_FAST_MATH)

		check_c_compiler_flag(-ftree-vectorize CC_HAS_TREE_VECTORIZE)
		check_cxx_compiler_flag(-ftree-vectorize CXX_HAS_TREE_VECTORIZE)
	endif (OPTIMISE_EXTREME)

	if (CC_HAS_O2)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2")
	endif (CC_HAS_O2)
	if (CXX_HAS_O2)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
	endif (CXX_HAS_O2)

	if (CC_HAS_LTO)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -flto")
	endif (CC_HAS_LTO)
	if (CXX_HAS_LTO)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -flto")
	endif (CXX_HAS_LTO)
	if (CC_HAS_LTO AND CXX_HAS_LTO)
		set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -flto")
		set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -flto")
		set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -flto")
	endif (CC_HAS_LTO AND CXX_HAS_LTO)
	if (CC_HAS_LINKER_PLUGIN AND CXX_HAS_LINKER_PLUGIN)
		set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-linker-plugin")
		set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fuse-linker-plugin")
		set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -fuse-linker-plugin")
	endif (CC_HAS_LINKER_PLUGIN AND CXX_HAS_LINKER_PLUGIN)

	if (OPTIMISE_ARCH)
		if (CC_HAS_MARCH_NATIVE)
			set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=native")
		endif (CC_HAS_MARCH_NATIVE)
		if (CXX_HAS_MARCH_NATIVE)
			set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")
		endif (CXX_HAS_MARCH_NATIVE)

		if (CC_HAS_MFPMATH_SSE)
			set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfpmath=sse")
		endif (CC_HAS_MFPMATH_SSE)
		if (CXX_HAS_MFPMATH_SSE)
			set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfpmath=sse")
		endif (CXX_HAS_MFPMATH_SSE)
	endif (OPTIMISE_ARCH)

	if (OPTIMISE_EXTREME)
		if (CC_HAS_O3)
			set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
		endif (CC_HAS_O3)
		if (CXX_HAS_O3)
			set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
		endif (CXX_HAS_O3)

		if (CC_HAS_FAST_MATH)
			set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffast-math")
		endif (CC_HAS_FAST_MATH)
		if (CXX_HAS_FAST_MATH)
			set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ffast-math")
		endif (CXX_HAS_FAST_MATH)

		if (CC_HAS_TREE_VECTORIZE)
			set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ftree-vectorize")
		endif (CC_HAS_TREE_VECTORIZE)
		if (CXX_HAS_TREE_VECTORIZE)
			set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ftree-vectorize")
		endif (CXX_HAS_TREE_VECTORIZE)
	endif (OPTIMISE_EXTREME)
endif (OPTIMISE)
