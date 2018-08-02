Pod::Spec.new do |s|
  s.name             = "ZenKit"
  s.summary          = "Common base code."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/zenangst/ZenKit"
  s.license          = 'MIT'
  s.author           = { "Christoffer Winterkvist" => "christoffer@winterkvist.com" }
  s.source           = {
    :git => "https://github.com/zenangst/ZenKit.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/zenangst'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.2'

  s.requires_arc = true

  s.subspec 'Algoritms' do |cs|
    cs.ios.source_files = 'Sources/Shared/Algorithms/**'
    cs.tvos.source_files = 'Sources/Shared/Algorithms/**'
    cs.osx.source_files = 'Sources/Shared/Algorithms/**'
  end

  s.subspec 'Codable' do |cs|
    cs.ios.source_files = 'Sources/Shared/Codable/**'
    cs.tvos.source_files = 'Sources/Shared/Codable/**'
    cs.osx.source_files = 'Sources/Shared/Codable/**'
  end

  s.subspec 'Core' do |cs|
    cs.dependency 'ZenKit/TypeAlias'
    cs.ios.source_files = 'Sources/Shared/Extensions/**'
    cs.tvos.source_files = 'Sources/Shared/Extensions/**'
    cs.osx.source_files = 'Sources/Shared/Extensions/**'
  end

  s.subspec 'Core' do |cs|
    cs.dependency 'ZenKit/TypeAlias'
    cs.ios.source_files = 'Sources/Shared/CoreData/**'
    cs.tvos.source_files = 'Sources/Shared/CoreData/**'
    cs.osx.source_files = 'Sources/Shared/CoreData/**'
  end

  s.subspec 'CollectionView' do |cs|
    cs.ios.source_files = 'Sources/iOS+tvOS/CollectionView/*'
    cs.tvos.source_files = 'Source/iOS+tvOS/CollectionView/*'
    cs.osx.source_files = 'Sources/macOS/CollectionView/*'
  end

  s.subspec 'Dequeue' do |cs|
    cs.dependency 'ZenKit/TypeAlias'
    cs.ios.source_files = 'Sources/Shared/Dequeue/*'
    cs.tvos.source_files = 'Sources/Shared/Dequeue/*'
    cs.osx.source_files = 'Sources/Shared/Dequeue/*'
  end

  s.subspec 'GrandCentralDispatch' do |cs|
    cs.ios.source_files = 'Sources/Shared/GrandCentralDispatch/*'
    cs.tvos.source_files = 'Sources/Shared/GrandCentralDispatch/*'
    cs.osx.source_files = 'Sources/Shared/GrandCentralDispatch/*'
  end

  s.subspec 'Operations' do |cs|
    cs.ios.source_files = 'Sources/Shared/Operations/*'
    cs.tvos.source_files = 'Sources/Shared/Operations/*'
    cs.osx.source_files = 'Sources/Shared/Operations/*'
  end

  s.subspec 'TypeAlias' do |cs|
    cs.ios.source_files = 'Sources/Shared/TypeAlias.swift'
    cs.tvos.source_files = 'Sources/Shared/TypeAlias.swift'
    cs.osx.source_files = 'Sources/Shared/TypeAlias.swift'
  end

  s.subspec 'UserDefaults' do |cs|
    cs.ios.source_files = 'Sources/Shared/UserDefaults'
    cs.tvos.source_files = 'Sources/Shared/UserDefaults'
    cs.osx.source_files = 'Sources/Shared/UserDefaults'
  end

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end
