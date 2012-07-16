Pod::Spec.new do |s|
  s.name         = 'NJDXDAL'
  s.version      = '1.0.0'                                                                 
  s.summary      = 'Kit creates operation for http request with parsing and mapping.'
  s.homepage 	 = 'http://111minutes.com/'
  s.license	 = {
  :type => '111minutes',
  :text => <<LICENSE
		Copyright (C) 2012

               All rights reserved.
   LICENSE
  }
  s.author       = '111minutes'
  s.source       = { :git => 'https://github.com/111minutes/DXDAL-2.0.git', :tag => "v1.4" }
  s.source_files = 'NJDXDAL', 'NJDXDAL/**/*.{h,m}'                               
  s.dependency     'TBXML', '~> 1.5'
end
