class AnalysisSerializer
  include FastJsonapi::ObjectSerializer
  attributes :best_day
  attributes :revenue, :total_revenue do |object|
    (object.revenue / 100.0).to_s
  end
end
