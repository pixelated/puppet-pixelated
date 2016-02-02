raise SkipTest unless service?(:webapp)

require 'json'

class Pixelated < LeapTest
  depends_on "Network"

  def setup
  end
  def test_01_Are_daemons_running?
    assert_running '/usr/bin/docker -d'
    assert_running '/usr/bin/pixelated-dispatcher manager'
    assert_running '/usr/bin/pixelated-dispatcher proxy'
    pass
  end
  def test_02_can_connect_to_proxy?
    assert_tcp_socket('localhost', '8080')
    pass
  end
  def test_03_can_connect_to_manager?
    assert_tcp_socket('localhost', '4443')
    pass
  end
  def test_04_can_connect_to_docker?
    assert_run('/usr/bin/docker ps')
    pass
  end
  def test_05_run_functional_tests?
    exitstatus = system('cd /srv/leap/tests_custom/functional-tests; behave --tags @staging --tags ~@wip --no-capture -k')
    if exitstatus != true
       fail "Error running functional tests" 
    end
    pass
  end
end

