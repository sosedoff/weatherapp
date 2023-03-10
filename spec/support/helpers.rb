module SpecHelpers
  def fixture_file(path)
    Rails.root.join("spec/fixtures/#{path}")
  end

  def read_fixture_file(path)
    File.read(fixture_file(path))
  end

  def read_json_fixture(path)
    JSON.load(read_fixture_file(path))
  end

  def enqueued_jobs(klass = nil)
    klass = klass.to_s if klass
    jobs = ApplicationJob.queue_adapter.enqueued_jobs
    jobs.reject! { |j| j["job_class"] != klass } if klass
    jobs
  end
end
