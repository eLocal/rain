# desc "Explaining what the task does"
# task :rain do
#   # Task goes here
# end

namespace :rain do
  task :config do
    File.open("#{Rails.root}/config/versions.yml", 'w') do |f|
      f.puts <<-YAML
      ---
      stage: rel_0.0.1
      production: rel_0.0.1
      YAML
    end
  end
end
