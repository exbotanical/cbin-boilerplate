ROOT_DIR="$(dirname "$(readlink -f $BASH_SOURCE)")"

# shellcheck source=utils/shpec_utils.bash
. "$ROOT_DIR/utils/shpec_utils.bash"

describe '<project>'
  it 'todo'
    assert equal 1 1
  ti
end_describe
