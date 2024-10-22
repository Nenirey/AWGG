#!/usr/bin/env bash
# if you compile first time you must change variable "lazpath" and "lcl"
# after it execute this script with parameter "all" at awgg dir
# "./build.sh all" it build awgg
#                                                 by Segator
# You can execute this script with different parameters:
# default - compiling AWGG only (using by default)

function log
{
    declare -rAi TAG=(
        [error]=31
        [info]=32
        [audit]=33
    )
    printf '%(%y-%m-%d_%T)T\x1b[%dm\t%s:\t%b\x1b[0m\n' -1 "${TAG[${1,,:?}]}" "${1^^}" "${2:?}" 1>&2
    if [[ ${1} == 'error' ]]; then
        return 1
    fi
}

function clean # Clean up all temporary files
{
    find . -iname '*.compiled' -delete
    find . -iname '*.ppu' -delete
    find . -iname '*.o' -delete
    find src/ -iname '*.bak' -delete
    find src/ -iname '*.or' -delete

    rm -f src/awgg.res doublecmd
    rm -f tools/extractdwrflnfo
    rm -rf src/lib
    rm -rf src/backup
    rm -r units/*
    rm -f src/versionitis

    # Remove debug files
    rm -f  awgg.zdli awgg.dbg
    rm -rf awgg.dSYM
    rm -f awgg
}

function prepare
{
    log 'info' 'Download dep'
    sudo apt-get update
    sudo apt-get install -y lazarus
}

function version_itis
{
    "${lazbuild}" src/versionitis.lpi # Build versionitis
    src/versionitis -verbose          # Update version
}

function extract_dwrflnfo
{
    "${lazbuild}" tools/extractdwrflnfo.lpi # Build Dwarf LineInfo Extractor
    chmod a+x 'tools/extractdwrflnfo'
    declare -r DWARF='awgg.dSYM/Contents/Resources/DWARF/awgg'
    if [[ -f "${DWARF}" ]]; then
        mv -vf "${DWARF}" "${PWD}/awgg.dbg"
    fi
    tools/extractdwrflnfo awgg.dbg
}

function build_default
{
    "${lazbuild}" src/awgg.lpi "${AWGG_ARCH[@]}" # Build AWGG
    strip awgg                                # Strip debug info
}

function build_beta
{
    version_itis
    "${lazbuild}" src/awgg.lpi --bm=beta "${AWGG_ARCH[@]}" # Build AWGG
    extract_dwrflnfo                                       # Extract debug line info
    strip awgg                                             # Strip debug info
}

function build_release
{
    version_itis
    "${lazbuild}" src/awgg.lpi --bm=release "${AWGG_ARCH[@]}" # Build AWGG
    extract_dwrflnfo                                          # Extract debug line info
    strip awgg                                                # Strip debug info
}

function main
{
    set -eo pipefail
    lazbuild=$(which lazbuild) # path to lazbuild
    export lazbuild

    # Set up widgetset: gtk or gtk2 or qt
    # Set up processor architecture: i386 or x86_64
    if [[ ${2} ]]; then
        export lcl=${2}
    fi
    if [[ ${lcl} ]] && [[ ${CPU_TARGET} ]]; then
        export -a AWGG_ARCH=("--widgetset=${lcl}" "--cpu=${CPU_TARGET}")
    elif [[ ${lcl} ]]; then
        export -a AWGG_ARCH=("--widgetset=${lcl}")
    elif [[ ${CPU_TARGET} ]]; then
        export -a AWGG_ARCH=("--cpu=${CPU_TARGET}")
    fi
    case ${1} in
        ci)
            prepare
            build_default
        ;;
        clean)   clean;;
        beta)    build_beta;;
        release) build_release;;
        all)     build_default;;
    esac
}

main "${@}"
