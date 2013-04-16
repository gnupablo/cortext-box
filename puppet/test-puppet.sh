#!/bin/sh
##Testing all puppet manifests with puppet-lint (https://github.com/rodjek/puppet-lint)
find -name '*.pp' | xargs -n 1 -t puppet parser validate
find -name '*.pp' | xargs -n 1 -t puppet-lint --error-level error

