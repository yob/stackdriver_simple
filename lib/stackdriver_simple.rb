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

    # This might have optional arguments for providing the project and credentials?
    client = Google::Cloud::Monitoring::Metric.new
    project_name = Google::Cloud::Monitoring::V3::MetricServiceClient.project_path(@google_cloud_project)

    series = Google::Monitoring::V3::TimeSeries.new
    metric = Google::Api::Metric.new type: "custom.googleapis.com/#{name}"
    series.metric = metric

    resource = Google::Api::MonitoredResource.new type: "global"
    series.resource = resource

    point = Google::Monitoring::V3::Point.new
    point.value = Google::Monitoring::V3::TypedValue.new double_value: value
    now = Time.now
    end_time = Google::Protobuf::Timestamp.new seconds: now.to_i, nanos: now.usec
    point.interval = Google::Monitoring::V3::TimeInterval.new end_time: end_time
    series.points << point

    client.create_time_series project_name, [series]
  end
end
