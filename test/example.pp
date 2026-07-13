# Safe Vagrant integration test for networkmanager_connection.
#
# Vagrant provides:
#   enp0s8 - NAT and `vagrant ssh`; do not modify this interface.
#   enp0s9 - unconfigured host-only test NIC.
#
# This resource creates a bridge profile but does not attach enp0s9 to it.
# Bridge-port settings are not yet exposed by networkmanager_connection.
#
# networkmanager_connection { 'br-test':
#   ensure         => 'present',
#   type           => 'bridge',
#   device         => 'br-test',
#   mtu            => 1500,
#   ipv4_method    => 'manual',
#   ipv4_addresses => ['192.168.56.10/24'],
#   ipv4_routes    => [
#     {
#       'destination' => '198.51.100.0/24',
#       'next_hop'    => '192.168.56.1',
#       'metric'      => 100,
#     },
#   ],
#   ipv6_method    => 'ignore',
#   reapply        => true,
#   auto_up        => true,
# }

# To test deletion, comment out the resource above and enable this one:
#
# networkmanager_connection { 'br-test':
#   ensure  => 'absent',
#   reapply => false,
# }

# Example: Open vSwitch (OVS) Trunk Architecture (Bridge -> Port -> Interface)
#
# networkmanager_connection { 'ovs-bridge':
#   ensure      => 'present',
#   type        => 'ovs-bridge',
#   device      => 'ovs-bridge',
#   mtu         => 9000,
#   ipv4_method => 'disabled',
#   ipv6_method => 'disabled',
# }
# 
# networkmanager_connection { 'ovs-port0':
#   ensure     => 'present',
#   type       => 'ovs-port',
#   master     => 'ovs-bridge',
# }
# 
# networkmanager_connection { 'enp0s10-ovs':
#   ensure         => 'present',
#   type           => 'ethernet',
#   device         => 'enp0s10',
#   master         => 'ovs-port0',
#   slave_type     => 'ovs-port',
#   mtu            => 9000,
#   ipv4_method    => 'manual'
#   ipv4_addresses => ['192.168.56.10/24'],
#   ipv4_gateway:  => '192.168.56.1'
#   ipv6_method: 'disabled'
#   auto_up: true
# }

# Configure the otherwise unused enp0s9 with a persistent ethernet profile.
# The provider does not activate a newly created profile automatically. Run
# `nmcli connection up enp0s9-test` after Puppet has created it.
#
# networkmanager_connection { 'enp0s9-test':
#   ensure         => 'present',
#   type           => '802-3-ethernet',
#   device         => 'enp0s9',
#   ipv4_method    => 'manual',
#   ipv4_addresses => ['192.168.56.11/24'],
#   ipv4_dns       => ['1.1.1.1'],
#   ipv4_routes    => [
#     {
#       'destination' => '198.51.100.0/24',
#       'next_hop'    => '192.168.56.1',
#       'metric'      => 100,
#     },
#   ],
#   ipv6_method    => 'ignore',
#   reapply        => false,
# }

# To remove the test profile, replace the resource above with:
#
# networkmanager_connection { 'enp0s9-test':
#   ensure  => 'absent',
#   reapply => false,
# }
