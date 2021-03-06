## Copyright (c) 2015 SONATA-NFV, 2017 5GTANGO [, ANY ADDITIONAL AFFILIATION]
## ALL RIGHTS RESERVED.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## Neither the name of the SONATA-NFV, 5GTANGO [, ANY ADDITIONAL AFFILIATION]
## nor the names of its contributors may be used to endorse or promote
## products derived from this software without specific prior written
## permission.
##
## This work has been performed in the framework of the SONATA project,
## funded by the European Commission under Grant number 671517 through
## the Horizon 2020 and 5G-PPP programmes. The authors would like to
## acknowledge the contributions of their colleagues of the SONATA
## partner consortium (www.sonata-nfv.eu).
##
## This work has been performed in the framework of the 5GTANGO project,
## funded by the European Commission under Grant number 761493 through
## the Horizon 2020 and 5G-PPP programmes. The authors would like to
## acknowledge the contributions of their colleagues of the 5GTANGO
## partner consortium (www.5gtango.eu).
# encoding: utf-8
# frozen_string_literal: true
require 'active_support'
environment ENV['RACK_ENV'] || 'development'

workers 2

# Preload application is better when we run on multiple threads
preload_app!
tag '5GTANGO Gatekeeper SP component'

# Those 'before_fork' and 'on_worker_boot' hooks are recommended for
# activerecord when using preload_app
before_fork do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.connection.disconnect!
  end
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
threads 5, 16
port ENV['PORT'] || 5000
#bind 'tcp://0.0.0.0:5000'
#stdout_and_stderr_file_name=::File.join('.', 'log', environment+'.log')
#stdout_redirect stdout_and_stderr_file_name, stdout_and_stderr_file_name, true
#stdout_redirect '/u/apps/lolcat/log/stdout', '/u/apps/lolcat/log/stderr'
#stdout_redirect '/u/apps/lolcat/log/stdout', '/u/apps/lolcat/log/stderr', true
#state_path '/dev/stdout'
state_path '/app/puma.state'
#state_path './puma.state'
#activate_control_app 'unix:///var/run/pumactl.sock', { no_token: true }
activate_control_app 'tcp://0.0.0.0:9191', { no_token: true }