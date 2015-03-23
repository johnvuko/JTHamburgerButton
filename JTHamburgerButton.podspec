Pod::Spec.new do |s|
  s.name         = "JTHamburgerButton"
  s.version      = "1.0.0"
  s.summary      = "An animated hamburger button for iOS"
  s.homepage     = "https://github.com/jonathantribouharet/JTHamburgerButton"
  s.license      = { :type => 'MIT' }
  s.author       = { "Jonathan Tribouharet" => "jonathan.tribouharet@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/jonathantribouharet/JTHamburgerButton.git", :tag => s.version.to_s }
  s.source_files  = 'JTHamburgerButton/*'
  s.requires_arc = true
  s.screenshots   = ["https://raw.githubusercontent.com/jonathantribouharet/JTHamburgerButton/master/Screens/example.gif"]
end
