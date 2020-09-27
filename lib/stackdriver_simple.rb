# frozen_string_literal: true
#
require "google/cloud/monitoring"

class StackdriverSimple

  def initialize(google_cloud_project:)
    @google_cloud_project = google_cloud_project.to_s

    raise ArgumentError if @google_cloud_project.include?(" ")
  end

  # This assumes the following two ENV vars are set:
  #
  # * GOOGLE_APPLICATION_CREDENTIALS=<path-to-credentials>
  def submit_gauge(name, value)
    raise ArgumentError, "name cannot include spaces" if name.to_s.include?(" ")
    raise ArgumentError, "name cannot include /" if name.to_s.include?("/")
    raise ArgumentError, "value cannot be nil" if value.nil?

    client = Google::Cloud::Monitoring.metric_service #do |config|
    # The client can be initialised with a block to explicitly provide credentials. This
    # gem is already published  with the assumption that credentials will be loaded automatically
    # based on the GOOGLE_APPLICATION_CREDENTIALS env var, and I don't have the energy to change
    # that behaviour for now.
    # client = Google::Cloud::Monitoring.metric_service do |config|
    #  config.credentials = "/path/to/credentials.json"
    #end

    project_name = Google::Cloud::Monitoring::V3::MetricService::Paths.project_path(project: @google_cloud_project)

    series = Google::Cloud::Monitoring::V3::TimeSeries.new
    metric = Google::Api::Metric.new type: "custom.googleapis.com/#{name}"
    series.metric = metric

    resource = Google::Api::MonitoredResource.new type: "global"
    series.resource = resource

    point = Google::Cloud::Monitoring::V3::Point.new
    point.value = Google::Cloud::Monitoring::V3::TypedValue.new double_value: value
    now = Time.now
    end_time = Google::Protobuf::Timestamp.new seconds: now.to_i, nanos: now.usec
    point.interval = Google::Cloud::Monitoring::V3::TimeInterval.new end_time: end_time
    series.points << point

    client.create_time_series name: project_name, time_series: [series]
  end
end
