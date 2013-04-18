function(visagesPlugins_project)

    set(visagesPlugins-package-name visagesPlugins PARENT_SCOPE)

    PackageInit(visagesPlugins visagesPlugins visagesPlugins OFF OPTIONALLY_REQUIRED_FOR_PLUGINS)
    if (TARGET visagesPlugins)
        return()
    endif()

    ParseProjectArguments(visagesPlugins visagesPluginsp "TEST" "" ${ARGN})

    set(visagesPluginsp_TESTING OFF)
    if (${visagesPluginsp_TEST})
        set(visagesPluginsp_TESTING ON)
    endif()

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git@github.com:medInria/medInria-visages.git")
    endif()
    
    if (${CMAKE_HOST_UNIX} AND ${CMAKE_SYSTEM_PROCESSOR} MATCHES x86_64|amd64)    
        set(ep_common_cxx_flags "${ep_common_cxx_flags} -fPIC")
    endif()
    
    SetExternalProjectsDirs(visagesPlugins ep_build_dirs)
    ExternalProject_Add(visagesPlugins
        ${ep_build_dirs}
        ${location}
        CMAKE_GENERATOR ${gen}
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        CMAKE_CACHE_ARGS
            ${ep_common_cache_args}
            -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
            -DBUILD_TESTING:BOOL=${visagesPluginsp_TESTING}
            -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
            -Ddtk_DIR:FILEPATH=${dtk_DIR}
            -DITK_DIR:FILEPATH=${ITK_DIR}
            -DVTK_DIR:FILEPATH=${VTK_DIR}
            -DmedInria_DIR:FILEPATH=${medInria_DIR}
            -DVistal_DIR:FILEPATH=${vistal_DIR}
            -DQTSHANOIR_DIR:FILEPATH=${qtShanoir_DIR}
            -DANIMA-MATHS_DIR:FILEPATH=${animaMath_DIR}
            -DANIMA-FILTERING_DIR:FILEPATH=${animaFiltering_DIR}
            -DANIMA-REGISTRATION_DIR:FILEPATH=${animaRegistration_DIR}            
        DEPENDS qtShanoir vistal animaMath animaFiltering animaRegistration
    )
    ExternalForceBuild(visagesPlugins)
    

    ExternalProject_Get_Property(visagesPlugins binary_dir)
    set(visagesPlugins_DIR ${binary_dir} PARENT_SCOPE)

endfunction()