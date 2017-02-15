raise SkipTest unless service?(:webapp)

require 'json'

class Pixelated < LeapTest
  depends_on "Network"

  def setup
  end
  def test_01_Are_daemons_running?
    assert_running service: 'pixelated-server'
    pass
  end
  def test_02_can_connect_to_useragent?
    assert_tcp_socket('localhost', '8080')
    pass
  end
end
