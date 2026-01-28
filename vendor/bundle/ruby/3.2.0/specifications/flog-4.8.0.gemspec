# -*- encoding: utf-8 -*-
# stub: flog 4.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "flog".freeze
  s.version = "4.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "http://ruby.sadi.st/", "source_code_uri" => "https://github.com/seattlerb/flog" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ryan Davis".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDPjCCAiagAwIBAgIBBzANBgkqhkiG9w0BAQsFADBFMRMwEQYDVQQDDApyeWFu\nZC1ydWJ5MRkwFwYKCZImiZPyLGQBGRYJemVuc3BpZGVyMRMwEQYKCZImiZPyLGQB\nGRYDY29tMB4XDTIzMDEwMTA3NTExN1oXDTI0MDEwMTA3NTExN1owRTETMBEGA1UE\nAwwKcnlhbmQtcnVieTEZMBcGCgmSJomT8ixkARkWCXplbnNwaWRlcjETMBEGCgmS\nJomT8ixkARkWA2NvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALda\nb9DCgK+627gPJkB6XfjZ1itoOQvpqH1EXScSaba9/S2VF22VYQbXU1xQXL/WzCkx\ntaCPaLmfYIaFcHHCSY4hYDJijRQkLxPeB3xbOfzfLoBDbjvx5JxgJxUjmGa7xhcT\noOvjtt5P8+GSK9zLzxQP0gVLS/D0FmoE44XuDr3iQkVS2ujU5zZL84mMNqNB1znh\nGiadM9GHRaDiaxuX0cIUBj19T01mVE2iymf9I6bEsiayK/n6QujtyCbTWsAS9Rqt\nqhtV7HJxNKuPj/JFH0D2cswvzznE/a5FOYO68g+YCuFi5L8wZuuM8zzdwjrWHqSV\ngBEfoTEGr7Zii72cx+sCAwEAAaM5MDcwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAw\nHQYDVR0OBBYEFEfFe9md/r/tj/Wmwpy+MI8d9k/hMA0GCSqGSIb3DQEBCwUAA4IB\nAQAkg3y+PBnBAPWdxxITm5sPHqdWQgSyCpRA20o4LTuWr8BWhSXBkfQNa7cY6fOn\nxyM34VPzBFbExv6XOGDfOMFBVaYTHuN9peC/5/umL7kLl+nflXzL2QA7K6LYj5Bg\nsM574Onr0dZDM6Vn69bzQ7rBIFDfK/OhlPzqKZad4nsdcsVH8ODCiT+ATMIZyz5K\nWCnNtqlyiWXI8tdTpahDgcUwfcN/oN7v4K8iU5IbLJX6HQ5DKgmKjfb6XyMth16k\nROfWo9Uyp8ba/j9eVG14KkYRaLydAY1MNQk2yd3R5CGfeOpD1kttxjoypoUJ2dOG\nnsNBRuQJ1UfiCG97a6DNm+Fr\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2023-09-28"
  s.description = "Flog reports the most tortured code in an easy to read pain\nreport. The higher the score, the more pain the code is in.".freeze
  s.email = ["ryand-ruby@zenspider.com".freeze]
  s.executables = ["flog".freeze]
  s.extra_rdoc_files = ["History.rdoc".freeze, "Manifest.txt".freeze, "README.rdoc".freeze]
  s.files = ["History.rdoc".freeze, "Manifest.txt".freeze, "README.rdoc".freeze, "bin/flog".freeze]
  s.homepage = "http://ruby.sadi.st/".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Flog reports the most tortured code in an easy to read pain report".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<sexp_processor>.freeze, ["~> 4.8"])
  s.add_runtime_dependency(%q<ruby_parser>.freeze, ["~> 3.1", "> 3.1.0"])
  s.add_runtime_dependency(%q<path_expander>.freeze, ["~> 1.0"])
  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
  s.add_development_dependency(%q<rdoc>.freeze, [">= 4.0", "< 7"])
  s.add_development_dependency(%q<hoe>.freeze, ["~> 4.0"])
end
