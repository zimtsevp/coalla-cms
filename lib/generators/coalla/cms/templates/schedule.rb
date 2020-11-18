set :output, {error: 'log/error.log', standard: 'log/cron.log'}
job_type :runner, "cd :path && rvmsudo -u www-data bundle exec rails runner -e :environment ':task' :output"
job_type :rake, "cd :path && rvmsudo -u www-data RAILS_ENV=:environment bundle exec rake :task :output"
