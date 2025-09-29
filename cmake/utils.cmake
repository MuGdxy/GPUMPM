# Pull Submodule
# git submodule update --init
function(pull_all_submodules)
  message(STATUS "Pulling all submodules...")
  execute_process(COMMAND git submodule update --init
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    RESULT_VARIABLE result
    OUTPUT_VARIABLE output
    ERROR_VARIABLE error_output
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_STRIP_TRAILING_WHITESPACE)
  if(NOT result EQUAL "0")
    message(FATAL_ERROR "Error pulling submodules: ${error_output}")
  else()
    message(STATUS "Submodules pulled successfully. ${output}")
  endif()
endfunction()
    
