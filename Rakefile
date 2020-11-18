require "bundler/gem_tasks"
require 'net/ssh'
require 'net/scp'
require 'fileutils'

# task 'build:gem' do
#   host = '148.251.43.54'
#   user = 'deployer'
#   Net::SSH.start(host, user, port: 60000) do |ssh|
#     base_dir = "/home/deployer/temp/coalla-gems"
#     project_name = 'coalla-cms'
#     git_url = "git@bitbucket.org:coalla/#{project_name}.git"
#     gems_dir = '/var/www/virtual-hosts/gems.coalla.ru'
#     output = ssh.exec! <<-SH
#       mkdir --parents #{base_dir}
#       cd #{base_dir}
#       git clone #{git_url}
#       cd #{project_name}
#       source /etc/profile
#       rvm 1.9.3
#       gem build coalla-cms.gemspec
#       cp -rf *.gem #{gems_dir}/gems
#       cd #{gems_dir}
#       gem generate_index
#       rm -R #{base_dir}
#     SH
#     puts output
#   end
# end