gem("pg", "XXX")
gem("thin", "XXX")
gem "will_paginate", "~> 3.0.3"

gem_group :development do
 gem "annotate", "~> 2.5.0"
 gem "pry", "~> 0.9.10"
end

gem_group :test, :development do
 gem "faker", "~> 1.0.1"
end

gem_group :test do
 gem "spork", "~> 0.9.2"
end

