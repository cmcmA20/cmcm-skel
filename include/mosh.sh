#!/bin/sh

echo "NYI"
exit 1

dep_list() {
  echo "git"
}
package_install $(package_manager) $(dep_list)
