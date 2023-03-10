
Sidekiq.configure_server do |config|
  config.on(:startup) do
    # Configure the CRON scheduler based on the static schedule file
    schedule_file = "config/schedule.yml"
    if File.exist?(schedule_file)
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  end
end
