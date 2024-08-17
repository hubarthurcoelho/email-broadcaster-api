# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

namespace :docker do
  desc "Build and run all related containers"
  task :build do
    sh "docker compose up -d --build"
  end

  desc "Take down all related containers"
  task :down do
    sh "docker compose down"
  end

  desc "Take down all related containers and volumes"
  task :downv do
    sh "docker compose down -v"
  end
end

namespace :app do
  desc "Opens logs in terminal"
  task :logs do
    sh "docker logs --follow email_broadcaster_api"
  end

  desc "Opens app rails console in terminal"
  task :console do
    sh "docker exec -it email_broadcaster_api rails c"
  end

  desc "Opens app terminal"
  task :terminal do
    sh "docker exec -it email_broadcaster_api /bin/bash"
  end
end

namespace :specs do
  desc "Run all specs"
  task :run do
    sh "docker exec -it email_broadcaster_api bundle exec rspec"
  end
end
