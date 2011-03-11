#!/bin/sh

dirty=$(git clean -n -d)
if [ ! -z "$dirty" ]; then
    echo "This script will use git clean to remove these files."
    echo $dirty
    echo "Press Ctrl-C to abort; enter to continue"
    read ok
fi

log () {
    echo "=== $name: $@"
}

info () { 
    echo "    ... $@"
}

verifyrename () {
    if jar tf $jarfile | fgrep B.class > /dev/null; then
        log "Post-rename build unexpectedly found B.class in $jarfile."
        return 1
    fi
    log "Post-rename build correct"
    return 0
}

verifydelete () {
    # A failed build is all we ask
    if [ $? = 0 ]; then
        log "Post-delete build unexpectedly succeeded!"
        return 1
    fi
    log "Delete build correct"
    return 0
}

runtest () {
    local action=$1
    local name=$2
    local build=$3
    local jarfile=$4

    info Pre-cleaning with git...
    git clean -f -d > /dev/null

    info Building...
    $build > $name-pre$action.log 2>&1 || return 1
    # This should simply succeed

    info Testing $action and incremental building...
    git checkout -q ${action}file
    $build > $name-post$action.log 2>&1
    eval verify${action}
    status=$?
    git checkout -q master
    return $status
}

runtests () {
    local name=$1
    local build=$2
    local jarfile=$3

    if type -a $name > /dev/null; then
        log "Testing $name ..."
        runtest rename $name "$build" $jarfile
        runtest delete $name "$build" $jarfile
    fi
}

runtests mvn    "mvn package"    "target/java-build-test-1.0.0.jar"
runtests gradle "gradle build"   "build/libs/java-build-test-1.0.0.jar"
runtests buildr "buildr package" "target/java-build-test-1.0.0.jar"
