
Pod::Spec.new do |s|
  # NPM package specification
  package = JSON.parse(File.read(File.join(File.dirname(__FILE__), "package.json")))

  s.name         = "RNImageToPdf"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  RNImageToPdf
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author       = { package["author"]["name"] => package["author"]["email"] }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/ojcarcete/RNImageToPdf.git", :tag => "master" }
  s.source_files  = "RNImageToPdf/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  
